local user_config = require('cosmic.core.user')

-- Servers that the user keeps configured but that are not valid
-- `nvim-lspconfig` entries and therefore must not be passed to
-- `mason-lspconfig.ensure_installed` (which only accepts lspconfig names).
-- Examples: `null_ls` (null-ls source framework), `tsserver` (a
-- non-lspconfig alias for the TypeScript language server).
local non_lspconfig_servers = {
  null_ls = true,
  tsserver = true,
}

---@return string[]
local function get_enabled_servers()
  local servers = vim.tbl_keys(user_config.lsp.resolved_servers)
  table.sort(servers)

  local result = {}
  for _, server_name in ipairs(servers) do
    if not non_lspconfig_servers[server_name] then
      result[#result + 1] = server_name
    end
  end
  return result
end

-- set up lsp servers
return {
  'williamboman/mason-lspconfig.nvim',
  lazy = false,
  config = function()
    local enabled_servers = get_enabled_servers()

    for server_name, server_config in pairs(user_config.lsp.resolved_servers) do
      vim.lsp.config(server_name, vim.deepcopy(server_config))
    end

    require('mason-lspconfig').setup({
      ensure_installed = enabled_servers,
      automatic_enable = false,
    })

    -- Enable servers after registering user config so Mason shims do not
    -- override non-table fields such as `before_init` or `cmd`.
    for server_name in pairs(user_config.lsp.resolved_servers) do
      vim.lsp.enable(server_name)
    end
  end,
  dependencies = {
    { 'neovim/nvim-lspconfig', lazy = true },
    { 'williamboman/mason.nvim', lazy = true, opts = {} },
  },
}
