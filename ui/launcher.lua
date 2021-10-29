local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

local function taglist()
    local w = {
        layout = wibox.layout.fixed.vertical, spacing = 4,
        { widget = wibox.widget.textbox, text = "tags", font = "Monospace 8" }
    }

    local alltags = awful.screen.focused().tags
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

local function launcher(state)
    local state = state or {}

    return wibox.widget {
        widget = wibox.container.margin, margins = 24,

        {
            layout = wibox.layout.fixed.horizontal, spacing = 24,

            taglist(),
            {
                layout = wibox.layout.fixed.vertical,
                { widget = wibox.widget.textbox, text = "applications", font = "Monospace 8" },
                {
                    layout = wibox.layout.grid,
                    forced_num_cols = 4,
                    spacing = 8,
                    homogeneous = true,
                    min_cols_size = 96
                }
            }
        }
    }
end

return function (wibar, offset)
    return awful.popup {
        placement = awful.placement.next_to(wibar, { preferred_positions = {"top"} }),
        offset = offset,

        shape = gears.shape.rounded_rect,

        widget = launcher()
    }
end
