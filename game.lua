
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local mainGroup
local question, optionA, optionB, optionC, optionD, finishButton, correct, countDownText
local countDown = 60
local randomOrder = {}
local optionsTable = 
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
local total = #optionsTable

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

end

local function countDownHandle()
	countDown = countDown - 1
	countDownText.text = countDown

	if countDown == 0 then
		--show finish button and stop the game
	end
end

local function goToMenu()
	composer.gotoScene("menu", { time=800, effect="crossFade" } )
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
	for i = 1, 10 do
		local random1 = math.random(#tab)
		local random2 = math.random(#tab)
		tab[random1], tab[random2] = tab[random2], tab[random1]
	end
end

local function createQuestion(isEnglish)

	display.remove ( correct )
	optionA.isCorrect = false
	optionB.isCorrect = false
	optionC.isCorrect = false
	optionD.isCorrect = false

	local i = 1
	local answersDisplayed = {}
	while i <= 4 do
		local n = math.random(#optionsTable)
		if (has_value(answersDisplayed, n) == false) and n ~= total then
			table.insert(answersDisplayed,n)
			i = i + 1
		end
	end

	local answerText
	if isEnglish == 1 then
		answerText = optionsTable[total].japanese
		question.text = optionsTable[total].english
		optionA.text = optionsTable[answersDisplayed[1]].japanese
		optionB.text = optionsTable[answersDisplayed[2]].japanese
		optionC.text = optionsTable[answersDisplayed[3]].japanese
		optionD.text = optionsTable[answersDisplayed[4]].japanese
	else
		answerText = optionsTable[total].english
		question.text = optionsTable[total].japanese
		optionA.text = optionsTable[answersDisplayed[1]].english
		optionB.text = optionsTable[answersDisplayed[2]].english
		optionC.text = optionsTable[answersDisplayed[3]].english
		optionD.text = optionsTable[answersDisplayed[4]].english
	end
	
	question:setFillColor( .5, 1, 1)
	
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
		correct = display.newText( mainGroup, "Correct!", display.contentCenterX + 90, event.target.y, native.systemFont, 20)
		correct:setFillColor( .2,1,0)

		if total == 0 then
			finishButton.isVisible = true
		else
			timer.performWithDelay( 100, function() createQuestion(math.random(2)) end )
		end
		
	else
		local incorrectText = display.newText( mainGroup, "Incorrect!", display.contentCenterX + 90, event.target.y, native.systemFont, 20)
		incorrectText:setFillColor( 1, 0,0)
		timer.performWithDelay( 500, function() display.remove(incorrectText) end )
		
	end

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	mainGroup = display.newGroup() 
	sceneGroup:insert( mainGroup ) 
	
	countDownText = display.newText( mainGroup, countDown, display.contentWidth - 10, 10, native.systemFont, 20)
	timer.performWithDelay( 1000, countDownHandle, 60 )
	timer.performWithDelay(10, updateTime, centiSecondsLeft)
	clockText = display.newText(mainGroup, "", display.contentCenterX, 10, native.systemFont, 40)

	finishButton = display.newText( mainGroup, "Finish" , display.contentCenterX, 480, native.systemFont, 20 )	
	finishButton:setFillColor( .6,.6,1 )
	finishButton.isVisible = false

	shuffling(optionsTable)

	-- for i = 1, #optionsTable do 
	-- 	print(optionsTable[i].answer)
	-- end

	question = display.newText( mainGroup, "", display.contentCenterX, 120, native.systemFont, 60 )
	question:setFillColor( .5, 1, 1)
	
	optionA = display.newText( mainGroup, "" , display.contentCenterX, 280, native.systemFont, 20 )	
	optionB = display.newText( mainGroup, "" , display.contentCenterX, 330, native.systemFont, 20 )	
	optionC = display.newText( mainGroup, "" , display.contentCenterX, 380, native.systemFont, 20 )	
	optionD = display.newText( mainGroup, "" , display.contentCenterX, 430, native.systemFont, 20 )

	createQuestion(1)

	finishButton:addEventListener( "tap", goToMenu )

	optionA:addEventListener( "tap", evaluateAnswer)
	optionB:addEventListener( "tap", evaluateAnswer)
	optionC:addEventListener( "tap", evaluateAnswer)
	optionD:addEventListener( "tap", evaluateAnswer)
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
