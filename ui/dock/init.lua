local wibox = require("wibox")
local gears = require("gears")

local beautiful = require("beautiful")

local image_button = require("ui.panel.image_button")

local function buttons(data, on_item_click, on_item_menter, on_item_mleave)
    local buttons = {}

    for i,v in pairs(data or {}) do
        local btn = image_button(v[1], nil, {
            on_click = function (el) on_item_click(i, el, v) end,
            on_enter = function (el) on_item_menter(i,el, v) end,
            on_leave = function (el) on_item_mleave(i,el, v) end
        })

        table.insert(buttons, btn)
    end

    return buttons
end

return function (button_data, handlers, screen)
    local handlers = handlers or {}

    local on_item_click  = handlers.on_item_click  or function() end
    local on_item_menter = handlers.on_item_menter or function() end
    local on_item_mleave = handlers.on_item_mleave or function() end

    local btns = buttons(button_data, on_item_click, on_item_menter, on_item_mleave)

    local buttons_container = wibox.widget { layout = wibox.layout.fixed.horizontal, table.unpack(btns) }

    local widget = wibox.widget {
        widget = wibox.container.background,
        bg = beautiful.bg_focus,
        shape = gears.shape.rounded_bar,

        buttons_container
    }

    widget:connect_signal("dock::buttons", function (wdg, data)
        buttons_container:set_children(buttons(data, on_item_click, on_item_menter, on_item_mleave))
    end)

    return widget
end
