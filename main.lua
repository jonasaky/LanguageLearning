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

-- Get the app's launch arguments in case it was started when the user tapped on a notification
local launchArgs = ...

-- Set up notification options
local options = {
    alert = "Wake up!",
    badge = 2,
    sound = "alarm.caf",
    custom = { foo = "bar" }
}

-- Schedule a notification to occur 60 seconds from now
local notification1 = notifications.scheduleNotification( 60, options )

-- Schedule a notification using Coordinated Universal Time (UTC)
local utcTime = os.date( "!*t", os.time() + 60 )
local notification2 = notifications.scheduleNotification( utcTime, options )

local function notificationListener( event )
 
    if ( event.type == "remote" ) then
        -- Handle the push notification
 
    elseif ( event.type == "local" ) then
        -- Handle the local notification
		print( event.name )
		if ( event.custom ) then
			print( event.custom.foo )
		end
    end
end
 
Runtime:addEventListener( "notification", notificationListener )

-- The launch arguments provide a notification event if this app was started when the user tapped on a notification
-- In this case, you must call the notification listener manually
if ( launchArgs and launchArgs.notification ) then
    onNotification( launchArgs.notification )
end

-- Go to the menu screen
composer.gotoScene( "menu" )