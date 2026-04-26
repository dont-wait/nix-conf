return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            current_line_blame = false, -- bật blame inline
            current_line_blame_opts = {
                delay = 100,   -- ms trước khi hiện
            },
        })
    end,
    vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>"),
       vim.keymap.set("n", "<leader>gp", ":Gitsigns toggle_current_line_blame<CR>")
}
