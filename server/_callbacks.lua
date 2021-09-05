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

--[[
MIT License

Copyright (c) 2020 PiterMcFlebor

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

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

c.RegisterServerCallback("GetCurrentJobs", function(source, ...) 
    local src = tonumber(source)
    return c.job.ActiveMembers()
end)

c.RegisterServerCallback("Create:Vehicle", function(source, name, coords)
    local src = tonumber(source)
    local vehicle = c.CreateVehicle(name, coords.x, coords.y, coords.z, coords.h)
    return vehicle
end)