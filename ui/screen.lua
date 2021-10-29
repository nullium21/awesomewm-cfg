local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

local dock = require("ui.dock")
local dock_handlers = require("ui.dock_handlers")

local image_button = require("ui.image_button")

return function (scr)
    scr.launcher_btn = image_button(beautiful.awesome_icon, "launch")
    scr.settings_btn = image_button(beautiful.awesome_icon, "settings", { reverse = true })

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
        bg = "#f1ebdd", fg = "#000000",
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
