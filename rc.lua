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

screen.connect_signal("request::desktop_decoration", require("ui.screen"))
