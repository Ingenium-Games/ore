-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.data = {} -- data table for funcitons.
c.pdex = {} -- player index = pdex (source numbers assigned by the server upon connection order)
--[[
NOTES.
    -
    -
    -
]]--

math.randomseed(c.Seed)
-- ====================================================================================--

--- Used on startup prior to the server really running.
function c.data.Initilize()
    c.debug('Loading Sequence Begin.')
    local num, loaded = 0, false
    local t = {
        [1] = 'DB: Characters marked as In-Active;',
        [2] = 'DB: Jobs have been Generated;',
        [3] = 'DB: Finding Job Accounts or Creating them;',
        [4] = 'DB: Job Accounts have been Generated;',
        [5] = 'DB: Job Objects Created and Added;',
        [6] = 'DB: Vehicles;'
    }
    --
    local function cb()
        num = num + 1
        c.debug(t[num])
    end
    --
    MySQL.ready(function()
        -- Add other SQL commands required on start up.
        -- such as cleaning tables, requesting data, etc..
        -- [1]
        c.sql.ResetActiveCharacters(cb)
        -- [2]
        c.sql.GrabJobs(cb)
        -- [3]
        c.sql.SetupJobs(cb)
        -- [4]
        c.sql.GrabJobAccounts(cb)
        -- [5] -- Not so much a SQL function, but dependant on it being conducted in order.
        c.data.CreateJobObjects()
        cb()
        --
        loaded = true
    end)

    while not loaded do
        Wait(250)
    end
    
    c.Loading = false
    c.debug('Loading Sequence Complete.')
    c.Running = true
    
    -- Testing Table builds from SQL builds.
    -- print(c.table.Dump(c.jobs))

end

-- ====================================================================================--

--- Adds player to the player index.
---@param source number "source [server_id]"
function c.data.AddPlayer(source)
    table.insert(c.pdex, tonumber(source))
end


--- Gets player from the player table.
---@param source number
function c.data.GetPlayer(source)
    if type(c.pdex[tonumber(source)]) == 'table' then
        return c.pdex[tonumber(source)]
    else
        return false
    end
end

--- Same as above.
---@param source number
function c.GetPlayer(source)
    return c.data.GetPlayer(source)
end

--- Same as above.
---@param source number
function c.GetPlayerFromId(source)
	return c.data.GetPlayer(source)
end

--- Set the player id to the table.
---@param source number
---@param data table
function c.data.SetPlayer(source, data)
    c.pdex[source] = data
end

--- Set to false.
---@param source number
function c.data.RemovePlayer(source)
    c.pdex[source] = false
end

--- Get the player table
function c.data.GetPlayers()
    return c.pdex
end

--- Wrapper for the above.
function c.GetPlayers()
    return c.data.GetPlayers()
end

--- Return corresponding player data from character_id
---@param id string "Character_ID"
function c.data.GetPlayerByIdentifier(id)
    for k,v in pairs(c.pdex) do
        if v then
            if v.Character_ID == id then
                return c.GetPlayer(k)
            end
        end
    end
    return nil
end

--- Wrapper for the above.
function c.GetPlayerFromIdentifier(id)
    return c.data.GetPlayerByIdentifier(id)
end

-- ====================================================================================--
-- Vehicles - c.vehicles = Object Table with xVehicle as referance obj, c.vehicle = function table

--- Get the xVehicle Data/Table
---@param plate string "Return the xVehicle table of data/functions"
function c.data.GetVehicle(plate)
    return c.vehicles[plate]
end

--- Same as above.
---@param plate string
function c.GetVehicle(plate)
    return c.data.GetVehicle(plate)
end

--- Set the plates data.
---@param plate string
---@param data table
function c.data.SetVehicle(plate, data)
    c.vehicles[plate] = data
end

--- Set the plate to no data.
---@param plate string
function c.data.RemoveVehicle(plate)
    c.vehicles[plate] = false
end

--- Get all xVehicles
function c.data.GetVehicles()
    return c.vehicles
end

--- Get all xVehicles
function c.GetVehicles()
    return c.data.GetVehicles()
end

-- ====================================================================================--
-- Jobs - c.jdex = Object table, c.jobs = table built from the DB, c.job = functions.

 --- func desc
function c.data.CreateJobObjects()
    local jobs = c.job.GetJobs()
    for k,v in pairs(jobs) do
        if not c.jdex[k] then
            c.jdex[k] = c.class.CreateJob(v)
        end
    end
    c.json.Write("jobs", c.jobs)
    -- Lock the Jobs after DV Pull.
    setmetatable(c.jobs,c.meta)
    setmetatable(c.jdex,c.meta)
end

function c.data.GetJobs()
    return c.jdex
end

function c.data.GetJob(str)
    return c.jdex[str]
end

function c.GetJob(str)
    return c.data.GetJob(str)
end

-- ====================================================================================--

function c.data.Save(str)
    print("   ^7[^5Saved^7]:  ==    ", str)
end

-- Server to DB routine.
function c.data.ServerSync()
    local function Do()
        c.sql.SaveUsers(function() 
            -- do 
        end)
        Citizen.Wait(350)
        c.sql.SaveVehicles(function() 
            -- do 
        end)
        Citizen.Wait(350)
        c.sql.SaveJobs(function() 
            -- do 
        end)
        Citizen.Wait(350)
        c.debug('[F] ServerSync()')
        c.data.Save(" Users, Vehicles, Jobs, ")
        SetTimeout(conf.serversync, Do)
    end
    SetTimeout(conf.serversync, Do)
end

-- ====================================================================================--

--- Create xPlayer table and pass to client.
---@param source number
---@param Character_ID string
function c.data.LoadPlayer(source, Character_ID)
    local src = tonumber(source)
    -- Fuck Metatable inheritance.
    local xUser = c.class.CreateUser(src)
    local xCharacter = c.class.CreateCharacter(Character_ID)
    local xPlayer = c.table.Merge(xUser, xCharacter)
    local data = {}
    -- what data needs to be sent to the client?
    data.ID = xPlayer.GetID()
    data.Character_ID = xPlayer.GetCharacter_ID()
    data.City_ID = xPlayer.GetCity_ID()
    data.Full_Name = xPlayer.GetFull_Name()
    data.Phone = xPlayer.GetPhone()
    data.Health = xPlayer.GetHealth()
    data.Armour = xPlayer.GetArmour()
    data.Hunger = xPlayer.GetHunger()
    data.Thirst = xPlayer.GetThirst()
    data.Stress = xPlayer.GetStress()
    data.Modifiers = xPlayer.GetModifiers()
    data.Appearance = xPlayer.GetAppearance()
    --
    c.sql.SetCharacterActive(Character_ID, function()
        c.data.SetPlayer(src, xPlayer)
        c.inst.SetPlayer(source, xPlayer.GetInstance())
        TriggerClientEvent('Client:Character:Loaded', src, data)
    end)
end
