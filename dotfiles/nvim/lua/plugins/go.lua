return {
    "ray-x/go.nvim",
    dependencies = {
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("go").setup({
            lsp_cfg = false,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "go", "gomod" },
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
}
