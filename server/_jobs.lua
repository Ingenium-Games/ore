-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.job = {} -- Function Table
c.jobs = {} -- DB Pull
c.jdex = {} -- Job Index for xJobs functions.
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

function c.job.GetJob(str)
    return c.jobs[str]
end

function c.job.GetJobs()
    return c.jobs
end

local CurrentlyActive = {}

--- Return 
function c.job.ActiveMembers()
    local tab = {}
    for k,v in ipairs(CurrentlyActive) do
        if v then
            if not tab[v.Name] then
                table.insert(tab, v.Name)
                tab[v.Name] = 1
            else    
                tab[v.Name] = tab[v.Name] + 1
            end
        end
    end
    return tab
end

-- Testing purposes Only
exports("JobsOnline", c.job.ActiveMembers())

--- 
---@param job string
---@param grade any
function c.job.Exist(job, grade)
	local grade = tostring(grade)
	if job and grade then
		if c.jobs[job] and c.jobs[job].grades[grade] then
			return true
		end
	end
	return false
end

--- Same as above.
---@param job string
---@param grade any
function c.DoesJobExist(job, grade)
    return c.job.Exist(job, grade)
end

-- req = source or number id calling event if internal
-- t = {name = 'police', grade = 1}, Job and then Grade
AddEventHandler('Server:Character:SetJob', function(req, data)
    local src = req or source
    CurrentlyActive[src] = data
end)

-- cleanup the table to reduce crap.
AddEventHandler('playerDropped', function()
    local src = source
    CurrentlyActive[src] = false
end)

--[[
TriggerEvent('Server:Character:SetJob', self.ID, self.GetJob())
self.TriggerEvent('Client:Character:SetJob', self.GetJob())
]]--

--[[Using currently active table to send out pay cycles.]]--

--- func desc
---@param bool boolean "Use the Job funds to pay all employees?" 
function c.job.Payroll(bool)
    if bool then
        for k,v in paris(CurrentlyActive) do
            if v then
                -- CurrentlyActive[1] = [Name='Police',Grade=2,etc,etc]
                local xPlayer = c.data.GetPlayer(k)
                local xJob = c.data.GetJob(v.Name)
                --
                xPlayer.AddBank(v.Grade_Salary)
                TriggerClientEvent("Client:Notify", k, "Recieved Payroll: \n$"..v.Grade_Salary.." deposided confirmed. \n- Maze Bank", 'warn')
                xJob.RemoveBank(v.Grade_Salary)
            end
        end
    else
        for k,v in paris(CurrentlyActive) do
            if v then
                -- CurrentlyActive[1] = [Name='Police',Grade=2,etc,etc]
                local xPlayer = c.data.GetPlayer(k)
                --
                xPlayer.AddBank(v.Grade_Salary)
                TriggerClientEvent("Client:Notify", k, "Recieved Payroll: \n$"..v.Grade_Salary.." deposided confirmed. \n- Maze Bank", 'warn')
            end
        end 
    end
end

function c.job.PayCycle()
    local time = conf.paycycle
    local function Do()
        c.job.Payroll(conf.enablejobpayroll)     
        -- Adding cleanup of empty or false records.
        for k,v in pairs(CurrentlyActive) do
            -- Really make sure its a false record.
            if v == false then
                table.remove(CurrentlyActive, k)
            end
        end
        SetTimeout(Do, time)
    end
    SetTimeout(Do, time)
end
