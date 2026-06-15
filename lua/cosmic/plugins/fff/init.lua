-- fff.nvim — Fast File Finder (Rust core + Lua UI + frecency + bg watcher)
-- Source: https://github.com/dmtrKovalenko/fff.nvim
-- Installed: 2026-06-15 via Hermes 升级 fast-search 联动
-- Keymaps: <leader>ff (find files) / <leader>fg (live grep) / <leader>fz (fuzzy grep)
-- 装好前提: fff-mcp 0.9.4 已在系统 PATH (/opt/homebrew/bin/fff-mcp)

return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    -- 下载 prebuilt 或 fallback cargo build（cosmic 0.13+ 兼容）
    require('fff.download').download_or_build_binary()
  end,
  lazy = false,
  keys = {
    { '<leader>ff', function() require('fff').find_files() end, desc = 'FFFind files' },
    { '<leader>fg', function() require('fff').live_grep() end, desc = 'LiFFFe grep' },
    { '<leader>fz',
      function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end,
      desc = 'Live fffuzy grep',
    },
  },
  opts = {
    debug = {
      enabled = false,
      show_scores = false,
    },
    enable_home_dir_scanning = false,  -- 已用 fff-mcp 索引 ~/.hermes，nvim 端只扫 cwd
  },
  config = function(_, opts)
    require('fff').setup(opts)
  end,
}
