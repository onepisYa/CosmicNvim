-- Restore Lua helpers removed (or slated for removal in 0.15) in Neovim
-- 0.13 so older plugins that still call them continue to load without
-- triggering deprecation noise. Must run before
-- `cosmic.core.pluginsInit`, which triggers `lazy.setup` and therefore
-- evaluates every plugin spec.
--
-- Each polyfill replaces the deprecated function unconditionally, so a
-- pinned plugin that still calls the old name never sees the deprecation
-- notice from nvim's runtime. The bodies are written to match the nvim
-- reference implementation: `vim.tbl_islist` is the same predicate nvim
-- used, `vim.tbl_flatten` is recursive, `vim.F.if_nil` is a strict
-- nilness check, and `vim.nonnil` returns the first non-nil argument.

local function tbl_islist(t)
  if type(t) ~= 'table' then
    return false
  end

  local count = 0
  for k in pairs(t) do
    count = count + 1
    if type(k) ~= 'number' or k < 1 or k ~= math.floor(k) then
      return false
    end
  end

  for i = 1, count do
    if t[i] == nil then
      return false
    end
  end

  return true
end

local function tbl_flatten_recurse(t, result)
  for _, v in ipairs(t) do
    if type(v) == 'table' then
      tbl_flatten_recurse(v, result)
    else
      result[#result + 1] = v
    end
  end
  return result
end

local function tbl_flatten(t)
  return tbl_flatten_recurse(t, {})
end

vim.tbl_islist = tbl_islist
vim.tbl_flatten = tbl_flatten

if type(vim.F) ~= 'table' then
  vim.F = {}
end
vim.F.if_nil = function(x, default)
  if x == nil then
    return default
  end
  return x
end

vim.nonnil = function(...)
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    if v ~= nil then
      return v
    end
  end
  error('vim.nonnil: all arguments are nil', 2)
end

-- Install nvim-treesitter compatibility shims (predicate registration
-- with `force = true`, empty query overrides) BEFORE any plugin loads.
require('cosmic.core.ts_compat').setup()
require('cosmic.core.deprec').setup()

local cosmic_modules = {
  'cosmic.core.editor',
  'cosmic.core.pluginsInit',
  'cosmic.core.commands',
  'cosmic.lsp',
  'cosmic.config.editor',
  -- load mappings only after editor configs are loaded
  'cosmic.core.mappings',
}

-- set up lazy.nvim to install plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- set up cosmicnvim
for _, mod in ipairs(cosmic_modules) do
  local ok, err = pcall(require, mod)
  -- cosmic.config files may or may not be present
  if not ok and not mod:find('cosmic.config') then
    local trace = debug.traceback('', 2)
    error(
      ('Error loading %s...\n\n%s\n\nstack traceback:\n%s')
        :format(mod, tostring(err), trace)
    )
  end
end
