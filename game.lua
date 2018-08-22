
local composer = require( "composer" )

local scene = composer.newScene()

local loadsave = require("loadsave")
playerData = loadsave.loadTable("playerData.json")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local gameMode
local backGroup, mainGroup
local correctSound, incorrectSound, finishSound
local tryCount = 0
local question, optionA, optionB, optionC, optionD, finishButton, correct, scoreText, scoreGoodText, badScoreText, hintText
local score = 0
local scoreGood = 0
local badScore = 0
local categoryNumber = 0
local randomOrder = {}
local wordsTable
local progressBar
local total
local musicTrack

if wordsTable == nil then
	wordsTable = 
	{
		{
			image = "apple.png",
			english = "Apple",
			japanese = "りんご"
		},
		{
			image = "orange.png",
			english = "Orange",
			japanese = "オレンジ"
		},
		{
			image = "melon.png",
			english = "Melon",
			japanese = "メロン"
		},
		{
			image = "ballpen.png",
			english = "Ballpen",
			japanese = "ボールペン"
		},
		{
			image = "flower.png",
			english = "Flower",
			japanese = "はな"
		},
		{
			image = "tree.png",
			english = "Tree",
			japanese = "き"
		},
		{
			image = "hair.png",
			english = "Hair",
			japanese = "かみ"
		},
		{
			image = "head.png",
			english = "Head",
			japanese = "あたま"
		},
		{
			image = "stomach.png",
			english = "Stomach",
			japanese = "おなか"
		},
		{
			image = "glasses.png",
			english = "Glasses",
			japanese = "めがね"
		},
		{
			image = "leg.png",
			english = "Foot, leg",
			japanese = "足（あし）"
		}
	}
end

local countdownTimer
local centiSecondsLeft = 1*6000
local clockText
local minutes
local second
local centiSeconds

local function showFinalScore()
	display.remove(mainGroup)
	audio.play(finishSound)
	local resultTitle = display.newText(backGroup, "Great job!", display.contentCenterX, 0, "CHOWFUN_.ttf", 28)
	resultTitle:setFillColor(0.8,0.4,0.1)
	local scoreResult = display.newText(backGroup, " Your score　\nExcellent: " .. score .. "\nGood: " .. scoreGood .. "\nBad: " .. badScore, display.contentCenterX, 160, "CHOWFUN_.ttf", 30)
	scoreResult:setFillColor(0.8,0.4,0.1)

	if gameMode == "wordTest" then
		if score > playerData.scoresWordtest[categoryNumber] then
			resultTitle.text = "New highscore!"
			playerData.scoresWordtest[categoryNumber] = score
			loadsave.saveTable(playerData, "playerData.json")
		end
	else
		if score > playerData.scores[categoryNumber] then
			resultTitle.text = "New highscore!"
			playerData.scores[categoryNumber] = score
			loadsave.saveTable(playerData, "playerData.json")
		end
	end
	finishButton.isVisible = true
end

local function updateTime()

    minutes = math.floor(centiSecondsLeft/6000)
    seconds = math.floor((centiSecondsLeft-(minutes*6000))/100)
    centiSeconds =((centiSecondsLeft-(minutes*6000))%100)
	-- clockText.text = string.format("%02d:%02d:%02d", minutes, seconds, centiSeconds)
	clockText.text = string.format("%02d:%02d", seconds, centiSeconds)
	centiSecondsLeft = centiSecondsLeft - 1
	
	if centiSecondsLeft == 0 then
		showFinalScore()
	end

	progressBar.width = progressBar.width - 0.054

end

local function joinTables(t1, t2)

	for k,v in ipairs(t2) do
	   table.insert(t1, v)
	end 
 
	return t1
end

local function loadWords(category)
	-- local category = composer.getVariable( "selectedCategory" )
	if category == "Jr High 1 year Noun" then
		wordsTable = loadsave.loadTable("jrhigh1year_noun.json", system.ResourceDirectory)
		categoryNumber = 1
	elseif category == "Jr High 1 year Verb" then
		wordsTable = loadsave.loadTable("jrhigh1year_verb.json", system.ResourceDirectory)
		categoryNumber = 2
	elseif category == "Jr High 1 year Adj & Adv" then
		wordsTable = loadsave.loadTable("jrhigh1year_adjadv.json", system.ResourceDirectory)
		categoryNumber = 3
	elseif category == "Jr High 2 year Noun" then
		wordsTable = loadsave.loadTable("jrhigh2year_noun.json", system.ResourceDirectory)
		categoryNumber = 4
	elseif category == "Jr High 2 year Verb" then
		wordsTable = loadsave.loadTable("jrhigh2year_verb.json", system.ResourceDirectory)
		categoryNumber = 5
	elseif category == "Jr High 2 year Adj" then
		wordsTable = loadsave.loadTable("jrhigh2year_adj.json", system.ResourceDirectory)
		categoryNumber = 6
	elseif category == "Jr High 3 year Noun" then
		wordsTable = loadsave.loadTable("jrhigh3year_noun.json", system.ResourceDirectory)
		categoryNumber = 7
	elseif category == "Jr High 3 year Verb" then
		wordsTable = loadsave.loadTable("jrhigh3year_verb.json", system.ResourceDirectory)
		categoryNumber = 8
	elseif category == "Jr High 3 year Adj & Adv" then
		wordsTable = loadsave.loadTable("jrhigh3year_adjadv.json", system.ResourceDirectory)
		categoryNumber = 9
	end
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function shuffling (tab)
	for i = 1, 100 do
		local random1 = math.random(#tab)
		local random2 = math.random(#tab)
		tab[random1], tab[random2] = tab[random2], tab[random1]
	end
end

local function createQuestion(isEnglish)

	-- display.remove ( correct )
	optionA.isCorrect = false
	optionB.isCorrect = false
	optionC.isCorrect = false
	optionD.isCorrect = false

	local i = 1
	local answersDisplayed = {}
	while i <= 4 do
		local n = math.random(#wordsTable)
		if (has_value(answersDisplayed, n) == false) and n ~= total then
			table.insert(answersDisplayed,n)
			i = i + 1
		end
	end

	local answerText
	if isEnglish == 1 then
		answerText = wordsTable[total].japanese
		hintText.text = ""
		question.text = wordsTable[total].english
		optionA.text = wordsTable[answersDisplayed[1]].japanese
		optionB.text = wordsTable[answersDisplayed[2]].japanese
		optionC.text = wordsTable[answersDisplayed[3]].japanese
		optionD.text = wordsTable[answersDisplayed[4]].japanese
	else
		answerText = wordsTable[total].english
		hintText.text = wordsTable[total].hiragana
		question.text = wordsTable[total].japanese
		optionA.text = wordsTable[answersDisplayed[1]].english
		optionB.text = wordsTable[answersDisplayed[2]].english
		optionC.text = wordsTable[answersDisplayed[3]].english
		optionD.text = wordsTable[answersDisplayed[4]].english
	end
	
	local order = math.random(4)

	if order == 1 then
		optionA.text = answerText
		optionA.isCorrect = true
	elseif order == 2 then
		optionB.text = answerText
		optionB.isCorrect = true
	elseif order == 3 then
		optionC.text = answerText
		optionC.isCorrect = true
	else
		optionD.text = answerText
		optionD.isCorrect = true
	end
	
	total = total - 1
end

local function evaluateAnswer( answer )
	

	if answer.isCorrect then
		if tryCount == 0 then
			score = score + 1	
			scoreText.text = "excellent: " .. score
			audio.play(correctSound[1])
		elseif tryCount == 1 then
			scoreGood = scoreGood + 1
			scoreGoodText.text = "good: " .. scoreGood
			audio.play(correctSound[2])
		else
			badScore = badScore + 1
			badScoreText.text = "bad: " .. badScore
			audio.play(correctSound[3])
		end		
		tryCount = 0

		-- correct = display.newText( mainGroup, "✔", answer.x + 40, answer.y, native.systemFont, 24)
		-- correct:setFillColor( .2,1,0)

		if gameMode == "wordTest" and total == 0 then
			showFinalScore()
		else
			timer.performWithDelay( 100, function() createQuestion(math.random(2)) end )
		end
		
	else
		tryCount = tryCount + 1
		-- if tryCount > 1 then
		-- 	audio.play(tryagainSound[math.random(3)])
		-- else
		-- 	audio.play(incorrectSound)			
		-- end
		audio.play(incorrectSound[math.random(3)])
		
		-- local incorrectText = display.newText( mainGroup, "✘", answer.x + 40, answer.y, native.systemFont, 24)
		-- incorrectText:setFillColor( 1, 0,0)
		-- timer.performWithDelay( 500, function() display.remove(incorrectText) end )
		
	end

end

local function hideShowIncorrectAnswers(value)
	if optionA.isCorrect then
		optionB.alpha = value
		optionC.alpha = value
		optionD.alpha = value
	elseif optionB.isCorrect then
		optionA.alpha = value
		optionC.alpha = value
		optionD.alpha = value
	elseif optionC.isCorrect then
		optionA.alpha = value
		optionB.alpha = value
		optionD.alpha = value
	else
		optionA.alpha = value
		optionB.alpha = value
		optionC.alpha = value
	end
end

local function listener1( obj )
	-- print( "Transition 1 completed on object: " .. obj )
	obj.alpha = 1
	obj.xScale = 1
	obj.yScale = 1
	if obj ~= nil and centiSecondsLeft > 0 then 
		obj:setFillColor(0.8,0.4,0.1) 
	end
	evaluateAnswer(obj)	
	hideShowIncorrectAnswers(1)
end

local function buttonHandler( event )

	if (event.phase == "began") then  
		-- Scale the button on touch down so user knows its pressed
		if event.target.isCorrect then
			event.target:setFillColor(0,1,0)
			hideShowIncorrectAnswers(0)
			transition.to( event.target, { time=1000, alpha=0, xScale=(3), yScale=(3), onComplete=listener1 } )
		elseif event.target.isCorrect ~= nil then
			event.target:setFillColor(1,0,0)
			transition.to( event.target, { time=300, xScale=(0.85), yScale=(0.85), onComplete=listener1 } )
		else
			event.target.xScale = 0.85 
			event.target.yScale = 0.85
		end		
	
	elseif (event.phase == "moved") then	
		--something	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		if event.target.id == "finish" then
			event.target.xScale = 1 -- Re-scale the button on touch release 
			event.target.yScale = 1
			composer.gotoScene( "menu", { time=400, effect="zoomInOutFade" } )
		else
			-- evaluateAnswer(event)
		end
		
	end
	
	return true
	
end 

local function pauseResumeTimer(isPaused)
	if countdownTimer then
		if isPaused then
			-- print("resume timer")
			timer.resume(countdownTimer)
		else
			-- print("pause timer")
			timer.pause(countdownTimer)
		end
	end
end

local function exitGame()
	if gameMode == "countDown" then
		composer.gotoScene("instructions", options)
	else
		composer.gotoScene("wordtest", options)
	end
end

local function onKeyEvent(event)
	local phase = event.phase
	local keyName = event.keyName
 
	if( (keyName == "back") and (phase == "down") ) then 
	   -- DO SOMETHING HERE
		pauseResumeTimer(false)
		-- Handler that gets notified when the alert closes
		local function onComplete( event )
			if ( event.action == "clicked" ) then
				local i = event.index
				if ( i == 1 ) then
					-- Do nothing; dialog will simply dismiss
					pauseResumeTimer(true)
				elseif ( i == 2 ) then
					-- Open URL if "Learn More" (second button) was clicked
					-- system.openURL( "http://www.coronalabs.com" )
					-- composer.removeScene("game")
					exitGame()
				end
			else
				pauseResumeTimer(true)
			end
		end
		
		-- Show alert with two buttons
		local alert = native.showAlert( "", "Finish game?", { "Cancel", "Yes" }, onComplete )
		
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
	-- loadsave.saveTable(wordsTable, "words.json")
	backGroup = display.newGroup()
	mainGroup = display.newGroup()
	sceneGroup:insert( backGroup ) 
	sceneGroup:insert( mainGroup ) 

	print( event.params["gameMode"] )
	gameMode = event.params["gameMode"]

	-- local background = display.newImageRect(mainGroup, "background.png", 950, 1425) -- add a background
    -- 	background.x = math.floor(display.contentWidth / 2)
	-- 	background.y = math.floor( display.contentHeight / 2)
	local backcolor = display.newRect( backGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight + 100 )
	backcolor:setFillColor( 1, 0.86, 0.6 )

	if gameMode == "countDown" then
		progressBar = display.newRect(mainGroup, 0, 0, display.contentWidth, 5)
		progressBar.anchorX = 0
		progressBar:setFillColor(1,0.2,0.2)
		
		countdownTimer = timer.performWithDelay(10, updateTime, centiSecondsLeft)
		clockText = display.newText(mainGroup, "", display.contentCenterX, 10, native.systemFont, 40)
		clockText.isVisible = false
	end

	scoreText = display.newText(backGroup, "excellent: " .. score, 50, display.contentHeight, native.systemFont, 14)
	scoreText:setFillColor(0.8,0.4,0.1)

	scoreGoodText = display.newText(backGroup, "good: " .. scoreGood, display.contentCenterX, display.contentHeight, native.systemFont, 14)
	scoreGoodText:setFillColor(0.8,0.4,0.1)

	badScoreText = display.newText(backGroup, "bad: " .. badScore, display.contentWidth - 40, display.contentHeight, native.systemFont, 14)
	badScoreText:setFillColor(0.8,0.4,0.1)

	-- finishButton = display.newText( mainGroup, "Finish" , display.contentCenterX, 480, native.systemFont, 20 )	
	-- finishButton:setFillColor( .6,.6,1 )
	finishButton = display.newImageRect( backGroup, "finishBtn.png", 145, 62)
	finishButton.x, finishButton.y = display.contentCenterX, display.contentHeight - 100
	finishButton.id = "finish"
	finishButton.isVisible = false

	-- joinTables(wordsTable, nounTable)
	loadWords(event.params["selectedCategory"])
	shuffling(wordsTable)
	
	-- for i = 1, #wordsTable do 
	-- 	print(wordsTable[i].english)
	-- end

	if gameMode == "wordTest" then
		-- total = event.params["wordsNumber"]
		print(event.params["selectedTotalWords"])
		local totalWords = event.params["selectedTotalWords"]
		local selectedCategory = event.params["selectedCategory"]
				
		if selectedCategory == "Jr High 1 year Noun" then
			categoryNumber = 1
		elseif selectedCategory == "Jr High 1 year Verb" then
			categoryNumber = 2
		elseif selectedCategory == "Jr High 1 year Adj & Adv" then
			categoryNumber = 3
		elseif selectedCategory == "Jr High 2 year Noun" then
			categoryNumber = 4
		elseif selectedCategory == "Jr High 2 year Verb" then
			categoryNumber = 5
		elseif selectedCategory == "Jr High 2 year Adj" then
			categoryNumber = 6
		elseif selectedCategory == "Jr High 3 year Noun" then
			categoryNumber = 7
		elseif selectedCategory == "Jr High 3 year Verb" then
			categoryNumber = 8
		elseif selectedCategory == "Jr High 3 year Adj & Adv" then
			categoryNumber = 9
		end

		if totalWords == 30 then
			categoryNumber = categoryNumber + 9
		elseif totalWords == 40 then
			categoryNumber = categoryNumber + 18
		elseif totalWords == 50 then
			categoryNumber = categoryNumber + 27
		end
		
		total = totalWords
	else
		total = #wordsTable
	end

	hintText = display.newText( mainGroup, "", display.contentCenterX, 90, native.systemFont, 18)
	hintText:setFillColor(0.8,0.4,0.1)
	local options = 
	{
		parent = mainGroup,
		text = "",     
		x = display.contentCenterX,
		y = 140,
		width = display.actualContentWidth,
		font = native.systemFont,   
		fontSize = 40,
		align = "center"  -- Alignment parameter
	}
	question = display.newText( options )
	-- question.anchorX = 0
	-- question.align = "center"
	question:setFillColor( 1, 0.5, 0)
	
	optionA = display.newText( mainGroup, "" , display.contentCenterX, 280, native.systemFont, 20 )	
	optionA:setFillColor(0.8,0.4,0.1)
	-- optionA.anchorX = 0
	optionB = display.newText( mainGroup, "" , display.contentCenterX, 330, native.systemFont, 20 )	
	optionB:setFillColor(0.8,0.4,0.1)
	-- optionB.anchorX = 0
	optionC = display.newText( mainGroup, "" , display.contentCenterX, 380, native.systemFont, 20 )	
	optionC:setFillColor(0.8,0.4,0.1)
	-- optionC.anchorX = 0
	optionD = display.newText( mainGroup, "" , display.contentCenterX, 430, native.systemFont, 20 )
	optionD:setFillColor(0.8,0.4,0.1)
	-- optionD.anchorX = 0

	createQuestion(1)

	finishButton:addEventListener( "touch", buttonHandler )

	optionA:addEventListener( "touch", buttonHandler)
	optionB:addEventListener( "touch", buttonHandler)
	optionC:addEventListener( "touch", buttonHandler)
	optionD:addEventListener( "touch", buttonHandler)

	correctSound = {audio.loadSound( "audio/yipee.mp3"), audio.loadSound("audio/crrect_answer1.mp3"), audio.loadSound("audio/crrect_answer2.mp3") }
	incorrectSound = {audio.loadSound( "audio/blip01.mp3" ), audio.loadSound("audio/blip04.mp3"), audio.loadSound("audio/laugh.mp3") }
	finishSound = audio.loadSound( "audio/crrect_answer3.mp3")
	-- tryagainSound = audio.loadSound( "audio/laugh.mp3")
	musicTrack = audio.loadStream("audio/miyako_japan2.mp3")
	audio.stop(1)
	
	Runtime:addEventListener("key", onKeyEvent)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play( musicTrack, { channel=1, loops=-1 } )
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
		Runtime:removeEventListener("key", onKeyEvent)
		composer.removeScene( "game" )
		audio.stop(1)
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose(correctSound)
	audio.dispose(incorrectSound)
	audio.dispose(finishSound)
	audio.dispose(musicTrack)
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
