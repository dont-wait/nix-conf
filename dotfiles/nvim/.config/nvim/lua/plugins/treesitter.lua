return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.config").setup({
            ensure_installed = {
                "c",
                "lua",
                "vim",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "go",
                "gomod",
                "gowork",
                "gosum",
                "java",
                "json",
                "zig",
                "c_sharp",
            },
            highlight = { enable = true },
        })

        -- Enable highlight tự động cho tất cả filetype
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
