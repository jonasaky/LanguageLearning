
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local musicTrack
local backGroup
local title, playButton, highScoresButton, settingsButton, background
-- local function gotoGame()
--     composer.gotoScene( "instructions", { time=800, effect="crossFade" } )
-- end
 
-- local function gotoHighScores()
--     composer.gotoScene( "highscores", { time=600, effect="crossFade" } )
-- end

-- local function gotoSettings()
-- 	composer.gotoScene("settings", {time=600, effect="crossFade"})
-- end

-- Create the touch event handler function 
local function buttonHandler( event )

	if (event.phase == "began") then  
	
		event.target.xScale = 0.85 -- Scale the button on touch down so user knows its pressed
		event.target.yScale = 0.85
	
	elseif (event.phase == "moved") then
	
		--something
	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		event.target.xScale = 1 -- Re-scale the button on touch release 
		event.target.yScale = 1

		if event.target.id == "play" then
			composer.gotoScene( "selection", { time=800, effect="fromRight" } )
		elseif event.target.id == "highscores" then
			composer.gotoScene( "highscores", { time=600, effect="fromRight" } )
		else
			composer.gotoScene("settings", {time=600, effect="fromRight"})
		end
	end
	
	return true
	
end 

local function delayCompleted()
	transition.to(title, {time = 300, alpha = 1})
	transition.to(playButton, {time = 300, alpha = 1})
	transition.to(highScoresButton, {time = 300, alpha = 1})
	transition.to(settingsButton, {time = 300, alpha = 1})
	transition.to(background, {time = 600, alpha = 0.5})
end	

local function onCompleted(obj)	
	timer.performWithDelay(600, delayCompleted)	
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	backGroup = display.newGroup()
	sceneGroup:insert(backGroup)	

	background = display.newImageRect(backGroup, "sakura_wallpaper.jpg", 424.8, 754.2) -- add a background
    background.x = math.floor(display.contentWidth / 2)
	background.y = math.floor( display.contentHeight / 2)
	background.alpha = 0
	-- local backcolor = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight + 100 )
	-- backcolor:setFillColor( 1, 0.86, 0.6 )
		
	-- local title = display.newText( sceneGroup, "Language Learning", display.contentCenterX, 100, native.systemFont, 34 )
	title = display.newImageRect( sceneGroup, "title.png", 375, 63 )
	title.x = display.contentCenterX
	title.y = 100
	title.xScale = 0.8
	title.yScale = 0.8
	title.alpha = 0
	
	-- local playButton = display.newText( sceneGroup, "Start", display.contentCenterX, 350, native.systemFont, 24 )
	playButton = display.newImageRect(sceneGroup, "startBtn.png", 118, 47)
	playButton.x = display.contentCenterX
	playButton.y = 350
	playButton.id = "play"
	playButton.alpha = 0
    --playButton:setFillColor( 0.82, 0.86, 1 )
 
    -- local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 400, native.systemFont, 24 )
	--highScoresButton:setFillColor( 0.75, 0.78, 1 )
	highScoresButton = display.newImageRect(sceneGroup, "highscoresBtn.png", 232, 63)
	highScoresButton.x = display.contentCenterX
	highScoresButton.y = 400
	highScoresButton.id = "highscores"
	highScoresButton.alpha = 0

	-- local settingsButton = display.newText( sceneGroup, "Settings", display.contentCenterX, 450, native.systemFont, 24 )
	settingsButton = display.newImageRect(sceneGroup, "settingsBtn.png", 178, 63)
	settingsButton.x = display.contentCenterX
	settingsButton.y = 450
	settingsButton.id = "settings"
	settingsButton.alpha = 0

	timer.performWithDelay(500, (function() transition.to(background, { time=3000, alpha=1, xScale = 0.8, yScale = 0.8, onComplete = onCompleted }) end))

	playButton:addEventListener( "touch", buttonHandler )
	highScoresButton:addEventListener( "touch", buttonHandler )
	settingsButton:addEventListener("touch", buttonHandler )

	musicTrack = audio.loadStream("audio/miyako-japan3.mp3")
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen		
		audio.play( musicTrack, { channel=1, loops=-1 } ) -- Start the music!
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
		-- Stop the music!
        -- audio.stop( 1 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose( musicTrack )
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
