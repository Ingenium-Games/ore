-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Reasoning behind duplicating it as a state and class table.
    - Just incase it goes arse up and state bags become fucked.
    - Preemuch the reason. So, Why rely on one, when you can have two?
    - FUka you.

    Shallow limitations
State getters and setters are naive: 
every get will return the full serialized state from the game, 
and only a direct set operation will serialize the entire state back into the game.

fuck my life, seeya later self code.
    local entState = Entity(veh).state
    entState:set('owner', GetPlayerName(source), false)
    entState:set('fishedSpawning', false, true)
    
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

function c.class.UnownedVehicle(net, bool)
    local stolen = c.check.Boolean(bool) 
    local fuel = math.random(45, 100)
    --
    local self = {}
    self.Entity = net
    self.State = Entity(self.Entity).state
    --
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end

    -- Plate
    self.Plate = GetVehicleNumberPlateText(self.Entity)
    self.State:set('Plate', self.Plate)
    --
    self.GetPlate = function()
        return self.State.Plate or self.Plate
    end

    -- Fuel
    self.Fuel = fuel
    self.State:set('Fuel', self.Fuel)
    --
    self.GetFuel = function()
        return self.State.Fuel or self.Fuel
    end
    --
    self.SetFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.State:set('Fuel', num)
        self.Fuel = num
    end
    --
    self.AddFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.SetFuel((self.GetFuel() + num))
        self.Fuel = self.GetFuel()
        if self.GetFuel() >= 100 then
            self.SetFuel(100)
            self.Fuel = 100
        end
    end
    --
    self.RemoveFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.SetFuel((self.GetFuel() - num))
        self.Fuel = self.GetFuel()
        if self.GetFuel() <= 0 then
            self.SetFuel(0)
            self.Fuel = 0
        end
    end

    -- Coords
    self.GetCoords = function()
        local x, y, z = GetEntityCoords(self.Entity)
        local h = GetEntityHeading(self.Entity)
        local Coords = {
            ['x'] = c.math.Decimals(x, 2),
            ['y'] = c.math.Decimals(y, 2),
            ['z'] = c.math.Decimals(z, 2),
            ['h'] = c.math.Decimals(h, 2)
        }
        return Coords
    end
    --
    self.SetCoords = function(coords)
        SetEntityHeading(self.Entity, coords.h)
        SetEntityCoords(self.Entity, coords.x, coords.y, coords.z, false)
    end


    -- Inventory
    self.Inventory = {}
    self.State:set('Inventory', self.Inventory)
    --
    self.GetInventory = function()
        return self.State.Inventory or self.Inventory
    end
    --
    self.SetInventory = function(t)
        self.Inventory = t
        self.State:set('Inventory', self.Inventory)
    end

    -- Keys
    self.Keys = {}
    self.State:set('Keys', self.Keys)
    --
    self.GetKeys = function()
        return self.State.Keys or self.Keys
    end
    --
    self.SetKeys = function(t)
        self.Keys = t
        self.State:set('Keys', self.Keys)
    end
    --
    self.AddKey = function(id)
        local t = self.GetKeys()
        if not self.CheckKey(id) then
            table.insert(self.Keys, id)
            self.State:set('Keys', self.Keys)
        else
            c.debug('User: ' .. id .. ' Already has key to this vehicle.')
        end
    end
    --
    self.RemoveKey = function(id)
        local t = self.GetKeys()
        if self.CheckKey(id) then
            table.remove(self.Keys, id)
            self.State:set('Keys', self.Keys)
        else
            c.debug('User: ' .. id .. ' Never had a key to this vehicle.')
        end
    end
    --
    self.CheckKey = function(id)
        local t = self.GetKeys()
        if t[id] then
            return true
        else
            return false
        end
    end

    -- Condition
    self.Conditions = c.TriggerClientCallback("GetVehicleConditions", self.GetSource(), self.Entity)
    self.State:set('Conditions', self.Conditions)
    --
    self.GetConditions = function()
        return self.State.Conditions or self.Conditions
    end
    --
    self.SetConditions = function(conditions)
        self.Conditions = conditions
        self.State:set('Conditions', self.Conditions)
        c.TriggerClientCallback("SetVehicleConditions", self.GetSource(), self.Entity)
    end
    --
    self.AlterCondition = function(id, v)
        if self.CheckConds(id) then
            self.Conditions[id] = v
            self.State:set('Conditions', self.Conditions)
        end
    end
    --
    self.CheckConds = function(id)
        local t = self.GetConditions()
        if t[id] then
            return true
        else
            return false
        end
    end


    -- Modifications
    self.Modifications = c.TriggerClientCallback("GetVehicleModifications", self.GetSource(), self.Entity)
    self.State:set('Modifications', self.Conditions)
    --
    self.GetModifications = function()
        return self.State.Modifications or self.Modifications
    end
    --
    self.SetModifications = function(modifications)
        self.Modifications = modifications
        self.State:set('Modifications', self.Modifications)
        c.TriggerClientCallback("SetVehicleModifications", self.GetSource(), self.Entity)
    end
    --
    self.AlterModification = function(id, v)
        if self.CheckMods(id) then
            self.Modifications[id] = v
            self.State:set('Modifications', self.Modifications)
        end
    end
    --
    self.CheckMods = function(id)
        local t = self.GetModifications()
        if t[id] then
            return true
        else
            return false
        end
    end
    --

    -- Owner
    self.Owner = false
    self.State:set('Owner', false)
    --
    self.GetOwner = function()
        return self.State.Owner or self.Owner
    end
    --

    -- Wanted
    self.Wanted = stolen
    self.State:set('Wanted',  stolen)
    --
    self.GetWanted = function()
        return self.State.Wanted or self.Wanted
    end
    --

    return self
end

-- ====================================================================================--

function c.class.OwnedVehicle(net, plate)
    local data = c.sql.GetVehicleByPlate(plate)
    local self = {}
    --
    self.Entity = tonumber(net)
    --
    self.SetState = function(k, v)
        if type(k) ~= 'string' then
            k = tostring(k)
        end
        Entity(self.Entity).state[k] = v
    end
    --
    self.GetState = function(k)
        if type(k) ~= 'string' then
            k = tostring(k)
        end
        return Entity(self.Entity).state[k]
    end
    --
    self.Owner = data.Character_ID
    self.SetState('Owner', self.Owner)
    self.Model = data.Model
    self.SetState('Model', self.Model)
    self.Plate = data.Plate
    self.SetState('Plate', self.Plate)
    self.Coords = json.decode(data.Coords)
    self.SetState('Coords', self.Coords)
    self.Keys = json.decode(data.Keys)
    self.SetState('Keys', self.Keys)
    self.Condition = json.decode(data.Condition)
    self.SetState('Condition', self.Condition)
    self.Inventory = json.decode(data.Inventory)
    self.SetState('Inventory', self.Inventory)
    self.Modifications = json.decode(data.Modifications)
    self.SetState('Modifications', self.Modifications)
    self.Instance = data.Instance
    self.SetState('Instance', self.Instance)
    self.Garage = data.Garage
    self.SetState('Garage', self.Garage)
    self.State = data.State
    self.SetState('State', self.State)
    self.Impound = data.Impound
    self.SetState('Impound', self.Impound)
    self.Wanted = data.Wanted
    self.SetState('Wanted', self.Wanted)
    -- Funcitons
    self.GetModifications = function()
        return self.Modifications
    end
    --
    self.SetModification = function(k, v)
        self.Modifications[k] = v
    end
    --
    self.SetModifications = function(t)
        self.Modifications = t
    end
    --
    self.GetCoords = function()
        local x, y, z = GetEntityCoords(self.Entity)
        local h = GetEntityHeading(self.Entity)
        return x, y, z, h
    end
    --
    self.SetCoords = function()
        local x, y, z, h = self.GetCoords()
        self.Coords = {
            ['x'] = c.math.Decimals(x, 2),
            ['y'] = c.math.Decimals(y, 2),
            ['z'] = c.math.Decimals(z, 2),
            ['h'] = c.math.Decimals(h, 2)
        }
        self.SetState('Coords', self.Coords)
    end
    --
    self.GetKeys = function()
        return self.Keys
    end
    --
    self.SetKeys = function(t)
        self.Keys = t
        self.SetState('Keys', self.Keys)
    end
    --
    self.AddKey = function(id)
        if not self.Keys[id] then
            table.insert(self.Keys, id)
            self.SetState('Key', self.Keys)
        else
            c.debug('User: ' .. id .. ' Already has key to this vehicle.')
        end
    end
    --
    self.RemoveKey = function(id)
        if self.Keys[id] then
            table.remove(self.Keys, id)
            self.SetState('Key', self.Keys)
        else
            c.debug('User: ' .. id .. ' Never had a key to this vehicle.')
        end
    end
    --
    self.CheckKey = function(id)
        if self.Keys[id] then
            return true
        else
            return false
        end
    end
    --
    self.GetCondition = function()
        if not self.Condition or type(self.Condition) ~= 'table' then
            local ConDirt = GetVehicleDirtLevel(self.Entity)
            local ConEng = GetVehicleEngineHealth(self.Entity)
            local ConBod = GetVehicleBodyHealth(self.Entity)
            local ConFuel = GetVehiclePetrolTankHealth(self.Entity)
            local Con = {
                ['ConDirt'] = ConDirt,
                ['ConEng'] = ConEng,
                ['ConBod'] = ConBod,
                ['ConFuel'] = ConFuel
            }
            return Con
        else
            return self.Condition
        end
    end
    --
    self.SetCondition = function(Con)
        self.Condition = Con
        self.SetState('Condition', self.Condition)
    end
    --

    --
    self.Fuel = self.Modifications.Fuel
    --
    self.GetFuel = function()
        return self.Fuel or self.GetState('Fuel')
    end
    --
    self.AddFuel = function(num)
        local num = c.check.Number(num, 0, 100)
        self.Fuel = (self.Fuel + num)
        self.SetState('Fuel', self.Fuel)
        if self.Fuel >= 100 then
            self.Fuel = 100
            self.SetState('Fuel', 100)
        end
    end
    --
    self.RemoveFuel = function(num)
        local num = c.check.Number(num, 0, 100)
        self.Fuel = (self.Fuel - num)
        self.SetState('Fuel', self.Fuel)
        if self.Fuel <= 0 then
            self.Fuel = 0
            self.SetState('Fuel', 0)
        end
    end
    --
    self.SetFuel = function(num)
        local num = c.check.Number(num, 0, 100)
        self.Fuel = num
        self.SetState('Fuel', num)
    end
    --
    self.GetOwner = function()
        return self.Owner
    end
    --
    return self
end
