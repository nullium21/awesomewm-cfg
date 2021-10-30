local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")

local taglist = require("ui.taglist")
local mode_selector = require("ui.launcher.mode_selector")
local app_button = require("ui.launcher.app_button")

local observable = require("util.observable")

local function placement(d, args)
    args.offset = { x = -20, y = -8 }
    return awful.placement.next_to(d, args)
end

local function getapplist(mode)
    local ok, res = pcall(require, "ui.launcher." .. mode)
    if ok then return res
    else return {} end
end

local function applist(state)
    local selected_mode = observable.new()
    local all_modes = { "applications", "tasks", "sysmenu" }
    local lists = {}

    local grid_template = {
        layout = wibox.layout.grid,
        forced_num_cols = 4,
        forced_num_rows = 2,
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

local function launcher(state)
    local state = state or {}

    return wibox.widget {
        widget = wibox.container.margin, margins = 24,

        {
            layout = wibox.layout.fixed.horizontal, spacing = 24,

            taglist(state.screen),
            applist()
        }
    }
end

return function (scr)
    return awful.popup {
        placement = placement,

        shape = gears.shape.rounded_rect,

        widget = launcher({ screen = scr })
    }
end
