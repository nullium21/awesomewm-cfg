local observable = {}

local keys = { current="__current", value="__current", prev="__prev", previous="__prev" }

function observable.new(value)
    local self = { __prev = nil, __current = value, observers = {} }

    return setmetatable(self, observable)
end

function observable:__index(key)
    if rawget(self, key) then return rawget(self, key) end
    if keys[key] then return self[keys[key]] end
    if observable[key] then return observable[key] end
end

function observable:set(value)
    local old = rawget(self, "__current")
    rawset(self, "__current", value)
    rawset(self, "__prev", old)
    for _,obs in pairs(self.observers) do obs(value, old) end
end

function observable:connect(obs)
    table.insert(self.observers, obs)
end

return setmetatable(observable, { __call = function (_, value) return observable.new(value) end })
