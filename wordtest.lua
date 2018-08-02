
local composer = require( "composer" )

local scene = composer.newScene()

local widget = require("widget")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local wordsNumber, wordsGroup
local words20Button, words30Button, words50Button, words100Button
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

local function buttonHandler( event )

	if (event.phase == "began") then  
	
		event.target.xScale = 0.85 -- Scale the button on touch down so user knows its pressed
		event.target.yScale = 0.85
	
	elseif (event.phase == "moved") then
	
		--something
	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		event.target.xScale = 1 -- Re-scale the button on touch release 
		event.target.yScale = 1

		words20Button:setFillColor(0.8,0.4,0.1)
		words30Button:setFillColor(0.8,0.4,0.1)
		words50Button:setFillColor(0.8,0.4,0.1)
		words100Button:setFillColor(0.8,0.4,0.1)
		event.target:setFillColor(0.8,0.1,0.1)
		
		if event.target.id == "20" then
			wordsNumber = 20
		elseif event.target.id == "30" then
			wordsNumber = 30
		elseif event.target.id == "50" then
			wordsNumber = 50
		elseif event.target.id == "100"	then
			wordsNumber = 100
		else
			local values = pickerWheel:getValues()
			wordsGroup = values[1].value
			composer.gotoScene("game", {time=600, effect="fromRight", params = {gameMode = "wordTest", selectedTotalWords = wordsNumber, selectedCategory = wordsGroup} })
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
	backcolor:setFillColor( 1, 0.85, 0.6 )

	local titleText = display.newText( sceneGroup, "Word test", 10, 0, "CHOWFUN_.ttf", 24 )
	local gradient = {
		type="gradient",
		color1={ 0.8,0.3,0.1 }, color2={ 0.8, 0.6, 0.1 }, direction="down"
	}
	titleText.anchorX = 0
	titleText:setFillColor(gradient)
	local descriptionText = display.newText( sceneGroup, "This is a multiple choice word translation game. You need to tap the correct answer. " ..
		"If you fail you can try again until you have the correct answer. \nDepending of your number of tries is the score points you get!!", display.contentCenterX, 120, 300, 0, "CHOWFUN_.ttf", 18)
	descriptionText:setFillColor(0.8,0.4,0.1)

	local selectWordText = display.newText( sceneGroup, "Number of words:", display.contentCenterX, 230, "CHOWFUN_.ttf", 16)	
	words20Button = display.newText( sceneGroup, "20", 50, 250, "CHOWFUN_.ttf", 16)	
	words30Button = display.newText (sceneGroup, "30", 120, 250, "CHOWFUN_.ttf", 16)
	words50Button = display.newText (sceneGroup, "50", 190, 250, "CHOWFUN_.ttf", 16)
	words100Button = display.newText (sceneGroup, "100", 260, 250, "CHOWFUN_.ttf", 16)
	selectWordText:setFillColor(0.8,0.4,0.1)
	words20Button:setFillColor(0.8,0.1,0.1)
	words30Button:setFillColor(0.8,0.4,0.1)
	words50Button:setFillColor(0.8,0.4,0.1)
	words100Button:setFillColor(0.8,0.4,0.1)
	words20Button.id = "20"
	words30Button.id = "30"
	words50Button.id = "50"
	words100Button.id = "100"
	wordsNumber = 20 --default selected

	local selectionText = display.newText( sceneGroup, "Please select one group:", display.contentCenterX, 280, "CHOWFUN_.ttf", 16)	
	selectionText:setFillColor(0.8,0.4,0.1)
	pickerWheel = widget.newPickerWheel(
	{
		left = display.contentWidth - display.contentWidth * 0.9,
		top = 290,
		columns = columnData,
		style = "resizable",
		width = display.contentWidth * 0.8,
		rowHeight = 24,
		fontSize = 14,
		columnColor = { 1, 0.85, 0.6 },
		fontColorSelected = { 0.8,0.4,0.1 }
	})
	sceneGroup:insert(pickerWheel)

	local playButton = display.newImageRect(sceneGroup, "startBtn.png", 118, 47)
	playButton.x = display.contentCenterX
	playButton.y = 450
	playButton.id = "play"

	playButton:addEventListener( "touch", buttonHandler )
	words20Button:addEventListener( "touch", buttonHandler )
	words30Button:addEventListener( "touch", buttonHandler )
	words50Button:addEventListener( "touch", buttonHandler )
	words100Button:addEventListener( "touch", buttonHandler )
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
		composer.removeScene("wordtest")
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
