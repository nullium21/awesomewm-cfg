local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

local taglist = require("ui.taglist")

local observable = require("util.observable")

local function placement(d, args)
    args.offset = { x = -20, y = -8 }
    return awful.placement.next_to(d, args)
end

local function applist(state)
    local selected_mode = observable.new()
    local all_modes = { "applications", "tasks", "sysmenu" }

    local function mode_selector()
        local main_wgt = { layout = wibox.layout.fixed.horizontal, spacing = 8 }

        for _,mode in pairs(all_modes) do
            local fg = beautiful.fg_disabled
            local wgt = wibox.widget {
                widget = wibox.container.background, fg = fg,
                { widget = wibox.widget.textbox, text = mode, font = "Monospace 8" }
            }

            selected_mode:connect(function (new, old)
                if new == mode then
                    wgt:set_fg(beautiful.fg_normal)
                else
                    wgt:set_fg(beautiful.fg_disabled)
                end
            end)

            wgt:connect_signal("mouse::enter", function ()
                selected_mode:set(mode)
            end)
            wgt:connect_signal("mouse::leave", function ()
                if selected_mode.value == mode then
                    selected_mode.value = selected_mode.prev
                end
            end)
            wgt:connect_signal("mouse::click", function ()
                selected_mode:set(mode)
            end)

            table.insert(main_wgt, wgt)
        end

        return wibox.widget(main_wgt)
    end

    selected_mode:connect(print)
    selected_mode:set("tasks")

    local w = {
        layout = wibox.layout.fixed.vertical,
        mode_selector(),
        {
            layout = wibox.layout.grid,
            forced_num_cols = 4,
            spacing = 8,
            homogeneous = true,
            min_cols_size = 96
        }
    }

    return wibox.widget(w)
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
        placement = placement,

        shape = gears.shape.rounded_rect,

        widget = launcher({ screen = scr })
    }
end
