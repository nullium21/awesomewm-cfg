local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

local dock = require("ui.dock")
local dock_handlers = require("ui.dock.handlers")

local image_button = require("ui.image_button")

local launcher = require("ui.launcher")

local function reposition_launcher(l, wibar)
    l:move_next_to(wibar)
    l.y = l.y - 8
end

return function (scr)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, scr, awful.layout.layouts[1])

    scr.launcher_btn = image_button(beautiful.awesome_icon, "launch")
    scr.settings_btn = image_button(beautiful.awesome_icon, "settings", { reverse = true })

    scr.launcher_btn:connect_signal("button::press", function (self, _, _, _, _, fwres)
        if (not scr.launcher) or (not scr.launcher.visible) then
            if not scr.launcher then
                scr.launcher = launcher(scr)

                reposition_launcher(scr.launcher, scr.wibar)
                scr.launcher:connect_signal("property::height", function ()
                    reposition_launcher(scr.launcher, scr.wibar)
                end)
            end
            
            scr.launcher.visible = true
        else
            scr.launcher.visible = false
        end
    end)

    scr.dock = dock({
        { beautiful.awesome_icon, "firefox" },
        { beautiful.awesome_icon, "terminal" }
    }, dock_handlers(scr), scr)

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
                { widget = wibox.container.place, halign = "left", scr.launcher_btn },
                { widget = wibox.container.place, halign = "center", scr.dock },
                { widget = wibox.container.place, halign = "right", scr.settings_btn }
            }
        }
    }
end
