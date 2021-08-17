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

function c.item.Exists(name)
    if c.items[name] then
        return true
    else
        return false
    end
end

function c.item.AddItem(t)
    if not c.items[t.Label] then
        table.insert(c.items, t.Label)
        c.items[t.Label] = t
    end
end

function c.item.DegradeCycle()
    local xPlayers = c.data.GetPlayers()
    for k,v in ipairs(xPlayers) do
        if v then

        end
    end
end

function c.item.CraftItem()

end

function c.item.CalculateWeight() -- Dont force the limit, just when one passes a weight it startes impacting player speed. See Client _Status.lua for example natives to use.

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

function c.item.AddInventory()

end

function c.item.RemoveInventory()

end

function c.item.StackInventory()

end

function c.item.FindNext()

end

function c.item.FindFirst()

end

function c.item.Find()

end

function c.item.ItemCheck()

end

function c.item.QualityCheck()

end

function c.item.QuantityCheck()

end


function c.item.BuildData()
    for k,v in pairs(c.items) do
        
    end
end

c.items = {
    --[[
    Ok so this is the block of code for all you people to copy, paste, and prefill at the bottom of this page.
    If you want to add an item, you CAN do it here, but please, just use the fucking function to add items and not break this.

    COPY START BELOW HERE!

    ["Scorpion"] = {
        Label = "Scorpion",
        Degrade = false,
        DegradeRate = 0.0,
        Quality = 100,
        Quantity = 1,
        Cost = 1200,
        Value = 1650,
        Weight = 4,
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
        Image = "Scorpion.png",
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
        Image = "Scorpion.png",
    },

}