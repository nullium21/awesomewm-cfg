local wibox = require "wibox"

local button = require "ui.settings.button"

local wificheck = require "util.wificheck"

return function ()
    local textbox = wibox.widget { widget=wibox.widget.textbox, text="none", valign="center" }
    local btn = button { text="", type="toggle", content={
        widget=wibox.container.place, textbox
    }, hoverable=false }

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
