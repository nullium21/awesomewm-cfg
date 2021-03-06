local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

return function (x, y, image, text)
    return awful.popup {
        x = x, y = y,

        shape = gears.shape.rounded_rect,

        widget = wibox.widget {
            widget = wibox.container.margin,
            margins = 8,

            forced_height = 40,

            {
                widget = wibox.container.place, valign = "center",
                {
                    layout = wibox.layout.fixed.horizontal,
                    {
                        widget = wibox.container.margin, right = 8,
                        wibox.widget.imagebox(image, false),
                    },
                    {
                        widget = wibox.container.place, halign = "center", valign = "center",
                        { widget = wibox.widget.textbox, text = text, font = "Monospace 8" }
                    }
                }
            }
        }
    }
end
