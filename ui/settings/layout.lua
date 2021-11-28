local button = require "ui.settings.button"

local wifi_btn = button { text="", type="toggle" }

local blth_btn = button { text="", type="toggle" }

return {
    { x=1,y=1, wifi_btn },
    { x=3,y=1, blth_btn },
}