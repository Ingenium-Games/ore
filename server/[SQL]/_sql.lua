-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
if not c.sql then c.sql = {} end
--[[
NOTES

    THIS TABLE HAS BEEN MOVED TO [SQL] TO MAKE IT EAISER TO FIND AND USE FUNCTIONS,
    BECAUSE I GAVE UP PAST 1500 LINES. YEET

]] --
math.randomseed(c.Seed)
-- ====================================================================================--

function c.sql.GenerateCharacterID(cb)
    local bool = false
    local new = nil
    repeat
        new = c.rng.chars(50)
        MySQL.Async.fetchScalar('SELECT `Primary_ID` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;',
            {
                ['@Character_ID'] = new
            }, function(r)
                if r then
                    bool = true
                else
                    bool = false
                end
            end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

function c.sql.GenerateCityID(cb)
    local bool = false
    local new = nil
    repeat
        local s1 = string.upper(c.rng.let())
        local s2 = c.rng.nums(5)
        new = string.format("%s-%s", s1, s2)
        MySQL.Async.fetchScalar('SELECT `Primary_ID` FROM `characters` WHERE `City_ID` = @City_ID LIMIT 1;', {
            ['@City_ID'] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

function c.sql.GeneratePhoneNumber(cb)
    local bool = false
    local new = nil
    repeat
        new = math.random(200000, 799999)
        MySQL.Async.fetchScalar('SELECT `Primary_ID` FROM `characters` WHERE `Phone` = @Phone LIMIT 1;', {
            ['@Phone'] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

function c.sql.GenerateAccountNumber(cb)
    local bool = false
    local new = nil
    repeat
        new = string.upper(c.rng.chars(8))
        MySQL.Async.fetchScalar('SELECT `Character_ID` FROM `character_accounts` WHERE `Account_Number` = @Account_Number LIMIT 1;', {
            ['@Account_Number'] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

-- ====================================================================================--
-- SHould remake htis one..
function c.sql.CreateCharacter(t, cb)
    MySQL.Async.execute(
        'INSERT INTO `characters` (`Primary_ID`, `Character_ID`, `City_ID`, `First_Name`, `Last_Name`, `Height`, `Birth_Date`, `Phone`, `Coords`, `Accounts`, `Modifiers`) VALUES (@Primary_ID, @Character_ID, @City_ID, @First_Name, @Last_Name, @Height, @Birth_Date, @Phone, @Coords, @Accounts, @Modifiers);',
        {
            Primary_ID = t.Primary_ID,
            Character_ID = t.Character_ID,
            City_ID = t.City_ID,
            First_Name = t.First_Name,
            Last_Name = t.Last_Name,
            Height = t.Height,
            Birth_Date = t.Birth_Date,
            Phone = t.Phone,
            Coords = t.Coords,
            Accounts = t.Accounts,
            Modifiers = t.Modifiers,
        }, function(data)
            if data then

            end
            if cb then
                cb()
            end
        end)
end

function c.sql.CreateLoanAccount(Character_ID, Account_Number, cb)
    MySQL.Async.execute(
        'INSERT INTO `character_accounts` (`Character_ID`, `Account_Number`, `Bank`) VALUES (@Character_ID, @Account_Number, @Bank);',{
            ['@Character_ID'] = Character_ID,
            ['@Account_Number'] = Account_Number,
            ['@Bank'] = conf.startingloan,
        }, function(data)
            if data then

            end
            if cb then
                cb()
            end
        end)
end
