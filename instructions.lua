
local composer = require( "composer" )

local scene = composer.newScene()

local widget = require( "widget" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local selectedCategory
local playButton
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

-- local function gotoMenu()
-- 	composer.gotoScene("menu", { time=600, effect="crossFade" })
-- end

local function countDownHandle()
	if countDown == 1 then 
		composer.gotoScene("game", { params = {gameMode = "countDown", selectedCategory = selectedCategory}})
	else
		countDown = countDown - 1
		countDownText.text = countDown	
	end		
end

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
	
		-- if event.target.id == "back" then
		-- 	composer.gotoScene("menu", { time=400, effect="zoomInOutFade" })
		-- else
			-- goBackButton.isVisible = false
			countDownText.isVisible = true
			timer.performWithDelay( 400, countDownHandle, 3)
			-- playButton:removeEventListener("touch", buttonHandler)
			playButton.isVisible = false
		
			local values = pickerWheel:getValues()
			selectedCategory = values[1].value
			print(selectedCategory)
			-- composer.setVariable( "selectedCategory", selectedCategory )
		-- end
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
	-- local background = display.newImageRect(sceneGroup, "background.png", 950, 1425) -- add a background
    -- 	background.x = math.floor(display.contentWidth / 2)
	-- 	background.y = math.floor( display.contentHeight / 2)
	local backcolor = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight + 100 )
	backcolor:setFillColor( 1, 0.86, 0.6 )

	local titleText = display.newText( sceneGroup, "Description", 10, 0, "CHOWFUN_.ttf", 24 )
	local gradient = {
		type="gradient",
		color1={ 0.8,0.3,0.1 }, color2={ 0.8, 0.6, 0.1 }, direction="down"
	}
	titleText.anchorX = 0
	titleText:setFillColor(gradient)
	local descriptionText = display.newText( sceneGroup, "This is a multiple choice word translation game. You need to tap the correct answer. " ..
		"If you fail you can try again until you have the correct answer. \nTry to get as many as possible correct answers in 1 minute!!", display.contentCenterX, 120, 300, 0, "CHOWFUN_.ttf", 18)
	descriptionText:setFillColor(0.8,0.4,0.1)
	-- local systemFonts = native.getFontNames() 
	-- local searchString = "pt"
	
	-- for i, fontName in ipairs( systemFonts ) do
	-- 	local j, k = string.find( string.lower(fontName), string.lower(searchString) )
	
	-- 	if ( j ~= nil ) then
	-- 		print( "Font Name = " .. tostring( fontName ) )
	-- 	end
	-- end
	local selectionText = display.newText( sceneGroup, "Please select one group:", display.contentCenterX, 250, "CHOWFUN_.ttf", 16)	
	selectionText:setFillColor(0.8,0.4,0.1)
	pickerWheel = widget.newPickerWheel(
	{
		left = display.contentWidth - display.contentWidth * 0.9,
		top = 260,
		columns = columnData,
		style = "resizable",
		width = display.contentWidth * 0.8,
		rowHeight = 24,
		fontSize = 14,
		columnColor = { 1, 0.85, 0.6 },
		fontColorSelected = { 0.8,0.4,0.1 }
	})
	sceneGroup:insert(pickerWheel)

	countDownText = display.newText(sceneGroup, countDown, display.contentCenterX,display.contentHeight - 50, "CHOWFUN_.ttf", 40)
	countDownText:setFillColor(0.8,0.4,0.1)
	countDownText.isVisible = false

	playButton = display.newImageRect( sceneGroup, "play_btn.png", 200,71)
	playButton.x = display.contentCenterX
	playButton.y = display.contentHeight - 60
	-- playButton.xScale = 0.4
	-- playButton.yScale = 0.4
	playButton.id = "play"

	-- goBackButton = display.newImageRect(sceneGroup, "backBtn.png", 174, 63)
	-- goBackButton.x, goBackButton.y = display.contentCenterX, display.contentHeight
	-- goBackButton.id = "back"

	playButton:addEventListener("touch",buttonHandler)
	-- goBackButton:addEventListener("touch", buttonHandler)
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
