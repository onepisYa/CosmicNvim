local user_config = require('cosmic.core.user')
local utils = require('cosmic.utils')

local defaults = {
  border_style = 'rounded',
}

return {
  'CosmicNvim/cosmic-ui',
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
  init = function()
    user_config.lsp.add_on_attach_mapping(function(client, bufnr)
      local buf_map = utils.create_buf_map(bufnr)

      buf_map('n', 'gn', '<cmd>lua require("cosmic-ui").rename()<cr>')
      buf_map('n', '<leader>ga', '<cmd>lua require("cosmic-ui").code_actions()<cr>')
      buf_map('v', '<leader>ga', '<cmd>lua require("cosmic-ui").range_code_actions()<cr>')
    end)
  end,
  config = function()
    require('cosmic-ui').setup(utils.merge(defaults, user_config.plugins.cosmic_ui or {}))
  end,
  event = 'VeryLazy',
  enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'cosmic-ui'),
}
