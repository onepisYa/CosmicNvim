local defaults = {
  ensure_installed = {
    'astro',
    'bash',
    'css',
    'go',
    'graphql',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'php',
    'python',
    'regex',
    'scss',
    'styled',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
}

local group = vim.api.nvim_create_augroup('CosmicNvimTreesitter', { clear = true })

-- Predicate registration (`force = true`) and broken-query overrides
-- are installed in `cosmic.core.ts_compat` BEFORE `lazy.setup` runs,
-- so they are in effect when nvim-treesitter's `query_predicates.lua`
-- fires `add_predicate` at module load.

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter')

    treesitter.setup({})

    -- `nvim-treesitter` no longer exports `install` directly; parser
    -- installation is driven through the `:TSInstall` command (see
    -- `nvim-treesitter.install`). The `build = ':TSUpdate'` above keeps
    -- the installed parser set fresh on plugin update.

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      callback = function(args)
        local ok = pcall(vim.treesitter.start, args.buf)

        if ok and defaults.indent.enable then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
      desc = 'Enable Tree-sitter features for supported buffers',
    })
  end,
}
