-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
SetGameType(conf.gametype)
SetMapName(conf.mapname)
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    --
    OnStart(resourceName)
    --
end)
-- ====================================================================================--
function OnStart(resourceName)
    c.data.Initilize()
    --
    while c.Loading do
        Wait(25)
    end
    -- Create Channels for Instances
    c.mumble.GenerateInstanceChannels()
    -- Time now updates
    c.time.ServerSync()
    -- Players save to the DB.
    c.data.ServerSync()
    -- Start Paying players based on conf.
    c.job.PayCycle()  
    --

    -- AT THE END
    c.version.Check(conf.url.version, resourceName)
end
-- ====================================================================================--
RegisterNetEvent('Server:PlayerConnecting')
AddEventHandler('Server:PlayerConnecting', function()
    local src = tonumber(source)
    local Primary_ID = c.identifier(src)
    local Steam_ID, FiveM_ID, License_ID, Discord_ID, IP_Address = c.identifiers(src)
    local Username = GetPlayerName(src)
    --
    if License_ID then
        -- add player to index.
        c.data.AddPlayer(src)
        MySQL.Async.fetchScalar('SELECT `License_ID` FROM `users` WHERE `License_ID` = @License_ID LIMIT 1;', {
            ['@License_ID'] = License_ID
        }, function(r)
            if (r ~= nil) then
                -- Update their steam, discord if they do not exist in the db and their ip address upon every login.
                MySQL.Async.execute(
                    'UPDATE `users` SET `Username` = @Username, `Steam_ID` = IFNULL(`Steam_ID`,@Steam_ID), `FiveM_ID` = IFNULL(`FiveM_ID`,@FiveM_ID), `Discord_ID` = IFNULL(`Discord_ID`,@Discord_ID), `IP_Address` = @IP_Address WHERE `License_ID` = @License_ID;',
                    {
                        Username = Username,
                        License_ID = License_ID,
                        FiveM_ID = FiveM_ID,
                        Steam_ID = Steam_ID,
                        Discord_ID = Discord_ID,
                        IP_Address = IP_Address
                    }, function(r)
                        -- User Found and Updated, Now ...
                        TriggerClientEvent('Client:Character:OpeningMenu', src)
                        TriggerEvent('Server:Character:Request:List', src, Primary_ID)
                    end)
            else
                MySQL.Async.execute(
                    'INSERT INTO `users` (`Username`, `Steam_ID`, `License_ID`, `FiveM_ID`, `Discord_ID`, `Ace`, `Locale`, `Ban`, `IP_Address`) VALUES (@Username, @Steam_ID, @License_ID, @FiveM_ID, @Discord_ID, @Ace, @Locale, @Ban, @IP_Address);',
                    {
                        Username = Username,
                        Steam_ID = Steam_ID,
                        License_ID = License_ID,
                        FiveM_ID = FiveM_ID,
                        Discord_ID = Discord_ID,
                        Ace = conf.ace,
                        Locale = conf.locale,
                        Ban = 0,
                        IP_Address = IP_Address
                    }, function(r)
                        -- New User Created, Now ...
                        TriggerClientEvent('Client:Character:OpeningMenu', src)
                        TriggerEvent('Server:Character:Request:List', src, Primary_ID)
                    end)
            end
        end)
    else
        DropPlayer(src, 'You are missing your license identifier, this is odd, make sure you have signed into FiveM and restart your client..')
    end
end)

-- ====================================================================================--

AddEventHandler('playerDropped', function()
    local src = tonumber(source)
    local xPlayer = c.data.GetPlayer(src)
    -- if the data not false?
    if xPlayer then
        -- Remove Job Permissions
        ExecuteCommand(('remove_principal identifier.%s job.%s'):format(xPlayer.License_ID, xPlayer.GetJob().Name))
        -- Save Data
        c.sql.SaveUser(xPlayer, function()
            c.sql.SetCharacterInActive(xPlayer.Character_ID, function()
                c.debug("[E] 'playerDropped' : Player Disconnection.")
                c.data.RemovePlayer(src)
            end)
        end)
    end
end)