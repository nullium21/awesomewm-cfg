local awful = require("awful")
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
    local on_rclick = args.on_rclick or function() end

    local hovered = observable.new()

    local icon_size = (beautiful.launcher_grid_size or 96) - 8

    local wgt = wibox.widget {
        widget = wibox.container.background, {
            widget = wibox.container.margin, margins = 4, {
                layout = wibox.layout.fixed.vertical,
                icon and { widget = wibox.container.place, halign = "center", {
                    widget = wibox.widget.imagebox, image = icon, forced_width = icon_size, forced_height = icon_size }
                } or nil,
                text and { widget = wibox.container.place, halign = "center", {
                    widget = wibox.widget.textbox, text = text, font = "Monospace 6" }
                } or nil
            }
        }
    }

    hovered:connect(function (value) wgt:set_bg(bg(value)) end)

    hovered:set(false)

    if icon ~= nil or text ~= nil then
        wgt:connect_signal("mouse::enter", function (self) hovered:set(true) end)
        wgt:connect_signal("mouse::leave", function (self) hovered:set(false) end)
        wgt:connect_signal("button::press", function (...) on_click(...) end)
    end

    return wgt
end