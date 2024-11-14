return {
  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")

    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<CR>"] = cmp.mapping({
        i = function(fallback)
          fallback()
        end,
      }),
      ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      ["<S-Tab>"] = cmp.mapping.select_next_item(),
    })
  end,
}
