
-- ====================================================================================--
-- If this is the server,,,
-- Wait until the resources are hopefully finished loading by reading the console output fot the cfx.re tebex line.
-- We may have to make a final resource to jerry rig this if not the case.
if IsDuplicityVersion() then
    RegisterConsoleListener(function(channel, string)
        if string == "Monetize your server using Tebex! Visit https://tebex.io/fivem for more info." then
            c.json.Write("Doors", c.doors)
            setmetatable(c.doors, c.meta)
            c.debug("Doors table locked")      
        end
    end)
end
-- ====================================================================================--