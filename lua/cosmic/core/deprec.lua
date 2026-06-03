-- Compatibility shim for deprecation warnings that would otherwise fire
-- on Neovim 0.13+ startup. The current session is running on a Nvim
-- nightly that already deprecated:
--
--   * `vim.treesitter.language.require_language`  (removed in 0.12)
--   * `vim.validate{ name = { value, type, optional? } }`  (will be
--     removed in 1.0; the function form is `vim.validate(name,
--     value, type, optional)`)
--
-- Several pinned plugins (noice, gitsigns, LuaSnip, blink.cmp's
-- LuaSnip integration) still call the old names. nvim's
-- `vim.deprecate` is implemented in C and only fires when the
-- *exact* function reference is the deprecated one, so we replace
-- the slot at module load with a wrapper that does the same work
-- through the new API.
--
-- Must run before `cosmic.core.pluginsInit`, which sources every
-- lazy.nvim spec.

local M = {}

local function patch_require_language()
  local ok, lang_mod = pcall(require, 'vim.treesitter.language')
  if not ok or type(lang_mod) ~= 'table' then
    return
  end
  if type(lang_mod.require_language) ~= 'function' then
    return
  end
  if type(lang_mod.add) ~= 'function' then
    return
  end

  -- The old 4-positional-arg form: (lang, path, silent, symbol_name).
  -- noice calls it as `require_language(lang, nil, true)` and
  -- `require_language(lang)`; nvim-treesitter calls it as
  -- `pcall(require_language, lang)`. Forward each variant to
  -- `add(lang, opts)` so the call site still receives the same
  -- boolean the caller asked for.
  lang_mod.require_language = function(lang, path, silent, symbol_name)
    local opts = {}
    if path ~= nil then
      opts.path = path
    end
    if silent ~= nil then
      opts.silent = silent
    end
    if symbol_name ~= nil then
      opts.symbol_name = symbol_name
    end

    if silent then
      return pcall(lang_mod.add, lang, opts)
    end
    return lang_mod.add(lang, opts)
  end
end

-- The old `vim.validate` accepted a single table whose keys were
-- parameter names and whose values were `{ value, type, optional? }`
-- arrays. nvim 0.13 still accepts that form, but the deprecation
-- warning is loud and will be removed in 1.0. We detect that shape
-- and re-dispatch as the new function form so the warning is
-- silenced and the runtime behavior is identical.
local function is_old_validate_form(arg)
  if type(arg) ~= 'table' then
    return false
  end
  -- Reject empty tables and tables that look like a single value
  -- to validate (`vim.validate({ some_value })`).
  if next(arg) == nil then
    return false
  end
  for _, v in pairs(arg) do
    if type(v) ~= 'table' then
      return false
    end
    if #v < 2 then
      return false
    end
    local type_spec = v[2]
    if type(type_spec) ~= 'string' and type(type_spec) ~= 'function' then
      return false
    end
  end
  return true
end

local function patch_vim_validate()
  local original = vim.validate
  if type(original) ~= 'function' then
    return
  end

  -- Bind the original under a stable alias so callers (or future
  -- shims) can still reach the unmodified behavior.
  vim._validate_original = original

  vim.validate = function(first, ...)
    if is_old_validate_form(first) then
      -- The old form: a single table of name -> {value, type, optional}.
      -- Translate to a sequence of (name, value, type, optional) calls
      -- on the original function, preserving iteration order is not
      -- important because each spec is independent.
      for name, spec in pairs(first) do
        local value, type_spec = spec[1], spec[2]
        local optional = spec[3]
        if optional ~= nil then
          original(name, value, type_spec, optional)
        else
          original(name, value, type_spec)
        end
      end
      return
    end
    return original(first, ...)
  end
end

function M.setup()
  patch_require_language()
  patch_vim_validate()
end

return M
