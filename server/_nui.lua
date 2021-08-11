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
--  Get Character Info for the NUI to allow character selection.
RegisterNetEvent('Server:Character:Request:List')
AddEventHandler('Server:Character:Request:List', function(req, Primary_ID)
    local src = tonumber(req) or source
    local Characters = c.sql.GetCharacters(Primary_ID)
    local Command = "OnJoin"
    -- Send the data table to the client that requested it...
    TriggerClientEvent('Client:Character:Open', src, Command, Characters)
    -- Place the user in their own instance until the user has joined and loaded.
    c.inst.SetPlayer(src, c.inst.New(), true)
end)

RegisterNetEvent('Server:Character:Request:Join')
AddEventHandler('Server:Character:Request:Join', function(Character_ID)
    local src = tonumber(source)
    -- If the User selected the NEW button on the NUI, the Character_ID will be listed as NEW, if this is the case, trigger the registration NUI?
    if (Character_ID == 'New') then
        local message = "OnNew"
        TriggerClientEvent('Client:Character:Open', src, message)
    elseif Character_ID ~= nil then
        local Coords = c.sql.GetCharacterCoords(Character_ID)
        c.data.LoadPlayer(src, Character_ID)
        TriggerClientEvent('Client:Character:ReSpawn', src, Character_ID, Coords)
    elseif Character_ID == nil then
        local message = "OnNew"
        TriggerClientEvent('Client:Character:Open', src, message)
    end
end)

RegisterNetEvent('Server:Character:Request:Delete')
AddEventHandler('Server:Character:Request:Delete', function(Character_ID)
    local src = tonumber(source)
    local prim = c.identifier(src)
    c.sql.DeleteCharacter(Character_ID, function()
        TriggerEvent('Server:Character:Request:List', src, prim)
    end)
end)


-- Need to move this and clean it the fuck up, its gross atm.
RegisterNetEvent('Server:Character:Request:Create')
AddEventHandler('Server:Character:Request:Create', function(first_name, last_name, height, date)
    local src = tonumber(source)
    local char = c.sql.GenerateCharacterID()
    local city = c.sql.GenerateCityID()
    local phone = c.sql.GeneratePhoneNumber()
    local banknum = c.sql.GenerateAccountNumber()
    local prim = c.identifier(src)
    local data = {
        Primary_ID = prim, -- Owner
        Character_ID = char, -- Unique ID
        First_Name = first_name,
        Last_Name = last_name,
        Height = height,
        Birth_Date = date,
        City_ID = city,
        Phone = phone,
        Coords = json.encode(conf.spawn),
        Accounts = json.encode(conf.default.accounts),
        Modifiers = json.encode(conf.default.modifiers),
    }
    c.sql.CreateCharacter(data, function()
        -- CHain other required actions upon the initial data being added, like other tables that use forigen keys etc.
        c.sql.CreateLoanAccount(char, banknum)
        
    end)
    c.data.LoadPlayer(src, char)
    TriggerClientEvent('Client:Character:FirstSpawn', src)
    ---
    ---
    ---
    ---
    TriggerClientEvent('creator:OpenCreator', src)
    Wait(500)
    c.inst.SetPlayer(src, c.inst.New())
end)
