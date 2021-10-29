local wibox = require("wibox")
local gears = require("gears")

local image_button = require("ui.image_button")

return function (button_data, handlers, screen)
    local handlers = handlers or {}

    local on_item_click  = handlers.on_item_click  or function() end
    local on_item_menter = handlers.on_item_menter or function() end
    local on_item_mleave = handlers.on_item_mleave or function() end

    local buttons = {}
    for i,v in pairs(button_data) do
        local btn = image_button(v[1], nil, {
            on_click = function (el) on_item_click(i, el, v) end,
            on_enter = function (el) on_item_menter(i,el, v) end,
            on_leave = function (el) on_item_mleave(i,el, v) end
        })

        table.insert(buttons, btn)
    end

    local widget = wibox.widget {
        widget = wibox.container.background,
        bg = "#c7c1b3", fg = "#000000",
        shape = gears.shape.rounded_bar,

        { layout = wibox.layout.fixed.horizontal, table.unpack(buttons) }
    }

    return widget
end
