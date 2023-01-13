-- Override Cosmic configuration options
-- You can require null-ls if needed
-- local null_ls = require('null-ls')
local config = {
    -- See :h nvim_open_win for possible border options
    border = 'rounded',
    -- LSP settings
    lsp = {
        -- True/false or table of filetypes {'.ts', '.js',}
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
                -- OR add/override server options
                opts = {
                    on_attach = function(client, bufnr)
                    end,
                    flags = {
                        debounce_text_changes = 150
                    }
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
    plugins = {
        -- See https://github.com/rmagatti/auto-session#%EF%B8%8F-configuration
        auto_session = {
            --  auto-session provide two command. 
            -- :SaveSession " saves or creates a session in the currently set `auto_session_root_dir`.
            -- :SaveSession ~/my/custom/path " saves or creates a session in the specified directory path.
            -- :RestoreSession " restores a previously saved session based on the `cwd`.
            -- :RestoreSession ~/my/custom/path " restores a previously saved session based on the provided path.
            -- :RestoreSessionFromFile ~/session/path " restores any currently saved session
            -- :DeleteSession " deletes a session in the currently set `auto_session_root_dir`.
            -- :DeleteSession ~/my/custom/path " deleetes a session based on the provided path.
            -- :Autosession search
            -- :Autosession delete
            -- Dashboard plugin provide four command
            -- DashboardNewFile  
            -- SessionSave,SessionLoad,SessionDelete
            auto_session_enabled = true,
            auto_restore_enabled = false,
            auto_save_enabled = false,
            auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/auto_session/"
        },
        -- https://github.com/folke/noice.nvim
        noice = {
            notify = {
                -- Noice can be used as `vim.notify` so you can route any notification like other messages
                -- Notification messages have their level and other properties set.
                -- event is always "notify" and kind can be any log level as a string
                -- The default routes will forward notifications to nvim-notify
                -- Benefit of using Noice for this is the routing and consistent history view
                enabled = true,
                view = "notify"
            },
            views = {
                notify = {
                    merge = true
                }
            },
            format = {},
            filters = {},
            routes = {},
            status = {}
        },
        -- https://github.com/numToStr/Comment.nvim#configuration-optional
        comment_nvim = {},
        -- See https://github.com/CosmicNvim/cosmic-ui#%EF%B8%8F-configuration
        cosmic_ui = {},
        -- See :h vim.diagnostic.config for all diagnostic configuration options
        diagnostic = {},
        -- See :h gitsigns-usage
        gitsigns = {},
        -- See https://git.sr.ht/~whynothugo/lsp_lines.nvim
        lsp_lines = {
            -- additional flag only for CosmicNvim
            -- true - loads plugin and is enabled at start
            -- false - loads plugin but is not enabled at start
            -- you may use <leader>ld to toggle
            enable_on_start = true
        },
        -- See https://github.com/ray-x/lsp_signature.nvim#full-configuration-with-default-values
        lsp_signature = {},
        -- See https://github.com/nvim-lualine/lualine.nvim#default-configuration
        lualine = {},
        -- See https://github.com/L3MON4D3/LuaSnip/blob/577045e9adf325e58f690f4d4b4a293f3dcec1b3/README.md#config
        luasnip = {},
        -- See :h telescope.setup
        telescope = {},
        -- See https://github.com/folke/todo-comments.nvim#%EF%B8%8F-configuration
        todo_comments = {},
        -- See :h nvim-treesitter-quickstart
        treesitter = {},
        -- See :h cmp-usage
        nvim_cmp = {},
        -- See :h nvim-tree.setup
        -- https://github.com/nvim-tree/nvim-tree.lua
        nvim_tree = {},
        -- 主题配置
        -- https://github.com/folke/tokyonight.nvim
        tokyonight = {
            transparent = true
        }
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
