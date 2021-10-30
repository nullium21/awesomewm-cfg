local beautiful = require("beautiful")

return {
    { beautiful.awesome_icon, "power off" },
    { beautiful.awesome_icon, "reboot" },
    { beautiful.awesome_icon, "log out", function () awesome.quit() end },
    { beautiful.awesome_icon, "wm restart", function() awesome.restart() end }
}