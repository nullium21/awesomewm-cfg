local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beaut = require("beautiful")

local function launcher(state)
    return wibox.widget {
        widget = wibox.container.margin, margins = beaut.settings_spacing or 24,

        {
            layout = wibox.layout.fixed.horizontal, spacing = beaut.settings_spacing or 24,

            
        }
    }
end

return function (scr)
    return awful.popup {
        preferred_positions = { "top" },
        preferred_anchors = { "back" },

        ontop = true,

        shape = gears.shape.rounded_rect,

        widget = launcher({ screen = scr })
    }
end
