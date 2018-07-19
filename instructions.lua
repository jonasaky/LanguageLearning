
local composer = require( "composer" )

local scene = composer.newScene()

local widget = require( "widget" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local myButton
local countDown = 3
local countDownText
local pickerWheel

local columnData = 
{ 
	{ 
		align = "center",
		width = display.contentWidth * 0.8,
		labelPadding = 20,
		startIndex = 3,
		labels = { "Jr High 1 year Noun", "Jr High 1 year Verb", "Jr High 1 year Adj & Adv", "Jr High 2 year Noun", "Jr High 2 year Verb", "Jr High 2 year Adj", "Jr High 3 year Noun", "Jr High 3 year Verb", "Jr High 3 year Adj & Adv" }
	}
}

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
	
		local values = pickerWheel:getValues()
		local selectedCategory = values[1].value
		print(selectedCategory)
		composer.setVariable( "selectedCategory", selectedCategory )
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
	local selectionText = display.newText( sceneGroup, "Please select one category:", display.contentCenterX, 250, native.systemFont, 16)	
	pickerWheel = widget.newPickerWheel(
	{
		left = display.contentWidth - display.contentWidth * 0.9,
		top = 260,
		columns = columnData,
		style = "resizable",
		width = display.contentWidth * 0.8,
		rowHeight = 24,
		fontSize = 14
	})
	sceneGroup:insert(pickerWheel)

	countDownText = display.newText(sceneGroup, countDown, display.contentCenterX,display.contentHeight - 10, native.systemFont, 40)
	countDownText.isVisible = false

	myButton = display.newImageRect( sceneGroup, "play_btn.png", 552,198)
	myButton.x = display.contentCenterX
	myButton.y = display.contentHeight - 10
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
