-- Override Cosmic configuration options
-- You can require null-ls if needed
-- local null_ls = require('null-ls')
local config = {
    -- See :h nvim_open_win for possible border options
    border = 'rounded',
    -- LSP settings
    lsp = {
        -- True/false or table of filetypes {'.ts', '.js',}
        -- format_on_save = {'.ts', '.js'},
        format_on_save = true,
        -- Time in MS before format timeout
        format_timeout = 3000,
        -- Set to false to disable rename notification
        rename_notification = true,
        -- Enable non-default servers, use default lsp config
        -- Check here for configs that will be used by default: https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers

        -- lsp servers that should be installed
        ensure_installed = {'rust_analyzer'},

        -- lsp servers that should be enabled
        servers = {
            -- Enable rust_analyzer
            rust_analyzer = true,

            -- Enable tsserver w/custom settings
            tsserver = {
                -- Disable formatting (defaults to true)
                format = false,
                on_attach = function(client, bufnr)
                end,
                flags = {
                    debounce_text_changes = 150
                }
            },
            -- See Cosmic defaults lsp/providers/null_ls.lua and https://github.com/jose-elias-alvarez/null-ls.nvim/
            -- If adding additional sources, be sure to also copy the defaults that you would like to preserve from lsp/providers/null_ls.lua
            null_ls = {
                -- Disable default list of sources provided by CosmicNvim
                default_cosmic_sources = false,
                -- disable formatting
                format = false,
                -- Add additional sources here
                get_sources = function()
                    local null_ls = require('null-ls')
                    return {null_ls.builtins.diagnostics.shellcheck, null_ls.builtins.diagnostics.actionlint.with({
                        condition = function()
                            local cwd = vim.fn.expand('%:p:.')
                            return cwd:find('.github/workflows')
                        end
                    })}
                end
            }
        },
        -- See Cosmic defaults lua/plugins/nvim-lsp-ts-utils/setup.lua
        ts_utils = {}
    },

    -- adjust default plugin settings
    -- Plugin management (lazy.nvim) -- must be a list of lazy.nvim specs.
    plugins = {
      -- Override built-in auto-session with custom options
      {
        'rmagatti/auto-session',
        opts = {
          auto_session_enabled = true,
          auto_restore_enabled = false,
          auto_save_enabled = false,
          auto_session_root_dir = vim.fn.stdpath('data') .. '/sessions/auto_session/',
        },
      },
      -- Override built-in noice with custom notify + views
      {
        'folke/noice.nvim',
        opts = {
          notify = {
            enabled = true,
            view = 'notify',
          },
          views = {
            notify = {
              merge = true,
            },
          },
        },
      },
      -- Override built-in tokyonight with transparent background
      {
        'folke/tokyonight.nvim',
        opts = {
          transparent = true,
        },
      },
      -- Extra plugins (formerly under `add_plugins`)
      'ggandor/lightspeed.nvim',
      {
        'romgrk/barbar.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
      },
    },

    -- Disable plugins default enabled by CosmicNvim
    disable_builtin_plugins = {
        --[[
    'auto-session',
    'colorizer',
    'comment-nvim',
    'dashboard',
    'fugitive',
    'gitsigns',
    'lualine',
    'noice',
    'nvim-cmp',
    'nvim-tree',
    'telescope',
    'terminal',
    'theme',
    'todo-comments',
    'treesitter',
    ]]
    },

    -- Add additional plugins (lazy.nvim)
    add_plugins = {'ggandor/lightspeed.nvim', {
        'romgrk/barbar.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons'}
    }}
}

return config
