--[[
Copyright (c) 2023 by onepisYa pis1@qq.com, All Rights Reserved. 
Date: 2023-01-08 21:20:35
LastEditors: onepisYa pis1@qq.com
LastEditTime: 2023-01-14 00:44:36
FilePath: /nvim/lua/cosmic/config/editor.lua
路漫漫其修远兮，吾将上下而求索。
Description: 
--]] -- Override Cosmic editor options
local g = vim.g
local map = require('cosmic.utils').map
local opt = vim.opt
local cmd = vim.cmd
local augroup_name = 'CosmicNvim'
local group = vim.api.nvim_create_augroup(augroup_name, {
    clear = true
})

-- Default leader is <space>
g.mapleader = ' '

-- Default indent = 2
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
-- normal 命令超时时间
opt.timeoutlen = 1000

-- Add additional keymaps or disable existing ones
-- To view maps set, use `:Telescope keymaps`
-- or `:map`, `:map <leader>`

-- Example: Additional insert mapping:
map('i', 'jj', '<esc>')

-- Mapping options:
-- map('n', ...)
-- map('v', ...)
-- map('i', ...)
-- map('t', ...)

-- Example: Disable find files keymap
-- vim.keymap.del('n', '<leader>f')

-- See :h vim.keymap for more info

-- normal map
-- cancel searched highlight
map('n', '<leader><cr>', ':nohlsearch<cr>')
map('n', '<leader><leader>', '')

-- insert map
map('i', ',n', '<++>', {
    noremap = true
})

-- 搜索 <++> placeholder
map('i', ',f', '<Esc>/<++><CR>:nohlsearch<CR>a', {
    noremap = true
})

-- 向右清除4个内容
map({'i'}, ',c', '<Esc>c4l', {
    noremap = true
})

--  历史配置迁移
opt.exrc = true
opt.secure = true
opt.notimeout = true
opt.foldenalbe = true
opt.shortmess = opt.shortmess + {
    c = true
}
opt.formatoptions = opt.shortmess - {
    tc = true
}
opt.visualbell = true
opt.viewoptions = {"cursor", "folds", "slash", "unix"}
opt.completeopt = {'longest', 'noinsert', 'menuone', 'noselect', 'preview', 'menu'}
opt.inccommand = "split"
opt.virtualedit = "block"
opt.fileencodings = "utf-8"
opt.fileencoding = "utf-8"
opt.encoding = "utf-8"
opt.syntax = "enable"
-- " 处理 插入模式 和 normal 模式 的切换 延迟问题
opt.ttimeoutlen = 0
opt.list = true
-- " 上下 永远有 5行 能让你看到
opt.scrolloff = 5
opt.listchars = {
    tab = '❘-',
    trail = '·',
    lead = '',
    extends = '»',
    precedes = '«',
    nbsp = '×'
    --   lead = '·',
}

cmd([[ filetype on ]])
cmd([[ filetype plugin on ]])
cmd([[ filetype plugin indent on ]])
-- cmd([[ inoremap ,n <++>]]) -- it's work
cmd([[autocmd Filetype markdown inoremap ,f <Esc>/<++><CR>:nohlsearch<CR>c4l]]) 
-- map('n', 'rr', ':luafile $MYVIMRC<cr>') -- 没有作用
-- 不知道为什么这个 autocmd 也不起作用。可能是我的这个 Markdown 的类型 检测出来不是  md
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = {"*.md"},
--     callback = function(event)
--         map('i', ',n', '<++>', {
--             noremap = true
--         })
--     end,
--     group = group
-- })

--  历史配置 待迁移
-- 编辑器行为
-- silent !mkdir -p $HOME/.config/nvim/tmp/backup
-- silent !mkdir -p $HOME/.config/nvim/tmp/undo
-- silent !mkdir -p $HOME/.config/nvim/tmp/sessions
-- set backupdir=$HOME/.config/nvim/tmp/backup,.
-- set directory=$HOME/.config/nvim/tmp/backup,.

-- set colorcolumn=100
-- set updatetime=100
-- au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
-- " set cp! 兼容 vi 模式
-- " 解决提示信息乱码
-- language messages zh_CN.utf-8
-- " === vi 新的版本的特性
-- " === 保证 新来版本的插件 功能都能比较流畅的运行
-- " ===
-- set nocompatible
-- " 语法高亮
-- syntax on
-- filetype on
-- filetype indent on
-- filetype plugin on
-- filetype plugin indent on
-- " 系统剪贴板
-- set clipboard=unnamed
-- " 行号
-- set number
-- " 相对行号
-- set relativenumber
-- " 游标底线
-- set cursorline
-- " 让我的字不会超过 我的行
-- set wrap

-- " 显示指令执行信息
-- set showcmd
-- " 指令补全
-- set wildmenu
-- " 高亮搜索
-- set hlsearch
-- " 输入的时候就高亮
-- set incsearch
-- " 忽略大小写 搜索
-- set ignorecase
-- " 智能大小写 在你大小写混合搜索的时候  起作用
-- set smartcase
-- " 鼠标 可以使用鼠标
-- set mouse=a
-- " 处理 插入模式 和 normal 模式 的切换 延迟问题
-- set ttimeoutlen=0
-- " 不要设置 set timeoutlen=1 会导致  <LEADER> 失效
-- " 扩大缩进
-- set expandtab
-- " 缩进距离设置
-- set tabstop=4
-- set shiftwidth=4
-- set softtabstop=4
-- " 显示行尾空格
-- " 按照我设置的字符来显示
-- set list
-- set listchars=tab:▸\ ,trail:▫
-- " 上下 永远有 5行 能让你看到
-- set scrolloff=5

-- "自动行分割
-- set tw=0
-- set backspace=indent,eol,start
-- set foldmethod=indent
-- set foldlevel=99
-- " set indentexpr=
-- " 底部状态栏
-- set laststatus=2
-- " vim执行命令在当前目录下执行
-- set autochdir

