local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

local taglist = require("ui.taglist")

local function launcher(state)
    local state = state or {}

    return wibox.widget {
        widget = wibox.container.margin, margins = 24,

        {
            layout = wibox.layout.fixed.horizontal, spacing = 24,

            taglist(),
            {
                layout = wibox.layout.fixed.vertical,
                { widget = wibox.widget.textbox, text = "applications", font = "Monospace 8" },
                {
                    layout = wibox.layout.grid,
                    forced_num_cols = 4,
                    spacing = 8,
                    homogeneous = true,
                    min_cols_size = 96
                }
            }
        }
    }
end

return function ()
    return awful.popup {
        placement = awful.placement.next_to,
        offset = { x = 0, y = -50 },

        shape = gears.shape.rounded_rect,

        widget = launcher()
    }
end
