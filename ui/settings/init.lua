local wibox = require("wibox")
local beaut = require("beautiful")

local launcher = require("ui.launcher")

local layout = require('ui.settings.layout')

return function (scr)
    local settings_grid = wibox.widget {
        layout = wibox.layout.grid,
        forced_num_cols = beaut.settings_grid_ncols or 4,
        forced_num_rows = beaut.settings_grid_nrows or 5,
        homogeneous = true, expand = false,
        min_cols_size = beaut.settings_grid_size or 64,
        min_rows_size = beaut.settings_grid_size or 64,
        spacing = beaut.settings_grid_spacing or 8
    }

    for _, item in pairs(layout) do
        settings_grid:add_widget_at(item[1], item.y, item.x, item.h or 1, item.w or 1)
    end

    return launcher(scr, {
        widget = wibox.widget {
            widget = wibox.container.margin, margins = beaut.settings_spacing or 24,

            settings_grid
        },
        anchor = { "back" }
    })
end
