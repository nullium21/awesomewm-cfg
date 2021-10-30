local popup = require("ui.dock.popup")

return function (screen)
    local _M = {}

    local popups = {}

    function _M.on_item_click(item_idx, item_el, item)

    end

    function _M.on_item_menter(item_idx, item_el, item)
        if not popups[item_idx] then
            popups[item_idx] = popup(
                item_el.x, screen.geometry.height - item_el.widget_height - 48 - 16,
                item[1], item[2])
        end

        popups[item_idx].visible = true
    end

    function _M.on_item_mleave(item_idx, item_el, item)
        if popups[item_idx] then
            popups[item_idx].visible = false
        end
    end

    return _M
end
