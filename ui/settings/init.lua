local wibox = require("wibox")
local beaut = require("beautiful")

local launcher = require("ui.launcher")

local buttons = {
    { text="",                type="toggle" },
    { text="",                type="toggle" },
}

local button = require('ui.settings.button')

return function (scr)
    local settings_grid = {
        layout = wibox.layout.grid,
        forced_num_cols = beaut.settings_grid_ncols or 4,
        forced_num_rows = beaut.settings_grid_nrows or 5,
        homogeneous = true, expand = false,
        min_cols_size = beaut.settings_grid_size or 64,
        min_rows_size = beaut.settings_grid_size or 64,
        spacing = beaut.settings_grid_spacing or 8
    }

    for i,btn in pairs(buttons) do
        table.insert(settings_grid, button(btn))
    end

    return launcher(scr, {
        widget = wibox.widget {
            widget = wibox.container.margin, margins = beaut.settings_spacing or 24,

            wibox.widget(settings_grid)
        },
        anchor = { "back" }
    })
end
