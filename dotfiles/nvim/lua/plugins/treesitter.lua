return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
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
                "dart"
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
