local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

return function (scr)
    local w = {
        layout = wibox.layout.fixed.vertical, spacing = 4,
        { widget = wibox.widget.textbox, text = "tags", font = "Monospace 8" }
    }

    local alltags = scr.tags
    for _,tag in pairs(alltags) do
        local btn = wibox.widget {
            widget = wibox.container.background, {
                bg = tag.selected and beautiful.bg_focus or beautiful.bg_normal,
                widget = wibox.container.place, halign = "center", {
                    widget = wibox.container.margin, margins = 4, {
                        widget = wibox.widget.textbox, text = tag.name, font = "Monospace 6"
                    }
                }
            },
        }

        btn:connect_signal("mouse::enter", function (self)
            self:set_bg(beautiful.bg_focus)
            self:emit_signal("widget::redraw_needed")
        end)

        btn:connect_signal("mouse::leave", function (self)
            if not tag.selected then
                self:set_bg(beautiful.bg_normal)
                self:emit_signal("widget::redraw_needed")
            end
        end)

        btn:connect_signal("button::press", function (self)
            tag:view_only()
        end)

        tag:connect_signal("property::selected", function ()
            btn:set_bg(tag.selected and beautiful.bg_focus or beautiful.bg_normal)
            btn:emit_signal("widget::redraw_needed")
        end)

        table.insert(w, btn)
    end

    return wibox.widget(w)
end