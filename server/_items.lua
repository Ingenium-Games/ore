-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.item = {} -- function level
-- c.items = {} -- item table
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

c.items = {
    --[[
    Ok so this is the block of code for all you people to copy, paste, and prefill at the bottom of this page.
    If you want to add an item, you CAN do it here, but please, just use the fucking function to add items and not break this.

    COPY START BELOW HERE!

    ["Scorpion"] = {
        Label = "Scorpion", -- name
        Degrade = false,    -- boolean
        DegradeRate = 0.0,  -- rate
        Quality = 100,  -- Starting Quality
        Quantity = 1,   -- Is one? or many?
        Cost = 850,    -- Cost to make
        Value = 1520,   -- Sell Value
        Weight = 4, -- Weight
        Weapon = "-1121678507", -- Becasue anything other than false or 0 is true. G G
        Meta = {    -- Any data you want, Weapons MUST have the three below.
            SerialNumber = "",
            BatchNumber = "",
            Registered = false
        },
        Data = "",  -- Displayable string on inventory.
        Craftable = true,   -- can this be made? if so, add materials.
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 4
        }, {
            ItemRequired = "CarbonAlloy",
            Quantity = 2
        }, {
            ItemRequired = "ShortBarrel",
            Quantity = 1
        }, {
            ItemRequired = "PistolPin",
            Quantity = 1
        }, {
            ItemRequired = "PistolFrame",
            Quantity = 1
        }, {
            ItemRequired = "AutoReciever",
            Quantity = 1
        }},
        Stackable = false, -- Can you put them on top of each other?
        Hotkey = false, -- can it be used with 1-5 slots?
        Image = "Scorpion.png", -- image to render client side.
    },

    ^ COPY END HERE OK, OK!

    Let me break it down for you guys, becasue all your economy servers are a joke.
    Life needs to be hard. People need to struggle to make a story real and genuine.
    Stop giving your players a million dollars a day, because they are self entitled pricks.
    Im not important, you're not important, get over it.

    Want to be different? - Find a cure for cancer cunt.
    I'll suck your dick if you do.

    ]]--

    ["Scorpion"] = {
        Label = "Scorpion",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 960,
        Value = 1650,
        Weight = 5,
        Weapon = "-1121678507", -- Becasue anything other than false or 0 is true. G G
        Meta = {
            SerialNumber = "",
            BatchNumber = "",
            Registered = false
        },
        Data = "",
        Craftable = true,
        Materials = {{
            ItemRequired = "Rubber",
            Quantity = 4
        }, {
            ItemRequired = "CarbonAlloy",
            Quantity = 2
        }, {
            ItemRequired = "ShortBarrel",
            Quantity = 1
        }, {
            ItemRequired = "PistolPin",
            Quantity = 1
        }, {
            ItemRequired = "PistolFrame",
            Quantity = 1
        }, {
            ItemRequired = "AutoReciever",
            Quantity = 1
        }},
        Stackable = false,
        Hotkey = false,
        Image = "Scorpion.png",
    },

}

function c.item.Exists(name)
    if c.items[name] then
        return true
    else
        return false
    end
end

function c.item.GetItem(name)
    if c.item.Exists(name) then
        return c.items[name]
    end 
end

function c.item.AddItem(t)
    if not c.items[t.Label] then
        table.insert(c.items, t.Label)
        c.items[t.Label] = t
    else
        c.debug("Item :"..t.Label.." - Not added due to already existing, please remove duplicate.")
    end
end

function c.item.DegradeCycle()
    local xPlayers = c.data.GetPlayers()
    for k,v in ipairs(xPlayers) do
        if v then
            local xPlayer = c.data.GetPlayer(k)
        
        end
    end
end

function c.item.CraftItem(name, xplayer)
    if c.item.IsCraftable(name) then
        local item = c.item.GetItem(name)
        local xPlayer = c.data.GetPlayer(xplayer)
    else
        c.debug("Item: "..name.." is not craftable")
    end
end


function c.item.CreateDrop()

end

function c.item.IsCraftable(name)
    return c.items[name].Craftable
end

function c.item.IsWeapon(name)
    return c.items[name].Weapon
end

function c.item.CanDegrade(name)
    return c.items[name].Degrade
end

function c.item.CanStack(name)
    return c.items[name].Stackable
end

function c.item.FindNext()

end

function c.item.FindFirst()

end

function c.item.Find()

end


function c.item.BuildData()
    for k,v in pairs(c.items) do
        
    end
end
