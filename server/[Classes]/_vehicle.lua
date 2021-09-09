-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Reasoning behind duplicating it as a state and class table.
    - Just incase it goes arse up and state bags become fucked.
    - Preemuch the reason. So, Why rely on one, when you can have two?
    - FUka you.
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

function c.class.VehicleClass(entity, plate)
    local self = {}
    self.Entity = entity
    --
    EnsureEntityStateBag(self.Entity)
    --
    self.SetState = function(k,v)
        if type(k) ~= 'string' then k = tostring(k) end
        Entity(self.Entity).state[k] = v
    end
    --
    self.GetState = function(k)
        if type(k) ~= 'string' then k = tostring(k) end
        return Entity(self.Entity).state[k]
    end

----------------------------------------------------------------------
-- START SEPERATION OF TYPE FOR CLASS, IS IT OWNEND BY THE DB OR NOT!.
----------------------------------------------------------------------

    -- If is not owned by a player on creation, do...
    if not plate then
        -- Declare
        local fuel = math.random(45,100)
        self.SetState('Plate', GetVehicleNumberPlateText(self.Entity))
        self.SetState('Coords', GetEntityCoords(self.Entity))
        self.SetState('Keys', {})
        self.SetState('Fuel', fuel)
        self.SetState('Model', GetEntityModel(self.Entity))
        self.SetState('Modifications', {})
        self.SetState('Condition', {})
        self.SetState('Inventory', {})
        self.SetState('Wanted', true)
        self.SetState('Instance', 0)
        -- Functions
        self.GetFuel = function()
            return self.GetState('Fuel')
        end
        --
        self.SetFuel = function(v)
            self.SetState('Fuel', v)
        end
        --
        self.AddFuel = function(num)
            local num = c.check.Number(num, 0, 100)
            self.SetFuel((self.GetFuel() + num))
            if self.GetFuel() >= 100 then
                self.SetFuel(100)
            end
        end
        --
        self.RemoveFuel = function(num)
            local num = c.check.Number(num, 0, 100)
            self.SetFuel((self.GetFuel() - num))
            if self.GetFuel() <= 0 then
                self.SetFuel(0)
            end
        end
        --
        self.GetCoords = function()
            local x,y,z = GetEntityCoords(self.Entity)
            local h = GetEntityHeading(self.Entity)
            return x,y,z,h
        end
        --
        self.SetCoords = function()
            local x,y,z,h = self.GetCoords()
            local Coords = {
                ['x'] = c.math.Decimals(x,2),
                ['y'] = c.math.Decimals(y,2),
                ['z'] = c.math.Decimals(z,2),
                ['h'] = c.math.Decimals(h,2)
            }
            self.SetState('Coords', Coords)
        end
        --
        self.GetInventory = function()
            return self.GetState('Inventory')
        end
        -- Rather than do individual transactions, better to let the inventory functions (soontm) deal with all that.
        self.SetInventory = function(t)
            self.SetState('Inventory', t)
        end
        --
        self.GetKeys = function()
            return self.GetState('Keys')
        end
        --
        self.SetKeys = function(t)
            self.SetState('Keys', t)
        end
        --
        self.AddKey = function(id)
            local t = self.GetState('Keys')
            if not t[id] then
                table.insert(t,id)
                self.SetState('Keys', t)
            else
                c.debug('User: '..id..' Already has key to this vehicle.')
            end
        end
        --
        self.RemoveKey = function(id)
            local t = self.GetState('Keys')
            if t[id] then
                table.remove(t,id)
                self.SetState('Keys', t)
            else
                c.debug('User: '..id..' Never had a key to this vehicle.')    
            end
        end
        --
        self.CheckKey = function(id)
            local t = self.GetState('Keys')
            if t[id] then
                return true
            else
                return false
            end
        end
        -- Reminder, clients to set need to use Entity(ent).state:Set('Condition', {TABLE OF ALL STUFFS}, TRUE) << to replicate to the server
        self.GetCondition = function()
            local ConDirt = GetVehicleDirtLevel(self.Entity)
            local ConEng = GetVehicleEngineHealth(self.Entity)
            local ConBod = GetVehicleBodyHealth(self.Entity)
            local ConFuel = GetVehiclePetrolTankHealth(self.Entity)
            local Con = {
                ['ConDirt'] = ConDirt,
                ['ConEng'] = ConEng,
                ['ConBod'] = ConBod,
                ['ConFuel'] = ConFuel,
            }
            self.SetCondition('Condition', Con)
            return self.GetState('Condition')
        end
        --
        self.SetCondition = function(t)
            self.SetState('Condition', t)
        end
        --

-------------------------------------------------------------------------
-- To recap, what we are doing, is duplicating the functions to be identical,
-- that if a owned or unowned vehicle is queryed by another script it will
-- still provide similar or the same informaiton to what is calling it.
-------------------------------------------------------------------------        

    -- If it IS owned by a player, DO...
    elseif type(plate) == "string" then
        local data = c.sql.GetVehicleByPlate(plate)
        -- Declare
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
        self.SetModification = function(k,v)
            self.Modifications[k] = v
        end
        --
        self.SetModifications = function(t)
            self.Modifications = t
        end
        --
        self.GetCoords = function()
            local x,y,z = GetEntityCoords(self.Entity)
            local h = GetEntityHeading(self.Entity)
            return x,y,z,h
        end
        --
        self.SetCoords = function()
            local x,y,z,h = self.GetCoords()
            self.Coords = {
                ['x'] = c.math.Decimals(x,2),
                ['y'] = c.math.Decimals(y,2),
                ['z'] = c.math.Decimals(z,2),
                ['h'] = c.math.Decimals(h,2)
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
                c.debug('User: '..id..' Already has key to this vehicle.')
            end
        end
        --
        self.RemoveKey = function(id)
            if self.Keys[id] then
                table.remove(self.Keys, id)
                self.SetState('Key', self.Keys)
            else
                c.debug('User: '..id..' Never had a key to this vehicle.')    
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
                    ['ConFuel'] = ConFuel,
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
        
    else
        c.debug("Unable to create vehicle class, ")
    end




    return self
end
