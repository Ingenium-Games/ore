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

RegisterCommand('test', function(source, args, rawCommand)

end, false)

-- ====================================================================================--

RegisterCommand('switch', function(source, args, rawCommand)
    local src = tonumber(source)
    local Primary_ID = c.identifier(src)
    local Character_ID = c.sql.GetActiveCharacter(Primary_ID)
    -- Send the client/sever the events once the character has changed to inactive on the db. 
    c.sql.SetCharacterInActive(Character_ID, function()
        TriggerClientEvent('Client:Character:OpeningMenu', src)
        TriggerEvent('Server:Character:Request:List', src, Primary_ID)
        c.data.RemovePlayer(src)
        -- Events to handle character removeal.
        TriggerClientEvent("Client:Character:Switch")
        TriggerEvent("Server:Character:Switch")
    end)
end, true)

-- ====================================================================================--

RegisterCommand('ban', function(source, args, rawCommand)
    local src = tonumber(source)
    if (tonumber(args[1]) == src) then
        TriggerClientEvent("Client:Notify", src, 'You cannot /ban yourself.')
    else
        local Primary_ID = c.identifier(args[1])
        local xPlayer = c.data.GetPlayer(args[1])
        c.sql.SetBanned(Primary_ID, function()
            xPlayer.Kick('You have been banned.')
            TriggerClientEvent("Client:Notify", src, 'TargetID: ' .. args[1] .. ', has been banned.')
        end)
    end
end, true)

-- ====================================================================================--

RegisterCommand('kick', function(source, args, rawCommand)
    local src = tonumber(source)
    if (tonumber(args[1]) == src) then
        TriggerClientEvent("Client:Notify", src, 'You cannot /kick yourself.')
    else
        local xPlayer = c.data.GetPlayer(args[1])
        xPlayer.Kick('You have been kicked.')
        TriggerClientEvent("Client:Notify", src, 'TargetID: ' .. args[1] .. ', has been kicked.')
    end
end, true)

-- ====================================================================================--

RegisterCommand('setjob', function(source, args, rawCommand)
    local src = tonumber(source)
    if c.job.Exist(args[2], args[3]) then
        local xPlayer = c.data.GetPlayer(args[1])
        xPlayer.SetJob(args[2], args[3])
        TriggerClientEvent("Client:Notify", src, 'Set ID:'..args[1]..', as Job: '..args[2]..', Grade: '..args[3]..'.')
        TriggerClientEvent("Client:Notify", args[1], 'Set ID:'..args[1]..', as Job: '..args[2]..', Grade: '..args[3]..'.')
    else
        TriggerClientEvent("Client:Notify", src, 'JobName: '..args[2]..' or JobGrade: '..args[3]..', does not exist.')
        TriggerClientEvent("Client:Notify", args[1], 'JobName: '..args[2]..' or JobGrade: '..args[3]..', does not exist.')
    end
end, true)

-- ====================================================================================--

RegisterCommand('car', function(source, args, rawCommand)
    local src = tonumber(source)
    local coords = GetEntityCoords(src)
    local ords = vector4(coords, GetEntityHeading(src))
    local retval, id = c.CreateVehicle(args[1], ords)
    TriggerClientEvent("Client:Notify", src, 'Spawned: '..retval..', NetID: '..id)
end, true)
