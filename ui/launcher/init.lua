local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beaut = require("beautiful")

local taglist = require("ui.launcher.taglist")
local applist = require("ui.launcher.applist")

local function launcher(state)
    local state = state or {}

    return wibox.widget {
        widget = wibox.container.margin, margins = beaut.launcher_spacing or 24,

        {
            layout = wibox.layout.fixed.horizontal, spacing = beaut.launcher_spacing or 24,

            taglist(state.screen),
            applist()
        }
    }
end

return function (scr)
    return awful.popup {
        preferred_positions = { "top" },
        preferred_anchors = { "front" },

        ontop = true,

        shape = gears.shape.rounded_rect,

        widget = launcher({ screen = scr })
    }
end
