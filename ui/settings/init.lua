local wibox = require("wibox")
local beaut = require("beautiful")

local launcher = require("ui.launcher")

return function (scr)
    return launcher(scr, {
        widget = wibox.widget {
            widget = wibox.container.margin, margins = beaut.settings_spacing or 24
        },
        anchor = { "back" }
    })
end
