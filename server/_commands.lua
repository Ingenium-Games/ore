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

RegisterCommand('test', function(source)

end, false)

-- ====================================================================================--

TriggerEvent("chat:addSuggestion", "/switch", "Use to change your character(s).", {})

RegisterCommand('switch', function(source)
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

TriggerEvent("chat:addSuggestion", "/ban", "Admin Permission(s) Required.", {{
    name = "TargetID",
    help = "The Target's server ID in this session."
}})

RegisterCommand('ban', function(source, ...)
    local src = tonumber(source)
    local args = {...}
    if (type(args[1]) ~= 'number') then
        TriggerClientEvent("Client:Notify", src, 'Invalid Number Used for /ban Command.')
    else
        if (args[1] == src) then
            TriggerClientEvent("Client:Notify", src, 'You cannot /ban yourself.')
        else
            local Primary_ID = c.identifier(args[1])
            local xPlayer = c.data.GetPlayer(args[1])
            c.sql.SetBanned(Primary_ID, function()
                xPlayer.Kick('You have been banned.')
                TriggerClientEvent("Client:Notify", src, 'TargetID: ' .. args[1] .. ', has been banned.')
            end)
        end
    end
end, true)

-- ====================================================================================--

TriggerEvent("chat:addSuggestion", "/kick", "Admin Permission(s) Required.", {{
    name = "TargetID",
    help = "The Target's server ID in this session."
}})

RegisterCommand('kick', function(source, ...)
    local src = tonumber(source)
    local args = {...}
    if (type(args[1]) ~= 'number') then
        TriggerClientEvent("Client:Notify", src, 'Invalid Number Used for /kick Command.')
    else
        if (args[1] == src) then
            TriggerClientEvent("Client:Notify", src, 'You cannot /kick yourself.')
        else
            local xPlayer = c.data.GetPlayer(args[1])
            xPlayer.Kick('You have been kicked.')
            TriggerClientEvent("Client:Notify", src, 'TargetID: ' .. args[1] .. ', has been kicked.')
        end
    end
end, true)

-- ====================================================================================--

TriggerEvent("chat:addSuggestion", "/setjob", "Admin Permission(s) Required.", {{
    name = "TargetID",
    jobname = "JobName",
    jobgrade = "JobGrade",
    help = "Server ID [1], Job Name [2], Job Grade [3] : Use a Space between each variable. Expecting 3 Variables"
}})

RegisterCommand('setjob', function(source, ...)
    local src = tonumber(source)
    local args = {...}
    if (type(args[1]) ~= 'number') then
        TriggerClientEvent("Client:Notify", src, 'Invalid Server ID :'..args[1]..', Used for /setjob command.')
    else
        if c.job.Exist(args[2], args[3]) then
            local xPlayer = c.data.GetPlayer(args[1])
            xPlayer.SetJob(args[2], args[3])
            TriggerClientEvent("Client:Notify", src, 'ID:'..args[1]..', JobName: '..args[2]..', JobGrade: '..args[3]..'.)
        else
            TriggerClientEvent("Client:Notify", src, 'JobName: '..args[2]..' or JobGrade: '..args[3]..', does not exist.)
        end
    end    
end, true)


