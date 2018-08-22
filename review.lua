
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------



local function buttonHandler( event )

	if (event.phase == "began") then  
	
		event.target.xScale = 0.85 -- Scale the button on touch down so user knows its pressed
		event.target.yScale = 0.85
	
	elseif (event.phase == "moved") then
	
		--something
	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		event.target.xScale = 1 -- Re-scale the button on touch release 
		event.target.yScale = 1

		composer.gotoScene("reviewGame", {time=600, effect="fromRight"})
		
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
	local backcolor = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight + 100 )
	backcolor:setFillColor( 1, 0.86, 0.6 )

	local titleText = display.newText( sceneGroup, "Review", 10, 0, "CHOWFUN_.ttf", 24 )
	local gradient = {
		type="gradient",
		color1={ 0.8,0.3,0.1 }, color2={ 0.8, 0.6, 0.1 }, direction="down"
	}
	titleText.anchorX = 0
	titleText:setFillColor(gradient)
	local descriptionText = display.newText( sceneGroup, "For all those difficult words you got hard time, here is the perfect place to review and practice. " ..
		"If you think you have mastered a word you can mark as completed. \nRemember this is based on your answers when you play 'word test' and 'countdown'", display.contentCenterX, 150, 300, 0, "CHOWFUN_.ttf", 18)
	descriptionText:setFillColor(0.8,0.4,0.1)

	local playButton = display.newImageRect(sceneGroup, "startBtn.png", 118, 47)
	playButton.x = display.contentCenterX
	playButton.y = display.contentHeight
	playButton.id = "play"

	playButton:addEventListener( "touch", buttonHandler )

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
		composer.removeScene("review")
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
