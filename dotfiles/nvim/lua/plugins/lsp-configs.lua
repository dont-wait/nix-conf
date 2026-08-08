return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
			ensure_installed = {
				"zls",
				"ts_ls",
				"gopls",
				"lua_ls",
				"jsonls",
				"html",
				"cssls",
				"yamlls",
				"bashls",
				"pylsp",
				"lemminx",
				"rust_analyzer",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)

			capabilities.textDocument.completion.completionItem.resolveSupport = {
				properties = { "documentation", "detail", "additionalTextEdits" },
			}

			vim.lsp.config.lua_ls = {
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

			local ts_inlay_hints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			}

			vim.lsp.config.ts_ls = {
				capabilities = capabilities,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				settings = {
					typescript = { inlayHints = ts_inlay_hints },
					javascript = { inlayHints = ts_inlay_hints },
				},
			}
			vim.lsp.config.html = { capabilities = capabilities }
			vim.lsp.config.cssls = { capabilities = capabilities }
			vim.lsp.config.eslint = { capabilities = capabilities }
			vim.lsp.config.zls = { capabilities = capabilities }
			vim.lsp.config.yamlls = { capabilities = capabilities }
			vim.lsp.config.tailwindcss = { capabilities = capabilities }
			vim.lsp.config.gopls = {
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = { unusedparams = true },
						staticcheck = true,
						gofumpt = true,
						completeUnimported = true,
						usePlaceholders = true,
						hints = {
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			}

			vim.lsp.config.nil_ls = { capabilities = capabilities }
			vim.lsp.config.buf_ls = { capabilities = capabilities }
			vim.lsp.config.docker_compose_language_service = { capabilities = capabilities }
			vim.lsp.config.cobol_ls = { capabilities = capabilities }
			vim.lsp.config.svelte = { capabilities = capabilities }
			vim.lsp.config.pylsp = {
				capabilities = capabilities,
				settings = {
					pylsp = {
						plugins = {
							black = { enabled = true },
							isort = { enabled = true },
						},
					},
				},
			}
			vim.lsp.config.bashls = { capabilities = capabilities }
			vim.lsp.config.sourcekit = {
				capabilities = capabilities,
				filetypes = { "swift" },
			}
			-- vim.lsp.config.dartls = {
			--     capabilities = capabilities,
			--     cmd = { "dart", "language-server", "--protocol=lsp" },
			--     filetypes = { "dart" },
			--     root_markers = { "pubspec.yaml" },
			-- }
			vim.lsp.config.lemminx = {
				capabilities = capabilities,
				filetypes = { "xml" },
			}
			vim.lsp.config["rust_analyzer"] = {
				capabilities = capabilities,
				cmd = { "rust-analyzer" },
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
							allTargets = true,
							buildScripts = { enable = true },
						},
						check = {
							command = "clippy",
						},
						procMacro = {
							enable = true,
						},
						completion = {
							autoimport = { enable = true },
						},
						imports = {
							granularity = { group = "module" },
							prefix = "crate",
						},
					},
				},
			}

			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"html",
				"cssls",
				"eslint",
				"zls",
				"yamlls",
				"tailwindcss",
				"gopls",
				"nil_ls",
				"buf_ls",
				"docker_compose_language_service",
				-- "cobol_ls",
				"svelte",
				"pylsp",
				"bashls",
				"sourcekit",
				-- "dartls",
				"lemminx",
				"rust_analyzer",
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { noremap = true, silent = true })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true })
			vim.keymap.set("n", "gr", vim.lsp.buf.references, { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, silent = true })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })

			vim.lsp.inlay_hint.enable(true)

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
					swift = { "class", "method", "struct", "enum", "protocol", "function" },
				}
				local opts = {}
				local symbols = symbols_map[filetype]

				if symbols then
					opts.symbols = symbols
				end

				require("fzf-lua").lsp_document_symbols(opts)
			end, {})
		end,
	},
}
