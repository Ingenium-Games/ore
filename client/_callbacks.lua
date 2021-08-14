-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
-- https://github.com/pitermcflebor/pmc-callbacks (MIT LICENSE)

RegisterNetEvent('Callback:Client')
AddEventHandler('Callback:Client', function(eventName, ...)
    local p = promise.new()

    TriggerEvent(('__CB:Client:%s'):format(eventName), function(...)
        p:resolve({...})
    end, ...)

    local result = Citizen.Await(p)
    TriggerServerEvent(('Callback:Server:%s'):format(eventName), table.unpack(result))
end)

function c.TriggerServerCallback(eventName, ...)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))

    local p = promise.new()
    local ticket = GetGameTimer()

    RegisterNetEvent(('Callback:Client:%s:%s'):format(eventName, ticket))
    local e = AddEventHandler(('Callback:Client:%s:%s'):format(eventName, ticket), function(...)
        p:resolve({...})
    end)

    TriggerServerEvent('Callback:Server', eventName, ticket, ...)

    local result = Citizen.Await(p)
    RemoveEventHandler(e)
    return table.unpack(result)
end

function c.RegisterClientCallback(eventName, fn)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))
    assert(type(fn) == 'function', 'Invalid Lua type at argument #2, expected function, got ' .. type(fn))

    AddEventHandler(('__CB:Client:%s'):format(eventName), function(cb, ...)
        cb(fn(...))
    end)
end

-- ====================================================================================--
