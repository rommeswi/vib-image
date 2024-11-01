return {
    -- Add TexLab LSP
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            local lspconfig = require("lspconfig")
            -- Add texlab to lspconfig setup
            lspconfig.texlab.setup({
                settings = {
                    texlab = {
                        build = {
                            executable = "latexmk",
                            args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                            onSave = true,
                        },
                        forwardSearch = {
                            executable = "zathura",
                            args = { "--synctex-forward", "%l:1:%f", "%p" },
                        },
                    },
                },
            })
        end,
    },
}
