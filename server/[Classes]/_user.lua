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

function c.class.CreateUser(req)
    c.debug('Start User Class Creation')
    local src = tonumber(req)
    local Steam_ID, FiveM_ID, License_ID, Discord_ID, IP_Address = c.identifiers(src)
    local Ace = c.sql.GetAce(License_ID)
    local Locale = c.sql.GetLocale(License_ID)
    local self = {}
    --
    self.ID = src
    self.Name = GetPlayerName(src)
    self.Steam_ID = Steam_ID
    self.FiveM_ID = FiveM_ID
    self.License_ID = License_ID
    self.Discord_ID = Discord_ID
    self.IP_Address = IP_Address
    self.Ace = Ace
    self.Locale = Locale
    self.Temp = c.rng.chars(15)
    --
    ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.License_ID, self.Ace))
    ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.License_ID, self.Ace))
    --
    self.Kick = function(reason)
        DropPlayer(self.src, reason)
    end
    --
    self.GetName = function()
        return self.Name
    end
    --
    self.GetAce = function()
        return self.Ace
    end
    --
    self.GetLocale = function()
        return self.Locale
    end
    --
    self.GetID = function()
        return self.ID
    end
    --
    self.GetSteam_ID = function()
        return self.Steam_ID
    end
    --
    self.GetFiveM_ID = function()
        return self.FiveM_ID
    end
    --
    self.GetLicense_ID = function()
        return self.License_ID
    end
    --
    self.GetDiscord_ID = function()
        return self.Discord_ID
    end
    --
    self.GetIP_Address = function()
        return self.IP_Address
    end
    --
    c.debug('End User Class Creation')
    return self
end
