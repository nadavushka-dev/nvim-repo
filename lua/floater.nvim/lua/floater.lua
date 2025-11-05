local M = {}

M.setup = function()
  -- nothing
end

local state = {
  floatingTerm = {
    buf = -1,
    win = -1
  },
  floatingSketch = {
    buf = -1,
    win = -1
  }
}

local open_floating_window = function(opts)
  -- Define the size of the floating window
  opts = opts or {}
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- Calculate the starting position
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- Create a new unlisted buffer
  end

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded", -- Add a border style (rounded, single, double, etc.)
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

M.sketch = function()
  if not vim.api.nvim_win_is_valid(state.floatingSketch.win) then
    state.floatingSketch = open_floating_window { buf = state.floatingSketch.buf }
  else
    vim.api.nvim_win_hide(state.floatingSketch.win)
  end
end

M.terminal = function()
  if not vim.api.nvim_win_is_valid(state.floatingTerm.win) then
    state.floatingTerm = open_floating_window { buf = state.floatingTerm.buf }
    if vim.bo[state.floatingTerm.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      vim.cmd("startinsert")
    end
  else
    vim.api.nvim_win_hide(state.floatingTerm.win)
  end
end

vim.api.nvim_create_user_command("FloaterTerminal", M.terminal, {})
vim.api.nvim_create_user_command("FloaterSketch", M.sketch, {})

return M
