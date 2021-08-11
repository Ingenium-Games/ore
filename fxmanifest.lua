------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description "ore: A FiveM C-ORE Resource to BUILD WITH"
version "0.6"
------------------------------------------------------------------------------
ui_page "nui/ore.html"
loadscreen "https://www.ingenium.games/"
------------------------------------------------------------------------------
-- shared
shared_scripts {"conf.lua", "conf.default.lua", "conf.cars.lua", "conf.disable.lua", "shared/_c.lua"}
------------------------------------------------------------------------------
-- client
client_scripts {"client/_var.lua", "shared/[Tools]/*.lua"," client/_functions.lua", "client/**/*.lua", "client/**/*.js"}
------------------------------------------------------------------------------
-- server
server_scripts {"@mysql-async/lib/MySQL.lua", "server/_var.lua", "shared/[Tools]/*.lua", "server/_functions.lua", "server/**/*.lua", "server/**/*.js"}
------------------------------------------------------------------------------
-- client exports
exports {"c"}
------------------------------------------------------------------------------
-- server exports
server_exports {"c"}
------------------------------------------------------------------------------
-- required resources
dependencies {"mysql-async", "discordroles"}
------------------------------------------------------------------------------
-- files
files { "nui/ore.js", "nui/ore.css", "nui/ore.html", "nui/img/*.png", "nui/img/*.jpg", "nui/jquery-3.5.1.min.js",
       "nui/jquery.mask.min.js", "nui/jquery.validate.min.js"}
