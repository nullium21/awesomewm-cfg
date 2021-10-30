local wibox = require("wibox")

local observable = require("util.observable")

local app_button = require("ui.launcher.app_button")
local mode_selector = require("ui.launcher.mode_selector")

local function getapplist(mode)
    local ok, res = pcall(require, "ui.launcher.btnlists." .. mode)
    if ok then return res
    else return {} end
end

return function ()
    local selected_mode = observable.new()
    local all_modes = { "applications", "tasks", "sysmenu" }
    local lists = {}

    local grid_template = {
        layout = wibox.layout.grid,
        forced_num_cols = 4,
        spacing = 8,
        homogeneous = true,
        min_cols_size = 96
    }

    local grid = wibox.widget(grid_template)

    selected_mode:connect(function (mode)
        if not lists[mode] then
            local list = {}
            for _,item in pairs(getapplist(mode)) do
                local btn = app_button {
                    icon = item[1], text = item[2], on_click = item[3]
                }

                table.insert(list, btn)
            end
            lists[mode] = list
        end
        grid:set_children(lists[mode])
    end)

    selected_mode:set("tasks")

    local w = {
        layout = wibox.layout.fixed.vertical,
        mode_selector(selected_mode, all_modes),
        grid
    }

    return wibox.widget(w)
end