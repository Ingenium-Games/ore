-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.file = {}
--[[
    I only use these for data files in Json, anyone can and should change them to a more 
    appropriately named function. Like ReadJson etc.
]]--
-- ====================================================================================--

function c.file.Exists(file)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."."..file..".json", "r")
    if f then f:close() end
    return f ~= nil
end

function c.file.Read(file)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."."..file..".json", "r")
    local content = f:read("a")
    f:close()
    return json.decode(content)
end
  
-- Write a string to a file.
function c.file.Write(file, content)
    assert(type(content) == "function", "Unable to write to file, cannot write functions to a JSON.")
    local steralize = json.encode(content)
    local f = io.open(GetResourcePath(GetCurrentResourceName()).."."..file..".json",  "w+")
    f:write(steralize)
    f:flush()
    f:close()
end