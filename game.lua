
local composer = require( "composer" )

local scene = composer.newScene()

local loadsave = require("loadsave")
playerData = loadsave.loadTable("playerData.json")
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

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

local centiSecondsLeft = 1*6000
local clockText
local minutes
local second
local centiSeconds

local function updateTime()

    minutes = math.floor(centiSecondsLeft/6000)
    seconds = math.floor((centiSecondsLeft-(minutes*6000))/100)
    centiSeconds =((centiSecondsLeft-(minutes*6000))%100)
	-- clockText.text = string.format("%02d:%02d:%02d", minutes, seconds, centiSeconds)
	clockText.text = string.format("%02d:%02d", seconds, centiSeconds)
	centiSecondsLeft = centiSecondsLeft - 1
	
	if centiSecondsLeft == 0 then
		-- display.remove(clockText)
		-- display.remove(question)
		-- display.remove(optionA)
		-- display.remove(optionB)
		-- display.remove(optionC)
		-- display.remove(optionD)
		-- display.remove(scoreText)
		-- display.remove(scoreGoodText)
		-- display.remove(badScoreText)
		display.remove(mainGroup)
		audio.play(finishSound)
		local resultTitle = display.newText(backGroup, "Great job!", display.contentCenterX, 100, display.contentWidth - 100, 0, "CHOWFUN_.ttf", 28)
		resultTitle:setFillColor(0.8,0.4,0.1)
		local scoreResult = display.newText(backGroup, "Your score is " .. score, display.contentCenterX, 160, "CHOWFUN_.ttf", 36)
		scoreResult:setFillColor(0.8,0.4,0.1)

		if score > playerData.scores[1] then
			resultTitle.text = "New highscore!"
			playerData.scores[categoryNumber] = score
			loadsave.saveTable(playerData, "playerData.json")
		end
		finishButton.isVisible = true
	end

	progressBar.width = progressBar.width - 0.054

end

local function joinTables(t1, t2)

	for k,v in ipairs(t2) do
	   table.insert(t1, v)
	end 
 
	return t1
 end

local function loadWords()
	local category = composer.getVariable( "selectedCategory" )
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

-- local function goToMenu()
-- 	composer.gotoScene("menu", { time=800, effect="crossFade" } )
-- end	

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

local function evaluateAnswer( event )
	

	if event.target.isCorrect then
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

		-- correct = display.newText( mainGroup, "✔", event.target.x + 40, event.target.y, native.systemFont, 24)
		-- correct:setFillColor( .2,1,0)

		if total == 0 then
			finishButton.isVisible = true
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
		
		-- local incorrectText = display.newText( mainGroup, "✘", event.target.x + 40, event.target.y, native.systemFont, 24)
		-- incorrectText:setFillColor( 1, 0,0)
		-- timer.performWithDelay( 500, function() display.remove(incorrectText) end )
		
	end

end

local function buttonHandler( event )

	if (event.phase == "began") then  
	
		event.target.xScale = 0.85 -- Scale the button on touch down so user knows its pressed
		event.target.yScale = 0.85
	
	elseif (event.phase == "moved") then
	
		--something
	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		event.target.xScale = 1 -- Re-scale the button on touch release 
		event.target.yScale = 1

		if event.target.id == "finish" then
			composer.gotoScene( "menu", { time=400, effect="zoomInOutFade" } )
		else
			evaluateAnswer(event)
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
	-- loadsave.saveTable(wordsTable, "words.json")
	backGroup = display.newGroup()
	mainGroup = display.newGroup()
	sceneGroup:insert( backGroup ) 
	sceneGroup:insert( mainGroup ) 

	-- local background = display.newImageRect(mainGroup, "background.png", 950, 1425) -- add a background
    -- 	background.x = math.floor(display.contentWidth / 2)
	-- 	background.y = math.floor( display.contentHeight / 2)
	local backcolor = display.newRect( backGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight + 100 )
	backcolor:setFillColor( 1, 0.85, 0.6 )

	progressBar = display.newRect(mainGroup, 0, 0, display.contentWidth, 5)
	progressBar.anchorX = 0
	progressBar:setFillColor(1,0.2,0.2)
	
	timer.performWithDelay(10, updateTime, centiSecondsLeft)
	clockText = display.newText(mainGroup, "", display.contentCenterX, 10, native.systemFont, 40)
	clockText.isVisible = false

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
	loadWords()
	shuffling(wordsTable)
	
	-- for i = 1, #wordsTable do 
	-- 	print(wordsTable[i].english)
	-- end

	total = #wordsTable

	hintText = display.newText( mainGroup, "", display.contentCenterX, 90, native.systemFont, 18)
	hintText:setFillColor(0.8,0.4,0.1)
	local options = 
	{
		parent = mainGroup,
		text = "",     
		x = display.contentCenterX,
		y = 120,
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
		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose(correctSound)
	audio.dispose(incorrectSound)
	audio.dispose(finishSound)
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
