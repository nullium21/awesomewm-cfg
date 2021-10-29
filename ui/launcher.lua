local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

local taglist = require("ui.taglist")

local function placement(d, args)
    args.offset = { x = -20, y = -8 }
    return awful.placement.next_to(d, args)
end

local function launcher(state)
    local state = state or {}

    return wibox.widget {
        widget = wibox.container.margin, margins = 24,

        {
            layout = wibox.layout.fixed.horizontal, spacing = 24,

            taglist(state.screen),
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

return function (scr)
    return awful.popup {
        placement = placement,

        shape = gears.shape.rounded_rect,

        widget = launcher({ screen = scr })
    }
end
