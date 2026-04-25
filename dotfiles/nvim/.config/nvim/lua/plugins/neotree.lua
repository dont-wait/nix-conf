return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    config = function(_, opts)
        require("neo-tree").setup(opts)

        vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "NONE" })
    end,
    keys = {
        { "<leader>ve", "<cmd>Neotree toggle left<cr>", desc = "Toggle Neotree" },
        { "<leader>vr", "<cmd>Neotree reveal<cr>",      desc = "Reveal file in Neotree" },
    },
    opts = {
        close_if_last_window = true,
        filesystem = {
            follow_current_file = {
                enabled = true, -- tự highlight file đang mở
                leave_dirs_open = true,
            },
            hijack_netrw_behavior = "open_current",
            use_libuv_file_watcher = true, -- tự refresh khi file thay đổi
        },
        window = {
            width = 30,
            position = "left",
        },
    },
}
