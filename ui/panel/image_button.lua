local wibox = require("wibox")
local gears = require("gears")

local beautiful = require("beautiful")

return function (image, text, params)
    local params = params or {}

    local reverse_direction = params.reverse
    if reverse_direction == nil then reverse_direction = false end

    local on_click = params.on_click or function() end
    local on_enter = params.on_enter or function() end
    local on_leave = params.on_leave or function() end

    local function make_children(hovered)
        return {
            widget = wibox.container.margin,
            margins = { top = 4, bottom = 4, right = 8, left = 8 },

            {
                layout = wibox.layout.align.horizontal,

                middle = wibox.widget.imagebox(image, true, gears.shape.circle),
                [reverse_direction and "first" or "third"] = hovered and wibox.widget {
                    widget = wibox.widget.textbox,
                    text = text,
                    font = "Monospace Regular 6"
                } or nil
            }
        }
    end

    local widget = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg_focus,
        shape = gears.shape.rounded_bar,

        make_children(false)
    }

    widget:connect_signal("mouse::enter", function (self, fwres)
        self:set_children{ wibox.widget(make_children(true)) }
        self:emit_signal("widget::layout_changed")
        
        on_enter(fwres)
    end)

    widget:connect_signal("mouse::leave", function (self, fwres)
        self:set_children{ wibox.widget(make_children(false)) }
        self:emit_signal("widget::layout_changed")

        on_leave(fwres)
    end)

    widget:connect_signal("button::release", function (self)
        on_click(self)
    end)

    return widget
end
