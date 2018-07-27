-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
 
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

-- If data doesn't exist, create it!
if(playerData == nil) then 
	newPlayer = {}
	newPlayer["scores"] = {0,0,0,0,0,0,0,0,0}
	newPlayer["username"] = "user" .. math.random(1000, 9999)
	loadsave.saveTable(newPlayer, "playerData.json")
end

-- Go to the menu screen
composer.gotoScene( "menu" )