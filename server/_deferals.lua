-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    deferrals.defer()
    local src = source
    local playerName = GetPlayerName(src)
    local id = c.identifier(src)
    local ban = c.sql.GetBanStatus(id)
    Citizen.Wait(25)
    deferrals.update("Checking User...")
    -- If you have/use discordperms..
    if not ban then
        if conf.discordperms then
            -- Force character names to not contain speical characters.
            if conf.forcename then
                Citizen.Wait(25)
                deferrals.update("Checking name matches approved characters...")
                if (playerName:match("%W")) then
                    Citizen.Wait(25)
                    deferrals.done("You have not joined due to your name having special characters within it. Please remove any special characters prior to rejoining.")
                end
            end
            Citizen.Wait(25)
            deferrals.update("Checking if you're in our Discord...")
            exports["discordroles"]:isRolePresent(src, conf.discordrole, function(hasRole, roles)
                if hasRole then
                    Citizen.Wait(25)
                    deferrals.done()
                else
                    Citizen.Wait(25)
                    deferrals.done("You must be a member within our discord to join our game servers. Please visit https://www.ingenium.games to find our discord link there.")
                end
            end)
        else
            if conf.forcename then
                Citizen.Wait(25)
                deferrals.update("Checking name matches approved characters...")
                if (playerName:match("%W")) then
                    Citizen.Wait(25)
                    deferrals.done("You have not joined due to your name having special characters within it. Please remove any special characters prior to rejoining.")
                end
            else
                Citizen.Wait(25)
                deferrals.done()
            end
        end
    else
        Citizen.Wait(25)
        deferrals.done("This is triggered when you are banned, please contact the server administrators.")
    end
end)
