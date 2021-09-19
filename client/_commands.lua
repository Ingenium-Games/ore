-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.command = {}
c.commands = {}
--[[
NOTES
    I a trying to figure outt he best way of dynamically looping over parent and children aces
    without the need for a manually typed table referncing what else to loop into, in terms
    of parent and child relations on ACL permissions.
    Preffer to do client sided.
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

----
---@param group any "Check permissions and import the chat suggestions."
function c.command.AddSuggestions()
    for _,v in pairs(c.ace) do
        if IsAceAllowed('group.'..v) then
            c.aces[v]()
            c.debug("Added chat suggestions for group: "..v)
        else
            c.debug("Not permited to use "..v.." group commands.")
        end
        Citizen.Wait(250)
    end
end

function c.command.AddSuggestion(group, event)
    if type(event) ~= "function" then
        c.debug("Command event not passed as function.")
        return 
    end
    if not c.aces[group] then
        c.aces[group] = {}
        table.insert(c.aces[group], event)
    else
        table.insert(c.aces[group], event)    
    end
end


--[[
    Animations with Keybinding

    Example
    RegisterCommand('+cross', function() TriggerEvent("Client:Animation.CrossedArms", true, GetPlayerPed(-1)) end, false)
    RegisterCommand('-cross', function() TriggerEvent("Client:Animation.CrossedArms", false, GetPlayerPed(-1)) end, false)
    RegisterKeyMapping('+cross', 'Cross arms', 'keyboard', 'z')
]]--


RegisterCommand('cross', function(source, args, rawCommand)
    TriggerEvent("Client:Animation.CrossedArms", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/cross")
RegisterKeyMapping('cross', 'Cross arms', 'keyboard', 'NumPad1')

-- ====================================================================================--

RegisterCommand('hands', function(source, args, rawCommand)
    TriggerEvent("Client:Animation.HandsUp", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/hands")
RegisterKeyMapping('hands', 'Hands Up', 'keyboard', 'NumPad2')

-- ====================================================================================--

RegisterCommand('armhold', function(source, args, rawCommand)
    TriggerEvent("Client:Animation.ArmHold", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/armhold")
RegisterKeyMapping('armhold', 'Arm Hold', 'keyboard', 'NumPad3')

-- ====================================================================================--

-- Server Commmands and useage

--[[
if IsPlayerFreeAiming(PlayerId()) then
    local bool, target = GetEntityPlayerIsFreeAimingAt(PlayerId())

end
]]--

RegisterCommand('car', function(source, args, rawCommand)
    local car = args[1]
    local pos = GetEntityCoords(PlayerPedId())
    local head = GetEntityHeading(PlayerPedId())
    local entity, net, state = c.CreateVehicle(car, pos.x, pos.y, pos.z, head)
    print(entity, net)
    c.debug(c.table.Dump(state))
end, false)
