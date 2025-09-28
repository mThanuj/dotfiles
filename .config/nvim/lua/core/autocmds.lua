-- Lint on save
vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
        require("lint").try_lint()
    end,
})

-- Restart LSP command
vim.api.nvim_create_user_command("LspRestart", function()
    local clients = vim.lsp.get_clients()
    if #clients > 0 then
        vim.lsp.stop_client(clients, true)
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
                vim.api.nvim_buf_call(bufnr, function() vim.cmd.edit() end)
            end
        end
        vim.notify("Restarted all LSP clients", vim.log.levels.INFO)
    else
        vim.notify("No active LSP clients", vim.log.levels.WARN)
    end
end, {})
