local spawn = require("awful.spawn")
local timer = require("gears.timer")

return function (callback)
    local last_ssid

    local tmr = timer {
        timeout = 10, call_now = true,
        autostart = true,
        callback = function ()
            spawn.easy_async({"iwgetid", "-r"}, function (out)
                if out ~= last_ssid then
                    last_ssid = out
                    callback{ ssid = out, up = #out > 0 }
                end
            end)
        end
    }
end
