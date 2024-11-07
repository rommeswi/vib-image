# Installs neogit
return {
  -- other plugins
  {
    'TimUntersberger/neogit',
    dependencies = 'nvim-lua/plenary.nvim',  -- ensure that plenary.nvim is installed as well
    config = function()
      require('neogit').setup {}
      vim.keymap.set({'n', 'v'}, '<leader>gs', '<cmd>Neogit<CR>', { desc = 'Open Neogit', noremap = true, silent = true })
    end
  },
}
