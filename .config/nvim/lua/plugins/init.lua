local lazy = require("lazy")

lazy.setup({
    spec = {
        { import = "plugins" },
    },
    change_detection = {
        notify = false,
    },
})


return lazy
