local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beaut = require("beautiful")

local taglist = require("ui.launcher.taglist")
local applist = require("ui.launcher.applist")

local rubato = require("rubato")
local animate = require("ui.animate")

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

return function (scr, custom)
    local custom = custom or {}

    local timed = rubato.timed {
        duration = custom.anim_duration or 1,
        intro = custom.anim_intro or 0.5,
        easing = custom.anim_easing or rubato.quadratic
    }

    local popup = awful.popup {
        preferred_positions =  custom.pos or { "top" },
        preferred_anchors = custom.anchor or { "front" },

        ontop = true,

        shape = gears.shape.rounded_rect,

        widget = custom.widget or launcher({ screen = scr })
    }

    animate {
        widget = popup,
        timed  = timed,
        on_t = {
            { "=", 0, function(wdg) wdg.visible = false end },
            { ">", 0, function(wdg) wdg.visible = true  end }
        }
    }

    return popup
end
