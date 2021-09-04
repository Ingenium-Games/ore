-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
if not c.sql then c.sql = {} end
--[[
NOTES.
    - All sql querys should have a call back as a function at the end to chain code execution upon completion.
    - All data should be encoded or decoded here, if possible. the fetchALL commands are decoded in the _data.lua
]] --
math.randomseed(c.Seed)
-- ====================================================================================--


function c.sql.GetVehiclesByCharacter(Character_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM vehicles WHERE `Character_ID` = @Character_ID;', {
        ['@Character_ID'] = Character_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end


function c.sql.GetVehicleByPlate(Plate, cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar('SELECT * FROM vehicles WHERE `Plate` = @Plate LIMIT 1;', {
        ['@Plate'] = Plate
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
    return result
end
