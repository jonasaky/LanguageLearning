
local composer = require( "composer" )

local scene = composer.newScene()

local loadsave = require("loadsave")
playerData = loadsave.loadTable("playerData.json")

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local musicTrack
local highscoresText, subtitleText, yourScoreText, scorePoints, countdownContent, subtitles
local scorePointsText, wordtestPoints
local nextPageButton, previousPageButton
local currentPage = 1

-- local function gotoMenu()
--     composer.gotoScene( "menu", { time=600, effect="crossFade" } )
-- end

local function listener1( obj )	
	currentPage = currentPage + 1
	if currentPage == 5 then
		nextPageButton.isVisible = false
	end

	subtitleText.text = subtitles[currentPage]
	scorePoints.text = wordtestPoints[currentPage]
	
	previousPageButton.isVisible = true
	
	transition.to( subtitleText, { time=500, alpha=1  })
	transition.to( yourScoreText, { time=500, alpha=1 })
	transition.to( previousPageButton, { time=500, alpha=1 })
	transition.to( scorePoints, { time=500, alpha=1 })	
end

local function listener2( obj )	
	currentPage = currentPage - 1
	if currentPage == 1 then
		previousPageButton.isVisible = false
	end

	subtitleText.text = subtitles[currentPage]
	scorePoints.text = wordtestPoints[currentPage]
	
	nextPageButton.isVisible = true

	transition.to( subtitleText, { time=500, alpha=1  })
	transition.to( yourScoreText, { time=500, alpha=1 })
	transition.to( nextPageButton, { time=500, alpha=1 })
	transition.to( scorePoints, { time=500, alpha=1 })		
end

local function buttonHandler( event )

	if (event.phase == "began") then  
		if event.target.id == "nextPage" then
			
			-- transition.to( event.target, { time=500, alpha=0,  onComplete=listener1 } )
			transition.to( subtitleText, { time=500, alpha=0,  } )
			transition.to( yourScoreText, { time=500, alpha=0, } )
			transition.to( scorePoints, { time=500, alpha=0,  onComplete=listener1 } )
			
		else
			
			-- transition.to( event.target, { time=500, alpha=0,  onComplete=listener2 } )
			transition.to( subtitleText, { time=500, alpha=0,  } )
			transition.to( yourScoreText, { time=500, alpha=0, } )
			transition.to( scorePoints, { time=500, alpha=0,  onComplete=listener2 } )
			
		end

		event.target.xScale = 0.85 -- Scale the button on touch down so user knows its pressed
		event.target.yScale = 0.85
	
	elseif (event.phase == "moved") then
	
		--something
	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		event.target.xScale = 1 -- Re-scale the button on touch release 
		event.target.yScale = 1

		-- composer.gotoScene( "menu", { time=400, effect="zoomInOutFade" } )
		
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
	backcolor:setFillColor( 1, 0.86, 0.6 )
    
	-- highscoresText = display.newText(sceneGroup, "Highscores", display.contentCenterX, 0, "CHOWFUN_.ttf", 40)
	-- local gradient = {
	-- 	type="gradient",
	-- 	color1={ 0.8,0.3,0.1 }, color2={ 0.8, 0.6, 0.1 }, direction="down"
	-- }
	-- highscoresText:setFillColor(gradient)
	highscoresText = display.newImageRect(sceneGroup, "title_highscores.png", 194,55)
	highscoresText.x = display.contentCenterX
	
	countdownContent = "Junior High 1 year__\n  Noun: \n  Verb: \n  Adjective & Adverb: \nJunior High 2 year__\n  Noun: \n  Verb: \n  Adjective & Adverb: \nJunior High 3 year__\n  Noun: \n  Verb: \n  Adjective & Adverb: "
	
	subtitles = {"Countdown", "Word Test - 20 Words", "Word Test - 30 Words", "Word Test - 40 Words", "Word Test - 50 Words"}
	subtitleText = display.newText(sceneGroup, subtitles[1], display.contentCenterX, 50, "CHOWFUN_.ttf", 24)
	subtitleText:setFillColor(0.8,0.4,0.1)
	yourScoreText = display.newText(sceneGroup, countdownContent, 10, 240, "CHOWFUN_.ttf", 20)
	yourScoreText.anchorX = 0
	yourScoreText:setFillColor(0.8,0.4,0.1)

	scorePointsText = "\n"
	for i = 1, #playerData.scores do
		scorePointsText = scorePointsText .. playerData.scores[i] .. "\n"
		if i == 3 or i == 6 then
			scorePointsText = scorePointsText .. "\n"
		end
	end

	wordtestPoints = {scorePointsText}
	local categoryCounter = 2
	wordtestPoints[categoryCounter] = "\n"
	for i = 1, #playerData.scoresWordtest do		
		wordtestPoints[categoryCounter] = wordtestPoints[categoryCounter] .. playerData.scoresWordtest[i] .. "\n"
		if i == 3 or i == 6 or i == 12 or i == 15 or i == 21 or i == 24 or i == 30 or i == 33 then
			wordtestPoints[categoryCounter] = wordtestPoints[categoryCounter] .. "\n"
		elseif i == 9 or i == 18 or i == 27 then
			categoryCounter = categoryCounter + 1
			wordtestPoints[categoryCounter] = "\n"
		end		
	end
	scorePoints = display.newText(sceneGroup, scorePointsText, display.contentWidth - 30, 255, "CHOWFUN_.ttf", 20)
	scorePoints:setFillColor(0.9,0.4,0.1)

	-- local nextPageButton = display.newText(sceneGroup, "Go Back", display.contentCenterX, display.contentHeight, native.SystemFont, 30)
	-- nextPageButton:setFillColor( .6,.6,1 )
	nextPageButton = display.newImageRect(sceneGroup, "nextpage.png", 82, 38)
	nextPageButton.x, nextPageButton.y = display.contentWidth - 50, display.contentHeight
	nextPageButton.id = "nextPage"

	previousPageButton = display.newImageRect(sceneGroup, "previouspage.png", 130, 50)
	previousPageButton.x, previousPageButton.y = 80, display.contentHeight
	previousPageButton.id = "previousPage"
	previousPageButton.isVisible = false

	nextPageButton:addEventListener("touch", buttonHandler)
	previousPageButton:addEventListener("touch", buttonHandler)
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
