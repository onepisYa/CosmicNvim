-- Compatibility shim for the bundled `nvim-treesitter` plugin on
-- Neovim 0.13. Runs BEFORE `cosmic.core.pluginsInit` so the wrappers
-- are in effect when `lazy.setup` sources any plugin file (in
-- particular `nvim-treesitter/plugin/nvim-treesitter.lua`, which
-- `nvim-ts-context-commentstring`'s Vim plugin file sources
-- eagerly).
--
-- Two problems are addressed:
--
-- 1. `nvim-treesitter` registers custom query predicates and
--    directives (e.g. `has-ancestor?`, `exclude_children!`) at
--    module load. Neovim 0.13 ships some of those names as built-ins
--    and rejects the override unless the caller passes `force = true`.
--    We wrap `vim.treesitter.query.add_predicate` and
--    `add_directive` to always pass `force = true`.
--
-- 2. `nvim-treesitter` ships query files that target legacy parsers
--    and abort the parser at load time on Neovim 0.13 (e.g. the
--    `string_content` anchor and the trailing `.` pattern in the
--    bundled `queries/lua/injections.scm`). We register empty
--    override queries for each lua query type so the file is bypassed
--    and nvim's bundled queries take over.

local M = {}

local function wrap_force(fn)
  if type(fn) ~= 'function' then
    return fn
  end
  return function(name, handler, opts, ...)
    if type(opts) == 'boolean' then
      opts = { force = opts }
    end
    opts = opts or {}
    opts.force = true
    if type(handler) == 'function' then
      local wrapped = function(match, ...)
        if type(match) == 'table' then
          local t = {}
          for k, v in pairs(match) do
            t[k] = type(v) == 'table' and v[1] or v
          end
          return handler(t, ...)
        end
        return handler(match, ...)
      end
      return fn(name, wrapped, opts, ...)
    end
    return fn(name, handler, opts, ...)
  end
end

function M.setup()
  local ok, query_mod = pcall(require, 'vim.treesitter.query')
  if not ok then
    return
  end

  if type(query_mod.add_predicate) == 'function' then
    query_mod.add_predicate = wrap_force(query_mod.add_predicate)
  end
  if type(query_mod.add_directive) == 'function' then
    query_mod.add_directive = wrap_force(query_mod.add_directive)
  end

  -- An empty query is valid: it has no patterns, no errors. The empty
  -- override is concatenated with nvim's bundled queries, so lua
  -- still gets highlights/indents/locals/folds from nvim's runtime.
  if type(query_mod.set) == 'function' then
    for _, query_name in ipairs({
      'highlights',
      'indents',
      'injections',
      'locals',
      'folds',
    }) do
      pcall(query_mod.set, 'lua', query_name, '')
    end
  end
end

return M
