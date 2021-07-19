-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Create job as object to check for ownership, permit account or safe access or to 
    - enable job functions or equilivant meu selections.
]]--

math.randomseed(c.Seed)
-- ====================================================================================--

function c.class.CreateJob(tab)
    c.debug('Start Job Creation')
    local self = {}
    --
    self.Name = tab.Name
    self.Label = tab.Label
    self.Boss = tab.Boss
    self.Grades = tab.Grades
    self.Members = tab.Members
    self.Description = tab.Description
    self.Accounts = tab.Accounts
    --
    self.GetGrades = function()
        return self.Grades
    end
    --
    self.GetDescription = function()
        return self.Description
    end
    --
    self.SetDescription = function(s)
        local str = tostring(s)
        if #str <= 1500 then
            self.Description = str
        else
            c.debug('Unable to set description as length is too long. Must be less than 255 characters.')
        end
    end
    --
    self.GetAccounts = function(b)
        local bool = c.check.Boolean(b)
        if bool then
            local Accounts = {}
            for k,v in ipairs(self.Accounts) do
                Accounts[k] = v
            end
            return Accounts
        else
            return self.Accounts
        end
    end
    --
    self.GetAccount = function(acc)
        for k, v in ipairs(self.Accounts) do
            if k == acc then
                return v
            end
        end
    end
    --
    self.GetSafe = function()
        local acc = self.GetAccount('safe')
        if acc then
            return acc
        end
    end
    --
    self.SetSafe = function(v)
        local num = c.check.Number(v)
        if num >= 0 then
            local acc = self.GetAccount('safe')
            if acc then
                local pMoney = acc
                local nMoney = c.math.Decimals(num, 0)
                acc = nMoney
            end
        end
    end
    --
    self.AddSafe = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount('safe')
            if acc then
                local nMoney = acc + c.math.Decimals(num, 0)
                acc = nMoney
            end
        end
    end
    --
    self.RemoveSafe = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount('safe')

            if acc then
                local nMoney = acc - c.math.Decimals(num, 0)
                acc = nMoney
            end
        end
    end
    --
    self.GetBank = function()
        local acc = self.GetAccount('bank')
        if acc then
            return acc
        end
    end
    --
    self.SetBank = function(v)
        local num = c.check.Number(v)
        if num >= 0 then
            local acc = self.GetAccount('bank')
            if acc then
                local pMoney = acc
                local nMoney = c.math.Decimals(num, 0)
                acc = nMoney
            end
        end
    end
    --
    self.AddBank = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount('bank')
            if acc then
                local nMoney = acc + c.math.Decimals(num, 0)
                acc = nMoney
            end
        end
    end
    --
    self.RemoveBank = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount('bank')
            if acc then
                local nMoney = acc - c.math.Decimals(num, 0)
                acc = nMoney
            end
        end
    end

    c.debug("End Job Creation")
    return self
end