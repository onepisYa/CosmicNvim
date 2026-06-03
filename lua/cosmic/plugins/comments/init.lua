local function get_comment_location(ctx)
  local comment_utils = require('Comment.utils')
  local function get_line_start_location(line)
    return { line, math.max(vim.fn.match(vim.fn.getline(line + 1), '\\S'), 0) }
  end

  if ctx.ctype == comment_utils.ctype.blockwise then
    return { ctx.range.srow - 1, ctx.range.scol }
  end

  if ctx.cmotion == comment_utils.cmotion.v or ctx.cmotion == comment_utils.cmotion.V then
    return get_line_start_location(vim.fn.getpos("'<")[2] - 1)
  end

  return get_line_start_location(vim.api.nvim_win_get_cursor(0)[1] - 1)
end

local function get_commentstring(ctx)
  local comment_utils = require('Comment.utils')
  local ok, parser = pcall(vim.treesitter.get_parser, 0)

  if ok then
    parser:parse(true)
  end

  return require('ts_context_commentstring').calculate_commentstring({
    key = ctx.ctype == comment_utils.ctype.linewise and '__default' or '__multiline',
    location = get_comment_location(ctx),
  })
end

return {
  'numToStr/Comment.nvim',
  dependencies = {
    -- The pinned version of nvim-ts-context-commentstring only exposes
    -- `init()` (which registers the treesitter module), not `setup()`.
    -- Triggering `init` via `init = ...` keeps the dependency compatible
    -- with both the legacy and the modern API.
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      init = function()
        if type(require('ts_context_commentstring').init) == 'function' then
          require('ts_context_commentstring').init()
        end
      end,
    },
  },
  opts = {
    pre_hook = get_commentstring,
  },
  lazy = false,
}
