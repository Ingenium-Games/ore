-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--
-- https://github.com/pitermcflebor/pmc-callbacks (MIT LICENSE)

RegisterNetEvent('Callback:Server')
AddEventHandler('Callback:Server', function(eventName, ticket, ...)
    local s = source
    local p = promise.new()

    TriggerEvent('__CB:Server:' .. eventName, function(...)
        p:resolve({...})
    end, s, ...)

    local result = Citizen.Await(p)
    TriggerClientEvent(('Callback:Client:%s:%s'):format(eventName, ticket), s, table.unpack(result))
end)

function c.RegisterServerCallback(eventName, fn)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))
    assert(type(fn) == 'function', 'Invalid Lua type at argument #2, expected function, got ' .. type(fn))

    AddEventHandler(('__CB:Server:%s'):format(eventName), function(cb, s, ...)
        local result = {fn(s, ...)}
        cb(table.unpack(result))
    end)
end

function c.TriggerClientCallback(src, eventName, ...)
    assert(type(src) == 'number', 'Invalid Lua type at argument #1, expected number, got ' .. type(src))
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #2, expected string, got ' .. type(eventName))

    local p = promise.new()

    RegisterNetEvent('Callback:Server:' .. eventName)
    local e = AddEventHandler('Callback:Server:' .. eventName, function(...)
        local s = source
        if src == s then
            p:resolve({...})
        end
    end)

    TriggerClientEvent('Callback:Client', src, eventName, ...)

    local result = Citizen.Await(p)
    RemoveEventHandler(e)
    return table.unpack(result)
end

-- ====================================================================================--