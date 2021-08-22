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
    
function c.data.CleanDataFiles()
    -- We should probably stagger these to prevent multiple files opena and writing.
    c.gsr.CleanUp()
    Citizen.Wait(c.min)
    --
    c.drop.CleanUp()
    Citizen.Wait(c.min)
    --
    c.pick.CleanUp()
    Citizen.Wait(c.min)
    --
    c.note.CleanUp()
    Citizen.Wait(c.min)
    --
end