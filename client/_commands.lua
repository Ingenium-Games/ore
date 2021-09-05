-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.commands = {}
--[[
NOTES.
    - To enforce the requirement to hold the key down, add the + to the commands not commented out.
    - Example
    RegisterCommand('+cross', function() TriggerEvent("Client:Animation.CrossedArms", true, GetPlayerPed(-1)) end, false)
    RegisterCommand('-cross', function() TriggerEvent("Client:Animation.CrossedArms", false, GetPlayerPed(-1)) end, false)
    RegisterKeyMapping('+cross', 'Cross arms', 'keyboard', 'z')
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

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

TriggerEvent("chat:addSuggestion", "/switch", "Use to change your character(s).")

TriggerEvent("chat:addSuggestion", "/ban", "Admin Permission(s) Required.", {
    {name = "1", help ="Server ID"},
})

TriggerEvent("chat:addSuggestion", "/kick", "Admin Permission(s) Required.", {
    {name = "1", help ="Server ID"},
})

TriggerEvent("chat:addSuggestion", "/setjob", "Admin Permission(s) Required.", {
    {name = "1", help ="Server ID"},
    {name = "2", help ="Job Name"},
    {name = "3", help ="Job Grade"},
})

--[[
if IsPlayerFreeAiming(PlayerId()) then
    local bool, target = GetEntityPlayerIsFreeAimingAt(PlayerId())

end
]]--

RegisterCommand('car', function(source, args, rawCommand)
    local pos = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local coords = {x = pos.x, y = pos.y, z = pos.z, h = heading}
    local vehicle = c.TriggerServerCallback("Create:Vehicle", args[1], coords)
end, false)