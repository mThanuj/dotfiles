return {
    {
        "vague-theme/vague.nvim",
        lazy = false, 
        priority = 1000, 
        config = function()
            require("vague").setup({
                transparent = true
            })
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })
        end,
    },
}

