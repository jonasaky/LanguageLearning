
local composer = require( "composer" )

local scene = composer.newScene()

local loadsave = require("loadsave")
playerData = loadsave.loadTable("playerData.json")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local musicTrack

-- local function gotoMenu()
--     composer.gotoScene( "menu", { time=600, effect="crossFade" } )
-- end

local function buttonHandler( event )

	if (event.phase == "began") then  
	
		event.target.xScale = 0.85 -- Scale the button on touch down so user knows its pressed
		event.target.yScale = 0.85
	
	elseif (event.phase == "moved") then
	
		--something
	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		event.target.xScale = 1 -- Re-scale the button on touch release 
		event.target.yScale = 1

		composer.gotoScene( "menu", { time=600, effect="crossFade" } )
		
	end
	
	return true
	
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
    
	local highscoresText = display.newText(sceneGroup, "Highscores", display.contentCenterX, 0, "CHOWFUN_.ttf", 40)
	local gradient = {
		type="gradient",
		color1={ 0.8,0.3,0.1 }, color2={ 0.8, 0.6, 0.1 }, direction="down"
	}
	highscoresText:setFillColor(gradient)
	
	local subtitleText = display.newText(sceneGroup, "Countdown", display.contentCenterX, 50, "CHOWFUN_.ttf", 24)
	subtitleText:setFillColor(0.8,0.4,0.1)
	local yourScoreText = display.newText(sceneGroup, "Junior High 1 year__\n  Noun: \n  Verb: \n  Adjective & Adverb: \nJunior High 2 year__\n  Noun: \n  Verb: \n Adjective & Adverb: \nJunior High 3 year__\n  Noun: \n  Verb: \n Adjective & Adverb: ", 10, 240, "CHOWFUN_.ttf", 20)
	yourScoreText.anchorX = 0
	yourScoreText:setFillColor(0.8,0.4,0.1)

	local scorePointsText = "\n"
	for i = 1, #playerData.scores do
		scorePointsText = scorePointsText .. playerData.scores[i] .. "\n"
		if i == 3 or i == 6 then
			scorePointsText = scorePointsText .. "\n"
		end
	end
	local scorePoints = display.newText(sceneGroup, scorePointsText, display.contentWidth - 30, 255, "CHOWFUN_.ttf", 20)
	scorePoints:setFillColor(0.9,0.4,0.1)

	-- local goBackButton = display.newText(sceneGroup, "Go Back", display.contentCenterX, display.contentHeight, native.SystemFont, 30)
	-- goBackButton:setFillColor( .6,.6,1 )
	local goBackButton = display.newImageRect(sceneGroup, "backBtn.png", 174, 63)
	goBackButton.x, goBackButton.y = display.contentCenterX, display.contentHeight

	goBackButton:addEventListener("touch", buttonHandler)
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
		composer.removeScene( "highscores" )
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
