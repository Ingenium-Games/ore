# Putting the (c).ore in FiveM : [ORE] c = exports.c:ore()

<br>

## Start
As with all source code on the internet, please review and use at your own peril.
This is intended to be used by people getting started within FiveM and to be somewhat user friendly.

Please make sure you have had a read of how to setup a server from the [FiveM Docs](https://docs.fivem.net/docs/), use this as a referance point for both native function useage as well as finding out how things work within their runtime.

But the basics are:
- [Reading the FiveM Docs on how to Setup a Server,](https://docs.fivem.net/docs/server-manual/setting-up-a-server/)
- [Installing and using a SQL Server (MariaDB, MySQL),](https://mariadb.org/)
- Upload the db.sql to your server,
- Check your server.cfg is setup and like the example,
- Have Fun!


A general getting started guide will be under construction soon;

<br>

#### Note:
__*Please only use a linux build server if you are comfortable in development.*__

It does not have features that assist with debugging and troubleshooting for the CFX.re team.

<br>

## Wiki

I am working on a wiki to showcase what funcitons do what for those that dont want to read the comments in the code.

TBC

<br>

## Overview
This is a work of constant development and change, please be advised some functions may break or change on the way to release.




<br>

## Code

<br>

### For Lua

<br>

- Variables = lowercase
```lua
local this = {}
```
- Functions = UpperCamelCase
```lua
function TestingFunction() end
```
- Add notes where possible and define paramaters
```lua
--- Function Description
--@param var string "Context around it"
function TestingFunction(var) 
    if type(var) == "string" then
      print("IS STRING")
    end
end
```

<br>

### For SQL

<br>

- Database tables are lowercase, columns are capitalised.
```sql
INSERT INTO `job_accounts` (`Name`, `Description`, `Boss`, `Members`, `Accounts`) etc.. 
```
- Use Parameters within the mysql-async resource.
```lua
local data = Data being added
MySQL.Async.execute("INSERT `table` .... `Column1` = @data" ... ;", {["@data"] = data}, function(r) end)
```
- Do not do __*this shit!*__
```lua
local data = Data being added
MySQL.Async.execute("INSERT `table` .... `Column1` = "..data.." ... ;" etc...)
```

<br>

### For JS

<br>

I have yet to figure out wha thte ufck I am doing.

<br>

### For Front End (HTML,CSS,etc)

<br>

I have yet to figure out wha thte ufck I am doing.

<br>

<br>

## Tested
__Tested on:__
- Windows Server 
- CentOS 8 Stream

<br>

##### If you seek to profit, sell, include or use secitons of code, please include the full license as shown herein

<br>

## MIT License (MIT)

**Copyright (c) 2021 : Twiitchter, on behalf of https://github.com/Ingenium-Games**

*Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:*

*The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.*

*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*
