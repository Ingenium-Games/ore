-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--	
local version = c.module.GetVersion()
local OnlineVersion = nil

PerformHttpRequest("https://github.com/Ingenium-Games/ore/version.txt", function(err, text, headers)
    Citizen.Wait(1250)
    OnlineVersion = json.decode(text)
    --
    c.debug(" ^0[ ^8Update Checking^0 ] ")
    if (OnlineVersion.version ~= version) then
        print("Wrong Version Installed.")
    else
        print(version.. " == " ..OnlineVersion.version)
    end
end, "GET")
