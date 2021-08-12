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

function c.class.CreateCharacter(character_id)
    c.debug("Start Character Class Creation")
    local data = c.sql.GetCharacter(character_id)
    local self = {}
    -- Strings
    self.Character_ID = data.Character_ID -- 50 Random Characters [Aa-Zz][0-9]
    self.City_ID = data.City_ID -- X-00000

    self.Birth_Date = data.Birth_Date
    self.First_Name = data.First_Name
    self.Last_Name = data.Last_Name
    self.Full_Name = data.First_Name .. " " .. data.Last_Name

    self.Phone = data.Phone -- 200000 - 699999
    
    -- Integers
    self.Instance = data.Instance
    self.Health = data.Health
    self.Armour = data.Armour
    self.Hunger = data.Hunger
    self.Thirst = data.Thirst
    self.Stress = data.Stress

    -- Booleans
    self.Wanted = data.Wanted
    self.Supporter = data.Supporter
    
    -- Tables (JSONIZE)
    self.Job = json.decode(data.Job)
    self.Coords = json.decode(data.Coords)
    self.Accounts = json.decode(data.Accounts)
    self.Licenses = json.decode(data.Licenses)
    self.Inventory = json.decode(data.Inventory)
    self.Modifiers = json.decode(data.Modifiers)    
    self.Appearance = json.decode(data.Appearance)
    
    ---- FUNCTIONS
    -- This one is to check if they are a VIP/Supporter of the server, ie tebex linked.
    self.IsSupporter = function()
        return self.Supporter
    end
    --
    self.GetIdentifier = function()
        return self.Character_ID
    end
    --
    self.GetCharacter_ID = function()
        return self.Character_ID
    end
    --
    self.GetCity_ID = function()
        return self.City_ID
    end
    --
    self.GetBirth_Date = function()
        return self.Birth_Date
    end
    --
    self.GetFirst_Name = function()
        return self.First_Name
    end
    --
    self.GetLast_Name = function()
        return self.Last_Name
    end
    --
    self.GetFull_Name = function()
        return self.Full_Name
    end
    --
    self.Get = function(k)
        return self[k]
    end
    --
    self.Set = function(k,v)
        self[k] = v
    end
    --
    self.GetGender = function()
        if self.Appearance["sex"] ~= 0 then
            return "Female"
        else
            return "Male"
        end
    end
    --
    self.GetAccounts = function()
        return self.Accounts
    end
    --
    self.GetAccount = function(acc)
        for k, v in pairs(self.Accounts) do
            if k == acc then
                return v
            end
        end
    end
    --
    self.SetAccount = function(acc, v)
        local num = c.check.Number(v)
        if self.Accounts[acc] then
            self.Accounts[acc] = num
        else
            c.debug("Account entered does not exist")
        end
    end
    --
    self.GetLicenses = function()
        return self.Licenses
    end
    --
    self.GetLicense = function(license)
        for k, v in pairs(self.Licenses) do
            if k == license then
                return v
            end
        end
    end
    --
    self.GetCash = function()
        local acc = self.GetAccount("Cash")
        if acc then
            return acc
        end
    end
    --
    self.SetCash = function(v)
        local num = c.check.Number(v)
            local acc = self.GetAccount("Cash")
            if acc then
                acc = c.math.Decimals(num, 0)
                if acc < 0 then
                    acc = 0
                    c.debug("Player "..self.ID.." Kicked due to negative cash balance")
                    CancelEvent()
                    self.Kick("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                else
                    self.SetAccount("Cash", acc)
                end    
            end
    end
    --
    self.AddCash = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Cash")
            if acc then
                acc = acc + c.math.Decimals(num, 0)
                if acc < 0 then
                    acc = 0
                    c.debug("Player "..self.ID.." Kicked due to negative cash balance")
                    CancelEvent()
                    self.Kick("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                else
                    self.SetAccount("Cash", acc)
                end
            end
    end
    --
    self.RemoveCash = function(v)
        local num = c.check.Number(v)
            local acc = self.GetAccount("Cash")
            if acc then
                acc = acc - c.math.Decimals(num, 0)
                if acc < 0 then
                    acc = 0
                    c.debug("Player "..self.ID.." Kicked due to negative cash balance")
                    CancelEvent()
                    self.Kick("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                else
                    self.SetAccount("Cash", acc)
                end
            end
    end
    --
    self.GetBank = function()
        local acc = self.GetAccount("Bank")
        if acc then
            return acc 
        end
    end
    --
    self.SetBank = function(v)
        local num = c.check.Number(v)
        local acc = c.math.Decimals(num, 0)
        if acc then 
            if acc < 0 then
                self.SetAccount("Bank", acc)
                TriggerClientEvent("Client:Notify", self.ID, "Your bank account is in a negative balance.", "error")
            else
                self.SetAccount("Bank", acc)
            end
        end
    end
    --
    self.AddBank = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Bank")
        if acc then
            acc = acc + c.math.Decimals(num, 0)
            if acc < 0 then
                self.SetAccount("Bank", acc)
                TriggerClientEvent("Client:Notify", self.ID, "Your bank account is in a negative balance.", "error")
            else
                self.SetAccount("Bank", acc)
            end
        end
    end
    --
    self.RemoveBank = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Bank")
        if acc then
                acc = acc - c.math.Decimals(num, 0)
            if acc < 0 then
                self.SetAccount("Bank", acc)
                TriggerClientEvent("Client:Notify", self.ID, "Your bank account is in a negative balance.", "error")
            else
                self.SetAccount("Bank", acc)
            end
        end
    end
    -- esx style, except table format.
    self.GetJob = function()
        return self.Job
    end
    --
    self.SetJob = function(t)
        if c.job.Exist(t.Name, t.Grade) then
            local Object = c.jobs[t.Name]
            --
            self.Job.Name = Object.Name
            self.Job.Label = Object.Label
            --
            self.Job.Grade = Object.Grades[t.Grade].Grade
            self.Job.Grade_Label = Object.Grades[t.Grade].Grade_Label
            self.Job.Grade_Salary = Object.Grades[t.Grade].Grade_Salary
        else
            c.debug("Ignoring invalid .SetJob()")
        end
    end
    --
    self.GetPhone = function()
        return self.Phone
    end
    --
    self.SetPhone = function(s)
        local str = c.check.String(s)
        self.Phone = str
    end
    -- 
    self.GetInstance = function()
        return self.Instance
    end
    --
    self.SetInstance = function(v)
        local num = c.check.Number(v, 0, 63)
        self.Instance = num
    end
    -- 
    self.GetHealth = function()
        return self.Health
    end
    --
    self.SetHealth = function(v)
        local _min = 0
        local _max = conf.defaulthealth
        local num = c.check.Number(v, _min, _max)
        self.Health = num
    end
    --
    self.GetArmour = function()
        return self.Armour
    end
    --
    self.SetArmour = function(v)
        local _min = 0
        local _max = conf.defaultarmour
        local num = c.check.Number(v, _min, _max)        
        self.Armour = num
    end
    --
    self.GetHunger = function()
        return self.Hunger
    end
    --
    self.SetHunger = function(v)
        local _min = 0
        local _max = 100
        local num = c.check.Number(v, _min, _max)
        self.Hunger = num
    end
    --
    self.GetThirst = function()
        return self.Thirst
    end
    --
    self.SetThirst = function(v)
        local _min = 0
        local _max = 100
        local num = c.check.Number(v, _min, _max)
        self.Thirst = num
    end
    --
    self.GetStress = function()
        return self.Stress
    end
    --
    self.SetStress = function(v)
        local _min = 0
        local _max = 100
        local num = c.check.Number(v, _min, _max)
        self.Stress = num
    end
    --
    self.GetModifiers = function()
        return self.Modifiers
    end
    --
    self.SetModifiers = function(t)
        local tab = c.check.Table(t)
        self.Modifiers = tab
    end
    --
    self.GetAppearance = function()
        return self.Appearance
    end
    --
    self.SetAppearance = function(t)
        local tab = c.check.Table(t)
        self.Appearance = tab
    end
    --
    self.GetCoords = function()
        return self.Coords
    end
    --
    self.SetCoords = function(t)
        local tab = c.check.Table(t)
        self.Coords = {
            x = c.math.Decimals(tab.x, 2),
            y = c.math.Decimals(tab.y, 2),
            z = c.math.Decimals(tab.z, 2)
        }
    end
    --
    self.GetWanted = function()
        return self.Wanted
    end
    --
    self.SetWanted = function(b)
        local b = c.check.Boolean(b)
        self.Wanted = b
    end
    --
    c.debug("End Character Class Creation")
    return self
end
