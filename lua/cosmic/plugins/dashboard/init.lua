--[[
Copyright (c) 2023 by onepisYa pis1@qq.com, All Rights Reserved.
Date: 2023-01-08 21:20:20
LastEditors: onepisYa pis1@qq.com
LastEditTime: 2023-01-09 09:05:35
FilePath: /cosmic/plugins/dashboard/init.lua
路漫漫其修远兮，吾将上下而求索。
Description:
--]] local user_config = require('cosmic.core.user')
local icons = require('cosmic.utils.icons')
local g = vim.g
local home = os.getenv('HOME')

print(vim.fn.stdpath('data') .. '/sessions')

-- 文档
-- https://github.com/glepnir/dashboard-nvim
return {
    'glepnir/dashboard-nvim',
    config = function()
        -- g.dashboard_default_executive = 'telescope'
        local db = require('dashboard')
        db.session_directory = vim.fn.stdpath('data') .. '/sessions/dashboard'
        db.session_auto_save_on_exit = true
        db.session_verbose = true
        -- db.custom_header = {
        -- '', '', '',
        -- ' ██████╗ ███╗   ██╗ █████ ╗   █████╗ ██╗███████╗ ██╗   ██║   █████╗   ',
        -- '██╔═══██╗████╗  ██║██╔═══██╗ ██╔══██╗██║██╔════╝  ██╗ ██║   ██╔═══██╗ ',
        -- '██║   ██║██╔██╗ ██║████████║ ███████║██║███████╗   ████╝   ██████████╗',
        -- '██║   ██║██║╚██╗██║██║═════╝ ██║════╝██║╚════██║    ██║    ██╔════ ██║',
        -- '╚██████╔╝██║ ╚████║╚██████╗  ██║     ██║███████║    ██║    ██║     ██║',
        -- ' ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝  ╚═╝     ╚═╝╚══════╝    ╚═╝    ╚═╝     ╚═╝',
        -- '', '', '',
        -- '',
        -- '',
        -- '',
        -- '',
        -- '',
        -- ' ██████╗ ██████╗ ███████╗███╗   ███╗██╗ ██████╗███╗   ██╗██╗   ██╗██╗███╗   ███╗',
        -- '██╔════╝██╔═══██╗██╔════╝████╗ ████║██║██╔════╝████╗  ██║██║   ██║██║████╗ ████║',
        -- '██║     ██║   ██║███████╗██╔████╔██║██║██║     ██╔██╗ ██║██║   ██║██║██╔████╔██║',
        -- '██║     ██║   ██║╚════██║██║╚██╔╝██║██║██║     ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║',
        -- '╚██████╗╚██████╔╝███████║██║ ╚═╝ ██║██║╚██████╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║',
        -- ' ╚═════╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝ ╚═════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝',
        -- }
        db.custom_center = {{
            icon = '  ',
            desc = 'Load DashboardSession                   ',
            shortcut = 'SPC _ _',
            action = 'SessionLoad'
        }, {
            icon = '  ',
            desc = 'Grep String                             ',
            action = 'Telescope grep_string',
            shortcut = 'SPC f s'
        }, {
            icon = '  ',
            desc = 'Find  File                              ',
            action = 'lua require("cosmic.plugins.telescope.mappings").project_files()',
            shortcut = 'SPC f f'
        }, -- {
        --     icon = '  ',
        --     desc = 'File Browser                            ',
        --     action = 'NvimTreeToggle',
        --     shortcut = '<C - n>'
        -- },
        {
            icon = '  ',
            desc = 'Find  word                              ',
            action = 'Telescope live_grep',
            shortcut = 'SPC f w'
        }, {
            icon = '  ',
            desc = 'auto_session Load Session               ',
            action = ':silent RestoreSession',
            shortcut = 'SPC s l'
        }}
        db.custom_footer = {"💫 If i rest. I rust."}
        db.preview_command = 'cat | lolcat -F 0.3'
        -- 有了这个文件就不用再配置 custom_header了
        db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
        db.preview_file_height = 11
        db.preview_file_width = 70
    end,
    event = 'VimEnter',
    enabled = not vim.tbl_contains(user_config.disable_builtin_plugins, 'dashboard')
}
