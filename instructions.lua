
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local myButton
local countDown = 3
local countDownText

local function countDownHandle()
	if countDown == 1 then 
		composer.gotoScene("game")
	else
		countDown = countDown - 1
		countDownText.text = countDown	
	end		
end

-- Create the touch event handler function 
local function buttonHandler( event )

	if (event.phase == "began") then  
	
		myButton.xScale = 0.35 -- Scale the button on touch down so user knows its pressed
		myButton.yScale = 0.35
	
	elseif (event.phase == "moved") then
	
		--something
	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		myButton.xScale = 0.4 -- Re-scale the button on touch release 
		myButton.yScale = 0.4
	
		countDownText.isVisible = true
		timer.performWithDelay( 600, countDownHandle, 3)
		-- myButton:removeEventListener("touch", buttonHandler)
		myButton.isVisible = false
	
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

	local titleText = display.newText( sceneGroup, "Description", 10, 0, "Segoe UI", 24 )
	titleText.anchorX = 0
	local descriptionText = display.newText( sceneGroup, "This is a multiple choice word translation game. You need to tap the correct answer. " ..
		"If you fail you can try again until you have the correct answer. \nTry to get as many as possible correct answers in 1 minute!!", display.contentCenterX, 120, 300, 0, "Segoe UI", 20)

	-- local systemFonts = native.getFontNames() 
	-- local searchString = "pt"
	
	-- for i, fontName in ipairs( systemFonts ) do
	-- 	local j, k = string.find( string.lower(fontName), string.lower(searchString) )
	
	-- 	if ( j ~= nil ) then
	-- 		print( "Font Name = " .. tostring( fontName ) )
	-- 	end
	-- end

	countDownText = display.newText(sceneGroup, countDown, display.contentCenterX,display.contentHeight - 100, native.systemFont, 40)
	countDownText.isVisible = false

	myButton = display.newImageRect( sceneGroup, "play_btn.png", 552,198)
	myButton.x = display.contentCenterX
	myButton.y = display.contentHeight - 100
	myButton.xScale = 0.4
	myButton.yScale = 0.4

	myButton:addEventListener("touch",buttonHandler)

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
		composer.removeScene( "instructions" )
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
