local user_config = require('cosmic.core.user')
local icons = require('cosmic.utils.icons')
local u = require('cosmic.utils')

-- set up args
local args = {
  respect_buf_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = icons.hint,
      info = icons.info,
      warning = icons.warn,
      error = icons.error,
    },
  },
  ignore_ft_on_setup = {
    'startify',
    'dashboard',
    'alpha',
  },
  update_focused_file = {
    enable = true,
  },
  view = {
    width = 35,
    number = true,
    relativenumber = true,
  },
  git = {
    ignore = true,
  },
  renderer = {
    highlight_git = true,
    special_files = {},
    icons = {
      glyphs = {
        default = '',
        symlink = icons.symlink,
        git = icons.git,
        folder = icons.folder,
      },
    },
  },
}

return {
  'kyazdani42/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup(u.merge(args, user_config.plugins.nvim_tree or {}))
  end,
  init = function()
    require('cosmic.plugins.nvim-tree.mappings')
  end,
  cmd = {
    'NvimTreeClipboard',
    'NvimTreeFindFile',
    'NvimTreeOpen',
    'NvimTreeRefresh',
    'NvimTreeToggle',
  },
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'nvim-tree'),
}
