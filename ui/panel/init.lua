local beaut = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local button   = require("ui.panel.image_button")
local launcher = require("ui.launcher")
local dock     = require("ui.dock")
local dhandlrs = require("ui.dock.handlers")

local observable = require("util.observable")

local function reposition(s)
    return function (l) if l.visible then l:move_next_to(s.wibar); l.y = l.y - 8 end end
end

return function (scr)
    local dock_buttons = observable.new()

    local launcher_btn = button(beaut.awesome_icon, "launch")
    local settings_btn = button(beaut.awesome_icon, "settings", { reverse = true })

    local launcher     = launcher(scr)
    launcher:connect_signal("property::height" , reposition(scr))
    launcher:connect_signal("property::visible", reposition(scr))

    launcher_btn:connect_signal("button::press", function () launcher.visible = not launcher.visible end)

    -- local settings     = settings()
    -- settings:connect_signal("property::height" , reposition(scr))
    -- settings:connect_signal("property::visible", reposition(scr))

    -- settings_btn:connect_signal("button::press", function () settings.visible = not settings.visible end)

    local dock = dock(nil, dhandlrs(scr), scr)
    dock_buttons:connect(function (btns, old)
        dock:emit_signal("dock::buttons", btns)
    end)

    scr.wibar = awful.wibar {
        position = "bottom",
        x = 0,
        y = 0,
        screen = scr,
        margins = 4,
        shape = gears.shape.rounded_bar,
        widget = {
            widget = wibox.container.margin, left = 0, right = 0, top = 0, bottom = 0, {
                layout = wibox.layout.stack,
                { widget = wibox.container.place, halign = "left", launcher_btn },
                { widget = wibox.container.place, halign = "center", dock },
                { widget = wibox.container.place, halign = "right", settings_btn }
            }
        }
    }
end
