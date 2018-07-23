
local composer = require( "composer" )

local scene = composer.newScene()

local loadsave = require("loadsave")
playerData = loadsave.loadTable("playerData.json")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local musicTrack

local defaultField

local function textListener( event )

	if ( event.phase == "began" ) then
		-- User begins editing "defaultBox"

	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		-- Output resulting text from "defaultBox"
		print( "ended:".. event.target.text )

	elseif ( event.phase == "editing" ) then
		print( event.newCharacters )
		print( event.oldText )
		print( event.startPosition )
		print( event.text )
		playerData.username = event.text
	end
end

local function gotoMenu()
	
	loadsave.saveTable(playerData, "playerData.json")
    composer.gotoScene( "menu", { time=600, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-- local background = display.newImageRect(sceneGroup, "background.png", 800, 1400) -- add a background
    -- 	background.x = math.floor(display.contentWidth / 2)
	-- 	background.y = math.floor( display.contentHeight / 2)
	local backcolor = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight + 100 )
	backcolor:setFillColor( 1, 0.85, 0.6 )
    
	local settingsText = display.newText(sceneGroup, "Settings", display.contentCenterX, 0, native.SystemFont, 40)
	settingsText:setFillColor(0.5,0.5,0.5)

	local nickNameLabel = display.newText(sceneGroup, "Your nickname:", display.contentCenterX, 100, native.SystemFont, 24)
	nickNameLabel:setFillColor(0.5,0.5,0.5)
	
	-- Create text field
	defaultField = native.newTextField( display.contentCenterX, 150, 180, 30 )
	-- defaultField.hasBackground = false
	-- defaultField:setTextColor( 0.8, 0.8, 0.8 )
	defaultField:addEventListener( "userInput", textListener )
	defaultField.text = playerData.username
	sceneGroup:insert(defaultField)
	
	local goBackButton = display.newText(sceneGroup, "Go Back", display.contentCenterX, display.contentHeight, native.SystemFont, 30)
	goBackButton:setFillColor( .6,.6,1 )

	goBackButton:addEventListener("tap", gotoMenu)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		display.remove(defaultField)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "settings" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
