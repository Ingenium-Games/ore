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
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

c.aces.public = function()
    TriggerEvent("chat:addSuggestion", "/switch", "Use to change your character(s).")
end

c.aces.mod = function()
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
    TriggerEvent("chat:addSuggestion", "/ban", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
    TriggerEvent("chat:addSuggestion", "/kick", "Admin Permission(s) Required.", {{
        name = "1",
        help = "Server ID"
    }})
end

c.aces.superadmin = function() end

c.aces.developer = function() end

c.aces.owner = function() end
