return {
  "folke/tokyonight.nvim",
  opts = function()
    return {
      style = vim.o.background == "light" and "day" or "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    }
  end,
  init = function()
    -- Re-setup and reload colorscheme when background option changes at runtime.
    -- The theme-switch script triggers this via: nvim --server <sock> --remote-send ":set background=light<CR>"
    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = function()
        local style = vim.o.background == "light" and "day" or "night"
        require("tokyonight").setup({
          style = style,
          transparent = true,
          styles = { sidebars = "transparent", floats = "transparent" },
        })
        vim.cmd("colorscheme tokyonight")
      end,
    })
  end,
}
