local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beaut = require("beautiful")

local observable = require("util.observable")

local function buttons(item, scr)
    print(item, scr)
    for k,v in pairs(item) do print(k,v) end
    local is_pinned = false
    for i,itm in pairs(scr.dock_buttons.value) do
        print(item[1], itm[1], itm[2])
        if item[2]==itm[2] then is_pinned = true end
    end

    local pin_item = (not is_pinned)
        and { "pin"  , function() local d=scr.dock_buttons d.value[item[2]] = item d:notify() end }
        or  { "unpin", function() local d=scr.dock_buttons d.value[item[2]] = nil  d:notify() end }

    return {
        { "launch", function() item[3]() end },
        pin_item,
        { "close", function (_, popup) popup.visible = false end }
    }
end

return function (x, y, wdg, item, scr)
    local popup

    local btn_wgts = gears.table.map(function (it)
        local hovered = observable.new()

        local btn = wibox.widget {
            widget = wibox.container.background, {
                widget = wibox.container.margin, margins = beaut.launcher_dropdown_item_spacing, {
                    widget = wibox.widget.textbox, text = it[1]
                }
            }
        }

        btn:connect_signal("mouse::enter", function() hovered:set(true)  end)
        btn:connect_signal("mouse::leave", function() hovered:set(false) end)
        hovered:connect(function (hvr) btn:set_bg(hvr and beaut.bg_focus or beaut.bg_normal) end)

        if it[2] then
            btn:add_button(awful.button({}, awful.button.names.LEFT, function() it[2](item, popup) popup.visible = false end))
        end

        return btn
    end, buttons(item, scr))

    popup = awful.popup {
        x = x, y = y, ontop = true,

        widget = wibox.widget {
            layout = wibox.layout.align.vertical,
            table.unpack(btn_wgts)
        },

        border_width = beaut.launcher_dropdown_border_width,
        border_color = beaut.launcher_dropdown_border_color
    }

    return popup
end