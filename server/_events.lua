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

-- Triggered after character has been loaded from db and informaiton is passed to client
RegisterNetEvent("Server:Character:Loaded")
AddEventHandler("Server:Character:Loaded", function()
    local src = source
    local xPlayer = c.data.GetPlayer(src)

end)

-- Triggered by the client after it has recieved its character data.
RegisterNetEvent("Server:Character:Ready")
AddEventHandler("Server:Character:Ready", function()
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    -- Remove from current ACL Job Group
    ExecuteCommand(('remove_principal identifier.%s job.%s'):format(xPlayer.GetLicense_ID(), xPlayer.GetJob().Name))
    --
    xPlayer.SetJob(xPlayer.GetJob())
    Wait(250)
    --
    TriggerEvent('Server:Character:SetJob', xPlayer.ID, xPlayer.GetJob())
    TriggerClientEvent('Client:Character:SetJob', xPlayer.ID, xPlayer.GetJob())
    --
    print(c.table.Dump(xPlayer.GetJob()))
end)

-- Use this to remove any things connected to Characters like police blips etc.
RegisterNetEvent("Server:Character:Switch")
AddEventHandler("Server:Character:Switch", function(req)
    local src = req or source
    local xPlayer = c.data.GetPlayer(src)
    -- Remove Player Identifier from job as entity if no longer existing.
    ExecuteCommand(('remove_principal identifier.%s job.%s'):format(xPlayer.License_ID, xPlayer.GetJob().Name))
    --

end)

-- Server Death Handler - if was killed by a player or not.
RegisterNetEvent("Server:Character:Death")
AddEventHandler("Server:Character:Death", function(data)
    local src = source
    if (data.PlayerKill == true) then
        c.discord(conf.deathlog)
    else
        c.discord(conf.deathlog)
    end
end)

--@ req = server_id or source
--@ t = {'name'='police','grade'=0}
RegisterNetEvent("Server:Character:SetJob")
AddEventHandler("Server:Character:SetJob", function(req, data)
    local src = req or source
    local xPlayer = c.data.GetPlayer(src)
    -- Add New Job command permissions for ACL system
    ExecuteCommand(('add_principal identifier.%s job.%s'):format(xPlayer.License_ID, xPlayer.GetJob().Name))
end)

-- Default player to instance listed in conf.defaultinstance
RegisterNetEvent('Server:Instance:Player:Default')
AddEventHandler('Server:Instance:Player:Default', function(req)
    local src = req or source
    c.inst.SetPlayerDefault(src)
end)

-- ====================================================================================--
-- The data reciever to modify the xPlayer Table

RegisterNetEvent('Server:Packet:Update')
AddEventHandler('Server:Packet:Update', function(data)
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    -- Status
    xPlayer.SetHealth(data.Health)
    xPlayer.SetArmour(data.Armour)
    xPlayer.SetHunger(data.Hunger)
    xPlayer.SetThirst(data.Thirst)
    xPlayer.SetStress(data.Stress)
    -- Status Modifiers
    xPlayer.SetModifiers(data.Modifiers)
    -- Coords
    xPlayer.SetCoords(data.Coords)    
end)

-- ====================================================================================--
-- Bank Events for Transactions

RegisterNetEvent("Server:Bank:Deposit")
AddEventHandler("Server:Bank:Deposit", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveMoney(amount)
    xPlayer.AddBank(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "Diposited $"..amount, "warn")
end)

RegisterNetEvent("Server:Bank:Withdraw")
AddEventHandler("Server:Bank:Withdraw", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveBank(amount)
    xPlayer.AddMoney(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "Withdrew $"..amount, "warn")
end)

RegisterNetEvent("Server:Bank:Transfer")
AddEventHandler("Server:Bank:Transfer", function(data, req, id)
    local src = req or source
    local too = id
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    local tPlayer = c.data.GetPlayer(too)
    --
    xPlayer.RemoveBank(amount)
    tPlayer.AddBank(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "Sent $"..amount.." to "..tPlayer.Full_Name, "warn")
    TriggerClientEvent("Client:Notify", tPlayer.ID, "Recieved $"..amount.." from "..xPlayer.Full_Name, "warn")
end)

RegisterNetEvent("Server:Bank:Remove")
AddEventHandler("Server:Bank:Remove", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.RemoveBank(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "Payed $"..amount, "warn")
end)

RegisterNetEvent("Server:Bank:Add")
AddEventHandler("Server:Bank:Add", function(data, req)
    local src = req or source
    local amount = data
    local xPlayer = c.data.GetPlayer(src)
    --
    xPlayer.AddBank(amount)
    TriggerClientEvent("Client:Notify", xPlayer.ID, "$"..amount.." was added to your account.", "warn")
end)
