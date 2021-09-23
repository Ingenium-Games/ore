-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.ace = {"public","mod","admin","superadmin","developer","owner"}
c.aces = {}
--[[
NOTES
    This is used to loop the lists of chat suggestions based on player loading in and the client receiving the infromation they need.
    this is client sided, so if they wanted too they COULD look at this, but really this is only an attempt at limiting the displayed 
    commands in chat to reduce clutter.

    And there is no client side way of getting it and its low priotiry, so I could define a number then using the number minue 1 till 0
        too provide permissions per list, in the mean time, ill pul the ace passed to the client and load them as a single one off.

        fuk it
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

c.aces.public = function()
    -- public
    TriggerEvent("chat:addSuggestion", "/switch", "Use to change your character(s).")
end

c.aces.mod = function()
    -- public
    c.aces.public()

    -- mod

    TriggerEvent("chat:addSuggestion", "/setjob", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }, {
        name = "2",
        help = "Job Name"
    }, {
        name = "3",
        help = "Job Grade"
    }})
    
end

c.aces.admin = function()
    -- mod
    c.aces.mod()

    -- admin

    TriggerEvent("chat:addSuggestion", "/ban", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})

    TriggerEvent("chat:addSuggestion", "/kick", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
end

c.aces.superadmin = function()   
    -- admin
    c.aces.admin()

end

c.aces.developer = function()     
    -- admin
    c.aces.superadmin()
    
end

c.aces.owner = function()     
    -- admin
    c.aces.owner()
    

end