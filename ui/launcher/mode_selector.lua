local wibox = require("wibox")
local beautiful = require("beautiful")

return function (selected_mode, all_modes)
    local main_wgt = { layout = wibox.layout.fixed.horizontal, spacing = beautiful.launcher_mode_selector_spacing or 8 }

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
