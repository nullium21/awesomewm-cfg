local wibox = require "wibox"

local button = require "ui.settings.button"

local wificheck = require "util.wificheck"

return function ()
    local textbox = wibox.widget.textbox "none"
    local btn = button { text="", type="toggle", content=textbox }

    wificheck(function (data)
        if data.up then
            btn:emit_signal("action::enable")

            textbox.text = data.ssid
            btn:emit_signal("widget::redraw_needed")
        else
            btn:emit_signal("action::disable")

            textbox.text = "none"
            btn:emit_signal("widget::redraw_needed")
        end
    end)

    return btn
end
