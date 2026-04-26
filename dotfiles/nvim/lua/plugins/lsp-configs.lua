return {
    {
        "williamboman/mason.nvim",
        -- version = "v1.11.0",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "Hoffs/omnisharp-extended-lsp.nvim",
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
            -- manually install packages that do not exist in this list please
            ensure_installed = { "zls", "ts_ls", "gopls" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
            -- lua
            vim.lsp.config["lua_ls"] = {
                cmd = { "lua-language-server" },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = { enable = false },
                    },
                },
            }
            vim.lsp.enable("lua_ls")

            vim.lsp.config["ts_ls"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["eslint"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["zls"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["thymeleaf"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["yamlls"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["tailwindcss"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["gopls"] = {
                capabilities = capabilities,
                -- Thêm phần settings bên dưới để gopls thông minh hơn
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                        completeUnimported = true, -- Tự động gợi ý cả các package chưa import
                        usePlaceholders = true, -- Tự động điền tham số khi chọn hàm
                        hints = {
                            -- assignVariableTypes = true,
                            -- compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
            }

            -- vim.lsp.config["omnisharp"] = {
            --     capabilities = capabilities,
            --     offset_encoding = "utf-8",
            --     handlers = {
            --         ["textDocument/definition"] = require("omnisharp_extended").definition_handler,
            --         ["textDocument/references"] = require("omnisharp_extended").references_handler,
            --         ["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
            --     },
            --     on_attach = function(client, bufnr)
            --         if client.server_capabilities.inlayHintProvider then
            --             vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            --         end
            --     end,
            --     settings = {
            --         omnisharp = {
            --             enableRoslynAnalyzers = true,
            --             enableInlayHints = false,
            --             enableEditorConfigSupport = true,
            --             organizeImportsOnFormat = true,
            --             enableDecompilationSupport = true,
            --             enableImportCompletion = true,
            --             -- Group các tùy chọn vào ĐÚNG phân cấp omnisharp
            --             inlayHintsOptions = {
            --                 enableForParameters = true,
            --                 forLiteralParameters = true,
            --                 forIndexerParameters = true,
            --                 forObjectCreationParameters = true,
            --                 forOtherParameters = true,
            --                 enableForTypes = true,
            --                 forImplicitVariableTypes = true,
            --                 forLambdaParameterTypes = true,
            --                 forImplicitObjectCreation = true,
            --             },
            --             RoslynExtensionsOptions = {
            --                 enableDecompilationSupport = true,
            --                 enableImportCompletion = true,
            --                 enableAnalyzersSupport = true,
            --             },
            --         },
            --     },
            -- }
            -- nix
            vim.lsp.config["nil_ls"] = {
                capabilities = capabilities,
            }

            -- protocol buffer
            vim.lsp.config["buf_ls"] = {
                capabilities = capabilities,
            }

            -- docker compose
            vim.lsp.config["docker_compose_language_service"] = {
                capabilities = capabilities,
            }

            -- cobol
            vim.lsp.config["cobol_ls"] = {
                capabilities = capabilities,
            }

            -- svelte
            vim.lsp.config["svelte"] = {
                capabilities = capabilities,
            }
            -- python
            vim.lsp.config["pylsp"] = {
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            black = { enabled = true },
                            isort = { enabled = true },
                            jedi = {
                                environment = "./.venv",
                            },
                        },
                    },
                },
            }

            -- bash
            vim.lsp.config["bashls"] = {
                capabilities = capabilities,
            }

            -- protocol buffer
            vim.lsp.config["buf_language_server"] = {
                capabilities = capabilities,
            }

            vim.lsp.config["asm_lsp"] = {
                capabilities = capabilities,
            }

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "proto",
                callback = function()
                    vim.lsp.enable("buf_language_server")
                end,
            })
            vim.lsp.enable({
                "ts_ls",
                "eslint",
                "zls",
                "yamlls",
                "tailwindcss",
                "gopls",
                "nil_ls",
                "buf_ls",
                "docker_compose_language_service",
                "cobol_ls",
                "svelte",
                "pylsp",
                "bashls",
                "asm_lsp",
            })
            -- lsp kepmap setting
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
            vim.lsp.inlay_hint.enable(true) -- list all methods in a file
            -- working with go confirmed, don't know about other, keep changing as necessary
            vim.keymap.set("n", "<leader>fm", function()
                local filetype = vim.bo.filetype
                local symbols_map = {
                    python = "function",
                    javascript = "function",
                    typescript = "function",
                    java = "class",
                    lua = "function",
                    go = { "method", "struct", "interface" },
                    cs = { "class", "method", "interface", "property", "struct" },
                }
                local symbols = symbols_map[filetype] or "function"
                require("fzf-lua").lsp_document_symbols({ symbols = symbols })
            end, {})
        end,
    },
}
