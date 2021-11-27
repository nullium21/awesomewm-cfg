local beaut = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local button   = require("ui.panel.image_button")
local launcher = require("ui.launcher")
local settings = require("ui.settings")
local dock     = require("ui.dock")
local dhandlrs = require("ui.dock.handlers")

local observable = require("util.observable")

local function reposition(s, side)
    return function (l)
        if not l.visible then return end

        local orig_x
        if side=="left" then
            orig_x = -l.width
        elseif side=="right" then
            orig_x = s.geometry.width
        end

        l:move_next_to(s.wibar); l.y = l.y - 8
        local target_x = l.x
        l.x = orig_x

        l:emit_signal("animate::forward", { x = target_x })
    end
end

local function change_popup_visible(popup)
    return function () if popup.visible then
        popup:emit_signal("animate::backward")
    else
        popup.visible = true
    end end
end

return function (scr)
    scr.dock_buttons = observable.new()

    local launcher_btn = button(beaut.awesome_icon, "launch")
    local settings_btn = button(beaut.awesome_icon, "settings", { reverse = true })

    local launcher     = launcher(scr)
    launcher:connect_signal("property::height" , reposition(scr, "left"))
    launcher:connect_signal("property::visible", reposition(scr, "left"))

    launcher_btn:connect_signal("button::press", change_popup_visible(launcher))

    local settings     = settings(scr)
    settings:connect_signal("property::height" , reposition(scr, "right"))
    settings:connect_signal("property::visible", reposition(scr, "right"))

    settings_btn:connect_signal("button::press", change_popup_visible(settings))

    local dock = dock(nil, dhandlrs(scr), scr)
    scr.dock_buttons:connect(function (btns, old)
        dock:emit_signal("dock::buttons", btns)
    end)

    scr.dock_buttons:set {}

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
