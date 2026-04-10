return {
  "nvim-neo-tree/neo-tree.nvim",
  config = function()
    require("neo-tree").setup({
      window = {
        width = 40,
        max_width = 70,
      },
    })
  end,
}
