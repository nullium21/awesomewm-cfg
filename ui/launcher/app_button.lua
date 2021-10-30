local wibox = require("wibox")
local beautiful = require("beautiful")

local observable = require("util.observable")

local function bg(hovered)
    return hovered and beautiful.bg_focus or beautiful.bg_normal
end

return function (args)
    local icon = args.icon
    local text = args.text
    local on_click = args.on_click or function() end

    local hovered = observable.new()

    local wgt = wibox.widget {
        widget = wibox.container.background, {
            widget = wibox.container.margin, margins = 4, {
                layout = wibox.layout.fixed.vertical,
                icon and { widget = wibox.widget.imagebox, image = icon, forced_width = 88, forced_height = 88 } or nil,
                text and { widget = wibox.container.place, halign = "center", {
                    widget = wibox.widget.textbox, text = text, font = "Monospace 6" }
                } or nil
            }
        }
    }

    hovered:connect(function (value) wgt:set_bg(bg(value)) end)

    hovered:set(false)

    wgt:connect_signal("mouse::enter", function (self) hovered:set(true) end)
    wgt:connect_signal("mouse::leave", function (self) hovered:set(false) end)
    wgt:connect_signal("button::press", function (self) on_click() end)

    return wgt
end