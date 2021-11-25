local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beaut = require("beautiful")

local taglist = require("ui.launcher.taglist")
local applist = require("ui.launcher.applist")

local rubato = require("rubato")

local function make_subscribed(widget, initial_y, target_y)
    local diff = target_y - initial_y
    return setmetatable({
        initial = initial_y, target = target_y,
        widget = widget
    }, { __call = function (_, t)
        print(widget.y, initial_y, target_y, diff, t)
        widget.y = initial_y + (diff * t)
        if t == 0 and widget.visible then widget.visible = false
        elseif t > 0 and not widget.visible then widget.visible = true
        end
        widget:emit_signal("widget::redraw_needed")
        -- widget:set_y(initial_y + diff * t)
    end})
end

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

    local subscribed

    popup:connect_signal("animate::forward", function (wdg, target_pos)
        print("animate::forward")

        if subscribed ~= nil then timed:unsubscribe(subscribed) end

        local target_y = target_pos.y
        subscribed = make_subscribed(popup, popup.y, target_y)
        timed:subscribe(subscribed)

        timed.target = 1
    end)

    popup:connect_signal("animate::backward", function ()
        print("animate::backward")

        if subscribed ~= nil then timed.target = 0 end
    end)

    return popup
end
