pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- require("awful.autofocus")
-- -- Widget and layout library
local wibox = require("wibox")
-- -- Theme handling library
local beautiful = require("beautiful")
-- -- Notification library
local naughty = require("naughty")
-- -- Declarative object management
-- local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- -- Enable hotkeys help widget for VIM and other apps
-- -- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local image_button = require("ui.image_button")

local dock = require("ui.dock")
local dock_handlers = require("ui.dock_handlers")

screen.connect_signal("request::desktop_decoration", function (s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    s.launcher_btn = image_button(beautiful.awesome_icon, "launch")
    s.settings_btn = image_button(beautiful.awesome_icon, "settings", { reverse = true })

    s.dock = dock({
        { beautiful.awesome_icon, "firefox" },
        { beautiful.awesome_icon, "terminal" }
    }, dock_handlers(s), s)

    s.wibar = awful.wibar {
        position = "bottom",
        x = 0,
        y = 0,
        screen = s,
        margins = 4,
        bg = "#f1ebdd", fg = "#000000",
        shape = gears.shape.rounded_bar,
        widget = {
            widget = wibox.container.margin, left = 0, right = 0, top = 0, bottom = 0, {
                layout = wibox.layout.stack,
                { widget = wibox.container.place, halign = "left", s.launcher_btn },
                { widget = wibox.container.place, halign = "center", s.dock },
                { widget = wibox.container.place, halign = "right", s.settings_btn }
            }
        }
    }
end)
