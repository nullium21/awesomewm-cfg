local wibox = require "wibox"

local spawn = require("awful.spawn")

local button = require "ui.settings.button"

local wificheck = require "util.wificheck"

return function ()
    local textbox = wibox.widget { widget=wibox.widget.textbox, text="none", valign="center" }
    local btn = button { text="", type="toggle", content={
        widget=wibox.container.place, textbox
    }, hoverable=false }

    btn:connect_signal("action::enable", function (_, script_triggered)
        if script_triggered then return end

        spawn("nmcli r wifi on")
    end)

    btn:connect_signal("action::disable", function (_, script_triggered)
        if script_triggered then return end

        spawn("nmcli r wifi off")
    end)

    wificheck(function (data)
        if data.up then
            btn:emit_signal("action::enable", true)

            textbox.text = data.ssid
            btn:emit_signal("widget::redraw_needed")
        else
            btn:emit_signal("action::disable", true)

            textbox.text = "none"
            btn:emit_signal("widget::redraw_needed")
        end
    end)

    return btn
end
