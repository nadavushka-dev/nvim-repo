return {
  {
    dir = "~/dotfiles/config/nvim/lua/floater.nvim/",
    config = function()
      local floater = require("floater")
      vim.keymap.set({ 'n', 't' }, "<leader>tt", floater.terminal)
      vim.keymap.set('n', "<leader>sk", floater.sketch)
    end
  },
}
