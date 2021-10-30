local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

local taglist = require("ui.launcher.taglist")
local applist = require("ui.launcher.applist")

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
            applist()
        }
    }
end

return function (scr)
    return awful.popup {
        preferred_positions = { "top" },
        preferred_anchors = { "front" },

        shape = gears.shape.rounded_rect,

        widget = launcher({ screen = scr })
    }
end
