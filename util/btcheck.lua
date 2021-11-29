local spawn = require("awful.spawn")
local timer = require("gears.timer")

return function (callback)
    local last_status

    local tmr = timer {
        timeout = 5, call_now = true,
        autostart = true,
        callback = function ()
            spawn.easy_async({"hciconfig", "dev"}, function (out)
                print(out)

                local status
                if out:match("UP") then status = true
                elseif out:match("DOWN") then status = false
                else return end

                if last_status ~= status then callback{ up = status } end
            end)
        end
    }
end
