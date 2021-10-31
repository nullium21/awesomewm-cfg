local awful = require("awful")

local panel = require("ui.panel")

return function (scr)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, scr, awful.layout.layouts[1])

    panel(scr)
end
