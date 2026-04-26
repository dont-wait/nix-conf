-- lua/plugins/roslyn.lua
return {
    "seblyng/roslyn.nvim",
    ft = { "cs" },
    opts = {
        filewatching = "roslyn",
        broad_search = true,
        lock_target = false,
        silent = false,
        config = {
            cmd = { "roslyn-ls" },
            capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
                textDocument = {
                    inlayHint = { dynamicRegistration = true },
                },
            }),
            on_attach = function(client, bufnr)
                local lspkind = require("lspkind")

                vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
                    if not (result and result.contents) then
                        return
                    end

                    -- Dọn dẹp markdown như đã làm ở bước trước
                    local function clean(t)
                        return t:gsub("\\([%.%(%)%_%*])", "%1")
                    end

                    config = config or {}
                    config.border = "rounded"

                    return vim.lsp.handlers.hover(_, result, ctx, config)
                end
            end,
        },
        settings = {
            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
                dotnet_enable_tests_code_lens = true,
            },
            ["csharp|completion"] = {
                dotnet_show_completion_items_from_unimported_namespaces = true,
                dotnet_show_name_completion_suggestions = true,
                dotnet_provide_regex_completions = true,
            },
            ["csharp|background_analysis"] = {
                dotnet_analyzer_diagnostics_scope = "fullSolution",
                dotnet_compiler_diagnostics_scope = "fullSolution",
            },
            ["csharp|formatting"] = {
                dotnet_organize_imports_on_format = true,
            },
            ["csharp|symbol_search"] = {
                dotnet_search_reference_assemblies = true,
            },
        },
    },
}
