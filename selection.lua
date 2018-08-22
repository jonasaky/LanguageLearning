
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

		if event.target.id == "option1" then
			composer.gotoScene( "wordtest" )
		elseif event.target.id == "option2" then
			composer.gotoScene( "instructions" )
		else
			composer.gotoScene( "review" )
		end
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

	-- local titleText = display.newText( sceneGroup, "Selection Mode", display.contentCenterX, 0, "CHOWFUN_.ttf", 24 )
	-- local gradient = {
	-- 	type="gradient",
	-- 	color1={ 0.8,0.3,0.1 }, color2={ 0.8, 0.6, 0.1 }, direction="down"
	-- }
	-- titleText:setFillColor(gradient)
	local titleText = display.newImageRect(sceneGroup, "selectionMode_title.png", 201, 39)
	titleText.x = display.contentCenterX

	-- local option1Text = display.newText( sceneGroup, "Word test", display.contentCenterX, 350, "CHOWFUN_.ttf", 24 )
	-- option1Text:setFillColor(0.8,0.4,0.1)
	-- option1Text.id = "option1"
	local option1Text = display.newImageRect(sceneGroup, "selection_wordTest.png", 136, 39)
	option1Text.x, option1Text.y = display.contentCenterX, 350
	option1Text.id = "option1"

	-- local option2Text = display.newText( sceneGroup, "Countdown", display.contentCenterX, 400, "CHOWFUN_.ttf", 24 )
	-- option2Text:setFillColor(0.8,0.4,0.1)
	-- option2Text.id = "option2"
	local option2Text = display.newImageRect(sceneGroup, "selection_countdown.png", 156, 38)
	option2Text.x, option2Text.y = display.contentCenterX, 400
	option2Text.id = "option2"

	-- local option3Text = display.newText( sceneGroup, "Review", display.contentCenterX, 450, "CHOWFUN_.ttf", 24 )
	-- option3Text:setFillColor(0.8,0.4,0.1)
	-- option3Text.id = "option3"
	local option3Text = display.newImageRect(sceneGroup, "selection_review.png", 105, 38)
	option3Text.x, option3Text.y = display.contentCenterX, 450
	option3Text.id = "option3"

	option1Text:addEventListener( "touch", buttonHandler )
	option2Text:addEventListener( "touch", buttonHandler )
	option3Text:addEventListener( "touch", buttonHandler )
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
		composer.removeScene("selection")
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
