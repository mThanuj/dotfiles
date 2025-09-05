return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find File" })
        vim.keymap.set('n', '<C-f>', builtin.git_files, { desc = "Find Git Files" })
        vim.keymap.set('n', '<leader>fw', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Find Word under cursor" })
        vim.keymap.set('n', '<leader>fW', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Find WORD under cursor" })
        vim.keymap.set('n', '<leader>fs', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Find Grep" })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Find Help" })
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "Find Keymaps" })
    end
}

