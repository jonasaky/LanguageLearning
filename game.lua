
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local mainGroup
local question, optionA, optionB, optionC, optionD, finishButton, correct, answer, answerText
local randomOrder = {}
local optionsTable = 
{
	{
		image = "apple.png",
		answer = "Apple",
		question = "りんご"
	},
	{
		image = "orange.png",
		answer = "Orange",
		question = "オレンジ"
	},
	{
		image = "melon.png",
		answer = "Melon",
		question = "メロン"
	},
	{
		image = "ballpen.png",
		answer = "Ballpen",
		question = "ボールペン"
	},
	{
		image = "flower.png",
		answer = "Flower",
		question = "はな"
	},
	{
		image = "tree.png",
		answer = "Tree",
		question = "き"
	},
	{
		image = "hair.png",
		answer = "Hair",
		question = "かみ"
	},
	{
		image = "head.png",
		answer = "Head",
		question = "あたま"
	},
	{
		image = "stomach.png",
		answer = "Stomach",
		question = "おなか"
	},
	{
		image = "glasses.png",
		answer = "Glasses",
		question = "めがね"
	},
	{
		image = "leg.png",
		answer = "Foot, leg",
		question = "足（あし）"
	}
}
local total = #optionsTable
local maxNumber = total
local answersTable = optionsTable


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

local function createQuestion()

	display.remove ( correct )

	local i = 1
	local answersDisplayed = {}
	while i <= 4 do
		local n = math.random(maxNumber)
		if (has_value(answersDisplayed, n) == false) and n ~= total then
			table.insert(answersDisplayed,n)
			i = i + 1
		end
	end

	question.text = optionsTable[total].question
	question:setFillColor( .5, 1, 1)
	
	local order = math.random(4)
	
	optionA.text = optionsTable[answersDisplayed[1]].answer
	optionB.text = optionsTable[answersDisplayed[2]].answer
	optionC.text = optionsTable[answersDisplayed[3]].answer
	optionD.text = optionsTable[answersDisplayed[4]].answer

	if order == 1 then
		optionA.text = optionsTable[total].answer
		optionA.isCorrect = true
	elseif order == 2 then
		optionB.text = optionsTable[total].answer
		optionB.isCorrect = true
	elseif order == 3 then
		optionC.text = optionsTable[total].answer
		optionC.isCorrect = true
	else
		optionD.text = optionsTable[total].answer
		optionD.isCorrect = true
	end

	answerText = optionsTable[total].answer

	total = total - 1
end

local function evaluateAnswer( event )
	

	if event.target.isCorrect then
		correct = display.newText( mainGroup, "Correct!", display.contentCenterX + 90, event.target.y, native.systemFont, 20)
		correct:setFillColor( .2,1,0)

		if total == 0 then
			finishButton.isVisible = true
		else
			timer.performWithDelay( 100, createQuestion )
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
	
	local description = display.newText( mainGroup, "Choose the correct translation", display.contentCenterX, 30, 300, 0, native.systemFont, 16 )

	finishButton = display.newText( mainGroup, "Finish" , display.contentCenterX, 480, native.systemFont, 20 )	
	finishButton:setFillColor( .6,.6,1 )
	finishButton.isVisible = false

	shuffling(optionsTable)

	for i = 1, #optionsTable do 
		print(optionsTable[i].answer)
	end

	question = display.newText( mainGroup, "", display.contentCenterX, 120, native.systemFont, 60 )
	question:setFillColor( .5, 1, 1)
	
	optionA = display.newText( mainGroup, "" , display.contentCenterX, 280, native.systemFont, 20 )	
	optionB = display.newText( mainGroup, "" , display.contentCenterX, 330, native.systemFont, 20 )	
	optionC = display.newText( mainGroup, "" , display.contentCenterX, 380, native.systemFont, 20 )	
	optionD = display.newText( mainGroup, "" , display.contentCenterX, 430, native.systemFont, 20 )

	createQuestion()

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
