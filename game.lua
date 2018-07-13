
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local mainGroup
local question, optionA, optionB, optionC, optionD, nextButton, correct, answer, answerText
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
	}
}
local total = #optionsTable
local maxNumber = total
local answersTable = optionsTable

local function evaluateAnswer( event )
	optionA:removeEventListener( "tap", evaluateAnswer)
	optionB:removeEventListener( "tap", evaluateAnswer)
	optionC:removeEventListener( "tap", evaluateAnswer)
	optionD:removeEventListener( "tap", evaluateAnswer)

	if event.target.isCorrect then
		correct = display.newText( mainGroup, "Correct!", display.contentCenterX + 80, event.target.y, native.systemFont, 20)
		correct:setFillColor( .2,1,0)
	else
		correct = display.newText( mainGroup, "Incorrect!", display.contentCenterX+ 80, event.target.y, native.systemFont, 20)
		correct:setFillColor( 1, 0,0)
		answer = display.newText( mainGroup, answerText, display.contentCenterX, 70, native.systemFont, 20)
		answer:setFillColor( .2,1,0)
	end

	if total == 0 then
		nextButton.text = "Finish"
	end
		
	nextButton.isVisible = true
	
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

local function createQuestion()
	if total == 0 then
		return goToMenu()
	end	

	display.remove(question)
	display.remove( optionA)
	display.remove( optionB )
	display.remove( optionC )
	display.remove( optionD )
	display.remove ( correct)
	display.remove ( answer)
	nextButton.isVisible = false

	-- local j = 1
	-- while (j <= maxNumber) do
	-- 	local random1 = math.random(maxNumber)
	-- 	local random2 = math.random(maxNumber)
	-- 	optionsTable[random1], optionsTable[random2] = optionsTable[random2], optionsTable[random1]
	-- 	j = j + 1
	-- end

	-- print("random number "..randomOrder[1])

	local i = 1
	local orderDisplayed = {}
	while i <= 3 do
		local n = math.random(maxNumber)
		if (has_value(orderDisplayed, n) == false) and n ~= randomOrder[1] then
			-- if (has_value(orderDisplayed, randomOrder[1]) == false) then
				table.insert(orderDisplayed,n)
				i = i + 1
			-- end
		end
	end

			-- if (has_value(orderDisplayed, randomOrder[1]) == false) then
			-- 	print("false")
			-- else
			-- 	print("true")
			-- end

	-- for i = 1, #randomOrder, 1 do 

	-- 	print("random"..randomOrder[i])
	-- end


	question = display.newText( mainGroup, optionsTable[randomOrder[1]].question, display.contentCenterX, 120, native.systemFont, 60 )
	question:setFillColor( .5, 1, 1)
	
	local order = math.random(3)
	
	if order == 1 then
		optionA = display.newText( mainGroup, optionsTable[randomOrder[1]].answer , display.contentCenterX, 280, native.systemFont, 20 )	
		optionB = display.newText( mainGroup, optionsTable[orderDisplayed[1]].answer , display.contentCenterX, 330, native.systemFont, 20 )	
		optionC = display.newText( mainGroup, optionsTable[orderDisplayed[2]].answer , display.contentCenterX, 380, native.systemFont, 20 )	
		optionD = display.newText( mainGroup, optionsTable[orderDisplayed[3]].answer , display.contentCenterX, 430, native.systemFont, 20 )
		
	elseif order == 2 then
		optionA = display.newText( mainGroup, optionsTable[orderDisplayed[1]].answer , display.contentCenterX, 280, native.systemFont, 20 )	
		optionB = display.newText( mainGroup, optionsTable[randomOrder[1]].answer , display.contentCenterX, 330, native.systemFont, 20 )	
		optionC = display.newText( mainGroup, optionsTable[orderDisplayed[2]].answer , display.contentCenterX, 380, native.systemFont, 20 )	
		optionD = display.newText( mainGroup, optionsTable[orderDisplayed[3]].answer , display.contentCenterX, 430, native.systemFont, 20 )
		
	elseif order == 3 then
		optionA = display.newText( mainGroup, optionsTable[orderDisplayed[1]].answer , display.contentCenterX, 280, native.systemFont, 20 )	
		optionB = display.newText( mainGroup, optionsTable[orderDisplayed[2]].answer , display.contentCenterX, 330, native.systemFont, 20 )	
		optionC = display.newText( mainGroup, optionsTable[randomOrder[1]].answer , display.contentCenterX, 380, native.systemFont, 20 )	
		optionD = display.newText( mainGroup, optionsTable[orderDisplayed[3]].answer , display.contentCenterX, 430, native.systemFont, 20 )
		
	end
	--print(order)
	-- optionA = display.newText( mainGroup, "A)" .. optionsTable[orderDisplayed[1]].answer , display.contentCenterX, 300, native.systemFont, 16 )	
	-- optionB = display.newText( mainGroup, "B)" .. optionsTable[orderDisplayed[2]].answer , display.contentCenterX, 340, native.systemFont, 16 )	
	-- optionC = display.newText( mainGroup, "C)" .. optionsTable[orderDisplayed[3]].answer , display.contentCenterX, 380, native.systemFont, 16 )	
	-- optionD = display.newText( mainGroup, "D)" .. optionsTable[orderDisplayed[4]].answer , display.contentCenterX, 420, native.systemFont, 16 )

	answerText = optionsTable[randomOrder[1]].answer
	if order == 1 then
		optionA.isCorrect = true
	elseif order == 2 then
		optionB.isCorrect = true		
	elseif order == 3 then
		optionC.isCorrect = true
	end

	optionA:addEventListener( "tap", evaluateAnswer)
	optionB:addEventListener( "tap", evaluateAnswer)
	optionC:addEventListener( "tap", evaluateAnswer)
	optionD:addEventListener( "tap", evaluateAnswer)

	table.remove(randomOrder, 1)
	total = total - 1
	-- print("new value total" .. total)
	-- print("maxvalue" .. maxNumber)
	-- print(#answersTable)
	-- print(#optionsTable)
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

	nextButton = display.newText( mainGroup, "Next" , display.contentCenterX, 480, native.systemFont, 20 )	
	nextButton:setFillColor( .6,.6,1 )
	nextButton.isVisible = false

	local i = 1
	while i <= #optionsTable do
		local n = math.random(#optionsTable)
		if has_value(randomOrder, n) == false then
			table.insert(randomOrder,n)
			i = i + 1
		end
	end

	for i = 1, #randomOrder, 1 do 

		print(randomOrder[i])
	end


	createQuestion()

	nextButton:addEventListener( "tap", createQuestion )
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
