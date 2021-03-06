local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local beaut = require("beautiful")

local observable = require("util.observable")

local app_button = require("ui.launcher.app_button")
local mode_selector = require("ui.launcher.mode_selector")

local popup = require("ui.launcher.app_popup")

local function getapplist(mode)
    local ok, res = pcall(require, "ui.launcher.btnlists." .. mode)
    if ok then return res
    else return {} end
end

return function ()
    local selected_mode = observable.new()
    local all_modes = { "applications", "tasks", "sysmenu" }
    -- local lists = {}

    local grid_template = {
        layout = wibox.layout.grid,
        forced_num_cols = beaut.launcher_grid_ncols or 4,
        spacing = beaut.launcher_grid_spacing or 8,
        homogeneous = true,
        min_cols_size = beaut.launcher_grid_size or 96
    }

    local grid = wibox.widget(grid_template)

    selected_mode:connect(function (mode)
        -- if not lists[mode] then
            local list = {}
            for _,item in pairs(getapplist(mode)) do
                local on_click = item[3]

                if type(item[3]) == "string" then
                    local cmd = item[3]
                    on_click = function() awful.spawn(cmd) end
                end

                item[3] = on_click

                local btn = app_button {
                    icon = item[1], text = item[2]
                }

                btn:connect_signal("button::press", function (btn, lx, ly, mb, m, fwres)
                    if mb == 1 then on_click()
                    elseif mb == 3 then
                        local xy = mouse.coords()
                        popup(xy.x, xy.y, btn, gears.table.clone(item), mouse.screen)
                    end
                end)

                table.insert(list, btn)
            end
            -- lists[mode] = list
        -- end
        grid:set_children(list)
    end)

    selected_mode:set("tasks")

    local w = {
        layout = wibox.layout.fixed.vertical,
        mode_selector(selected_mode, all_modes),
        grid
    }

    return wibox.widget(w)
end