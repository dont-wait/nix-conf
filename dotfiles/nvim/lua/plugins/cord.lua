return {
    "vyfor/cord.nvim",
    build = ":Cord update",
    opts = {
        display = {
            theme = "catppuccin",
            flavor = "accent",
            swap_icons = true,
        },
        idle = {
            details = "zzz",
        },
        text = {
            default = nil,
            workspace = function(opts)
                return "@ " .. opts.workspace
            end,
            viewing = function(opts)
                return "Viewing " .. opts.filename
            end,
            editing = function(opts)
                return "Editing " .. opts.filename
            end,
            file_browser = function(opts)
                return "Browsing " .. opts.name
            end,
            plugin_manager = nil,
            lsp = function(opts)
                return "Configuring lsp " .. opts.name
            end,
            docs = function(opts)
                return "Reading " .. opts.name
            end,
            vcs = function(opts)
                return "Commiting @ " .. opts.name
            end,
            notes = function(opts)
                return "Taking notes @ " .. opts.name
            end,
            debug = function(opts)
                return "Debugging @ " .. opts.name
            end,
            test = function(opts)
                return "Testing @ " .. opts.name
            end,
            diagnostics = function(opts)
                return "Fixing bugs @ " .. opts.name
            end,
            games = function(opts)
                return "Playing " .. opts.name
            end,
            terminal = function(opts)
                return "Executing cmds"
            end,
            dashboard = "Is this thing on? Nothing",
        },
        buttons = {
            {
                label = function(opts)
                    return opts.repo_url and "repo" or "website"
                end,
                url = function(opts)
                    return opts.repo_url or "https://github.com/dontwait"
                end,
            },
        },
        editor = {
            client = "neovim",
            tooltip = "YumikoBaka",
            -- icon = "https://product.hstatic.net/200000903781/product/vn-11134207-7r98o-luu4at0x9r1ha4_a276c059812246d195e36af6bd5e9599_master.jpeg",
        },
    },
}
