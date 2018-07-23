
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local musicTrack

local function gotoGame()
    composer.gotoScene( "instructions", { time=800, effect="crossFade" } )
end
 
local function gotoHighScores()
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

local function gotoSettings()
	composer.gotoScene("settings", {time=800, effect="crossFade"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-- local background = display.newImageRect(sceneGroup, "background.png", 950, 1425) -- add a background
    -- 	background.x = math.floor(display.contentWidth / 2)
	-- 	background.y = math.floor( display.contentHeight / 2)
	local backcolor = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight + 100 )
	backcolor:setFillColor( 1, 0.85, 0.6 )
		
	-- local title = display.newText( sceneGroup, "Language Learning", display.contentCenterX, 100, native.systemFont, 34 )
	local title = display.newImageRect( sceneGroup, "title.png", 375, 63 )
	title.x = display.contentCenterX
	title.y = 100
	title.xScale = 0.8
	title.yScale = 0.8
	
	-- local playButton = display.newText( sceneGroup, "Start", display.contentCenterX, 350, native.systemFont, 24 )
	local playButton = display.newImageRect(sceneGroup, "startBtn.png", 118, 47)
	playButton.x = display.contentCenterX
	playButton.y = 350

    --playButton:setFillColor( 0.82, 0.86, 1 )
 
    -- local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 400, native.systemFont, 24 )
	--highScoresButton:setFillColor( 0.75, 0.78, 1 )
	local highScoresButton = display.newImageRect(sceneGroup, "highscoresBtn.png", 232, 63)
	highScoresButton.x = display.contentCenterX
	highScoresButton.y = 400

	-- local settingsButton = display.newText( sceneGroup, "Settings", display.contentCenterX, 450, native.systemFont, 24 )
	local settingsButton = display.newImageRect(sceneGroup, "settingsBtn.png", 178, 63)
	settingsButton.x = display.contentCenterX
	settingsButton.y = 450

	playButton:addEventListener( "tap", gotoGame )
	highScoresButton:addEventListener( "tap", gotoHighScores )
	settingsButton:addEventListener("tap", gotoSettings)
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

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
