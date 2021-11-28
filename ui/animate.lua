local function compute_diffs(fields)
    local diffs = {}
    for f,data in pairs(fields) do
        diffs[f] = { data.from, data.to - data.from }
    end

    return diffs
end

return function (widget, timed, fields)
    fields = fields or {}

    local diffs = compute_diffs(fields)

    local subscribed = false
    local subfn = function (t)
        for f,diff in pairs(diffs) do
            local value = diff[1] + (t * diff[2])

            if fields[f].set then
                fields[f].set(widget, value, t, f)
            else
                widget[f] = value
            end
        end
    end

    widget:connect_signal("animate::fields", function (_, new_fields)
        fields = new_fields
        diffs = compute_diffs(fields)
    end)

    widget:connect_signal("animate::field", function (_, key, value)
        fields[key] = value
        diffs = compute_diffs(fields)
    end)

    widget:connect_signal("animate::timed", function (_, new_timed)
        timed:unsubscribe(subfn)
        timed = new_timed
        timed:subscribe(subfn)
        subscribed = true
    end)

    widget:connect_signal("animate::forward", function ()
        if not subscribed then timed:subscribe(subfn); subscribed = true end

        timed.target = 1
    end)

    widget:connect_signal("animate::backward", function ()
        if not subscribed then timed:subscribe(subfn); subscribed = true end

        timed.target = 0
    end)

    widget:connect_signal("animate::target", function (_, target)
        if not subscribed then timed:subscribe(subfn); subscribed = true end

        timed.target = target
    end)

    widget:connect_signal("animate::unsubscribe", function ()
        timed:unsubscribe(subfn)
        subscribed = false
    end)
end
