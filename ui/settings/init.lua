local wibox = require("wibox")
local beaut = require("beautiful")
local gears = require("gears")

local observable = require("util.observable")

local launcher = require("ui.launcher")

local buttons = {
    { text="",                type="toggle" },
    { text="",                type="toggle" },
}

local function button_shape(cr, w, h)
    return gears.shape.rounded_rect(cr, w, h, 16)
end

local button_bg = {
    hover = beaut.bg_focus,
    normal = beaut.bg_normal,
    active = beaut.bg_focus,
}

local function button(data)
    local icon_size = (beaut.settings_grid_size or 64) - 8

    local state = observable.new()

    local icon_wdg
    if data.text then icon_wdg = wibox.widget {
        widget = wibox.widget.textbox, text = data.text,
        font = beaut.font_icon, align = "center", valign = "center"
    } elseif data.icon then icon_wdg = wibox.widget {
        widget = wibox.widget.imagebox, image = data.icon,
        clip_shape = gears.shape.circle
    } end

    if icon_wdg then
        icon_wdg.forced_width = icon_size
        icon_wdg.forced_height = icon_size
    end

    local widget = wibox.widget {
        shape = button_shape,
        widget = wibox.container.background, {
            widget = wibox.container.margin, margins = 4, icon_wdg
        }
    }

    state:connect(function (value) widget:set_bg(button_bg[value]) end)
    state:set("normal")

    widget:connect_signal("mouse::enter", function()
        if state.prev~="active" then state:set("hover") end
    end)
    widget:connect_signal("mouse::leave", function()
        if state.prev~="hover" then state:set(state.prev) end
    end)

    if data.type == "toggle" then
        widget:connect_signal("button::press", function (_, _, _, mb, _, _)
            if mb ~= 1 then return end

            local new_value = not (state.value == "active" or state.prev == "active")
            widget:emit_signal("action::toggle", new_value)

            if new_value == false then
                state:set("normal"); widget:emit_signal("action::enable")
            elseif new_value == true then
                state:set("active"); widget:emit_signal("action::disable")
            end
        end)
    elseif data.type == "click" then
        widget:connect_signal("button::release", function (_, _, _, mb, _, _)
            if mb ~= 1 then return end

            widget:emit_signal("action::click")
        end)
    end

    return widget
end

return function (scr)
    local settings_grid = {
        layout = wibox.layout.grid,
        forced_num_cols = beaut.settings_grid_ncols or 4,
        forced_num_rows = beaut.settings_grid_nrows or 5,
        homogeneous = true, expand = false,
        min_cols_size = beaut.settings_grid_size or 64,
        min_rows_size = beaut.settings_grid_size or 64,
        spacing = beaut.settings_grid_spacing or 8
    }

    for i,btn in pairs(buttons) do
        table.insert(settings_grid, button(btn))
    end

    return launcher(scr, {
        widget = wibox.widget {
            widget = wibox.container.margin, margins = beaut.settings_spacing or 24,

            wibox.widget(settings_grid)
        },
        anchor = { "back" }
    })
end
