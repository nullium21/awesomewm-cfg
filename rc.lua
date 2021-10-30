pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

screen.connect_signal("request::desktop_decoration", require("ui.screen"))
screen.connect_signal("request::wallpaper", require("ui.wallpaper"))
