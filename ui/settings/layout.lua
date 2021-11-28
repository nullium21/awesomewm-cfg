local button = require "ui.settings.button"

local wifi_btn = require "ui.settings.wifi_button"

local blth_btn = button { text="", type="toggle" }

return {
    { x=1,y=1, w=3, wifi_btn() },
    { x=4,y=1, w=1, blth_btn },
}