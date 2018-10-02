-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local notifications = require( "plugin.notifications.v2" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
 
-- Seed the random number generator
math.randomseed( os.time() )
 
-- Reserve channel 1 for background music
audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
audio.setVolume( 0.5, { channel=1 } )

-- Using Rob Miracle's loadsave library
local loadsave = require("loadsave")
playerData = loadsave.loadTable("playerData.json") -- try to load the initial data in
settingsData = loadsave.loadTable("settingsData.json")

-- If data doesn't exist, create it!
if(playerData == nil) then 
	newPlayer = {}
	newPlayer["scores"] = {0,0,0,0,0,0,0,0,0}
	newPlayer["scoresWordtest"] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	newPlayer["username"] = "user" .. math.random(1000, 9999)
	loadsave.saveTable(newPlayer, "playerData.json")
end

if(settingsData == nil) then
	settingsData = {}
	settingsData["isVolumeOn"] = true
	settingsData["isReminderOn"] = true
	loadsave.saveTable(settingsData, "settingsData.json")
elseif not settingsData.isVolumeOn then
	audio.setVolume(0)
end

local function onKeyEvent( event )
	local phase = event.phase
	local keyName = event.keyName
	local scene = composer.getSceneName( "current" )
	local options = {
		effect = "zoomInOutFade",
        time = 400
	}
 
	if( (keyName == "back") and (phase == "down") ) then 
	   -- DO SOMETHING HERE
		if scene == "selection" or scene == "highscores" or scene == "settings" then
			composer.gotoScene( "menu", options )
		elseif scene == "instructions" or scene == "wordtest" or scene == "review" then
			composer.gotoScene("selection", options)
		elseif scene == "menu" then
			native.requestExit()
		end
	end
	return true
end
Runtime:addEventListener( "key", onKeyEvent );

local function printTable( t )
 
    local printTable_cache = {}
 
    local function sub_printTable( t, indent )
 
        if ( printTable_cache[tostring(t)] ) then
            print( indent .. "*" .. tostring(t) )
        else
            printTable_cache[tostring(t)] = true
            if ( type( t ) == "table" ) then
                for pos,val in pairs( t ) do
                    if ( type(val) == "table" ) then
                        print( indent .. "[" .. pos .. "] => " .. tostring( t ).. " {" )
                        sub_printTable( val, indent .. string.rep( " ", string.len(pos)+8 ) )
                        print( indent .. string.rep( " ", string.len(pos)+6 ) .. "}" )
                    elseif ( type(val) == "string" ) then
                        print( indent .. "[" .. pos .. '] => "' .. val .. '"' )
                    else
                        print( indent .. "[" .. pos .. "] => " .. tostring(val) )
                    end
                end
            else
                print( indent..tostring(t) )
            end
        end
    end
 
    if ( type(t) == "table" ) then
        print( tostring(t) .. " {" )
        sub_printTable( t, "  " )
        print( "}" )
    else
        sub_printTable( t, "  " )
    end
end
table.print = printTable

-- Get the app's launch arguments in case it was started when the user tapped on a notification
local launchArgs = ...

-- Set up notification options
local options = {
    alert = "Keep learning!",
    badge = 2,
    sound = "alarm.caf",
    custom = { foo = "bar" }
}

if settingsData ~= nil then
	if settingsData.isReminderOn then
		notifications.cancelNotification()
		local utcTime
		for i = 1, 7 do
			utcTime = os.date( "!*t", os.time() + 24*60*60*i )
			notifications.scheduleNotification( utcTime, options )
		end				
	end
end

-- Schedule a notification to occur 60 seconds from now
-- local notification1 = notifications.scheduleNotification( 7200, options )

-- Schedule a notification using Coordinated Universal Time (UTC)
-- local utcTime = os.date( "!*t", os.time() + 60 )
-- local notification2 = notifications.scheduleNotification( utcTime, options )

local function notificationListener( event )		 
    if ( event.type == "local" ) then
		-- Handle the local notification
		print( event.name )
		if ( event.custom ) then
			print( event.custom.foo )
		end
	else --event.type == "remote"
		-- Handle the push notification		
    end
end
 
Runtime:addEventListener( "notification", notificationListener )

-- The launch arguments provide a notification event if this app was started when the user tapped on a notification
-- In this case, you must call the notification listener manually
if ( launchArgs and launchArgs.notification ) then
    notificationListener( launchArgs.notification )
end

-- Go to the menu screen
composer.gotoScene( "menu" )