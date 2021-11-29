local wibox = require "wibox"

local spawn = require("awful.spawn")

local button = require "ui.settings.button"

local btcheck = require "util.btcheck"

return function ()
    local btn = button { text="", type="toggle", hoverable=false }

    btn:connect_signal("action::enable", function (_, script_triggered)
        if script_triggered then return end

        spawn("rfkill unblock bluetooth")
    end)

    btn:connect_signal("action::disable", function (_, script_triggered)
        if script_triggered then return end

        spawn("rfkill block bluetooth")
    end)

    btcheck(function (data)
        print(data, data.up)

        if data.up then
            btn:emit_signal("action::enable", true)
        else
            btn:emit_signal("action::disable", true)
        end
    end)

    return btn
end
