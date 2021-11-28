local wibox = require "wibox"

local button = require "ui.settings.button"

local wificheck = require "util.wificheck"

local wifi_text = wibox.widget.textbox "none"
local wifi_btn = button { text="", type="toggle", content=wifi_text }
wificheck(function (data)
    if data.up then
        wifi_btn:emit_signal("action::enable")

        wifi_text.text = data.ssid
        wifi_btn:emit_signal("widget::redraw_needed")
    else
        wifi_btn:emit_signal("action::disable")

        wifi_text.text = "none"
        wifi_btn:emit_signal("widget::redraw_needed")
    end
end)

local blth_btn = button { text="", type="toggle" }

return {
    { x=1,y=1, w=3, wifi_btn },
    { x=4,y=1, w=1, blth_btn },
}