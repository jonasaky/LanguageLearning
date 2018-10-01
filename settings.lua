
local composer = require( "composer" )

local scene = composer.newScene()

local loadsave = require("loadsave")
playerData = loadsave.loadTable("playerData.json")
settingsData = loadsave.loadTable("settingsData.json")

local widget = require( "widget" )
local notifications = require( "plugin.notifications.v2" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local musicTrack

local nickNameField

local function textListener( event )

	if ( event.phase == "began" ) then
		-- User begins editing "defaultBox"

	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		-- Output resulting text from "defaultBox"
		print( "ended:".. event.target.text )

	elseif ( event.phase == "editing" ) then
		print( event.newCharacters )
		print( event.oldText )
		print( event.startPosition )
		print( event.text )
		playerData.username = event.text
	end
end

-- local function gotoMenu()
	
-- 	loadsave.saveTable(playerData, "playerData.json")
--     composer.gotoScene( "menu", { time=600, effect="crossFade" } )
-- end

local function buttonHandler( event )

	if (event.phase == "began") then  
	
		event.target.xScale = 0.85 -- Scale the button on touch down so user knows its pressed
		event.target.yScale = 0.85
	
	elseif (event.phase == "moved") then
	
		--something
	
	elseif (event.phase == "ended" or event.phase == "cancelled") then
		
		event.target.xScale = 1 -- Re-scale the button on touch release 
		event.target.yScale = 1

		loadsave.saveTable(playerData, "playerData.json")
		loadsave.saveTable(settingsData, "settingsData.json")
		composer.gotoScene( "menu", { time=400, effect="zoomInOutFade" } )
		
	end
	
	return true
	
end 

-- Handle press events for the checkbox
local function onSwitchPress( event )
	local switch = event.target
	print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
	if (switch.isOn) then		
		audio.setVolume(0.7)
	else
		audio.setVolume(0)
	end
	settingsData.isVolumeOn = switch.isOn	
end

local function onReminderSwitchPress( event )
	local switch = event.target
	print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
	if (switch.isOn) then
		print("activating reminders manually by settings")		
		local options = {
			alert = "This is daily reminder!"
		}
		local utcTime = os.date( "!*t" )
		for i = 1, 7 do
			utcTime.day = utcTime.day + i
			notifications.scheduleNotification( utcTime, options )
		end
		-- for k,v in pairs(utcTime) do
		-- 	print( k,v )
		-- end
	else
		print("cancelling all reminders")
		notifications.cancelNotification()
	end
	settingsData.isReminderOn = switch.isOn	
end

local function resettingDifficultHandler(event)
	loadsave.saveTable({}, "difficultWords.json")
	local clearedText = display.newText(sceneGroup, "cleared!", display.contentCenterX, 370, "Segoe UI", 16)
	clearedText:setFillColor(0.8,0.4,0.1)
	transition.to(clearedText, { time = 1000, alpha = 0 })
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
    
	-- local settingsText = display.newText(sceneGroup, "Settings", display.contentCenterX, 0, "CHOWFUN_.ttf", 40)
	-- local gradient = {
	-- 	type="gradient",
	-- 	color1={ 0.8,0.3,0.1 }, color2={ 0.8, 0.6, 0.1 }, direction="down"
	-- }
	-- settingsText:setFillColor(gradient)
	local settingsText = display.newImageRect(sceneGroup, "title_settings.png", 156,53)
	settingsText.x = display.contentCenterX

	local nickNameLabel = display.newText(sceneGroup, "Your nickname:", display.contentCenterX, 50, "CHOWFUN_.ttf", 24)
	nickNameLabel:setFillColor(0.8,0.4,0.1)
	
	-- Create text field
	local customFont = native.newFont( "CHOWFUN_.ttf", 16 )
	nickNameField = native.newTextField( display.contentCenterX, 90, 180, 30 )
	-- nickNameField.hasBackground = false
	-- nickNameField:setTextColor( 0.8, 0.8, 0.8 )
	nickNameField:addEventListener( "userInput", textListener )
	nickNameField.text = playerData.username
	nickNameField.font = customFont
	sceneGroup:insert(nickNameField)

	local volumeText = display.newText(sceneGroup, "Volume:", display.contentCenterX, 150, "CHOWFUN_.ttf", 24 )
	volumeText:setFillColor(0.8,0.4,0.1)
	
	-- Image sheet options and declaration
	local options = {
		width = 100,
		height = 100,
		numFrames = 2,
		sheetContentWidth = 200,
		sheetContentHeight = 100
	}
	local checkboxSheet = graphics.newImageSheet( "widget-radio-checkbox.png", options )

	local onOffVolume = widget.newSwitch(
		{
			left = display.contentCenterX - 30,
			top = 160,
			style = "checkbox",
			id = "volumeCheckbox",
			width = 70,
			height = 70,
			frameOff = 1,
			frameOn = 2,
			onPress = onSwitchPress,
			sheet = checkboxSheet,
			initialSwitchState = settingsData.isVolumeOn
		}
	)
	sceneGroup:insert(onOffVolume)

	local resetDifficultText = display.newText(sceneGroup, "Clear the review words?", display.contentCenterX, 250, "CHOWFUN_.ttf", 24)
	resetDifficultText:setFillColor(0.8,0.4,0.1)
			
	local resetDifficultWordButton = widget.newButton(
		{
			label = "Yes",
			labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
			onEvent = resettingDifficultHandler,
			emboss = false,
			shape = "rect",
			width = 80,
			height = 36,
			cornerRadius = 2,
			fillColor = { default={ 0.8, 0.4, 0.1, 0.5 }, over={ 0.8, 0.4, 0.1, 1 } },
			strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
			strokeWidth = 1
		}
	)
	resetDifficultWordButton.x, resetDifficultWordButton.y = display.contentCenterX, 290
	sceneGroup:insert(resetDifficultWordButton)

	local dailyReminderText = display.newText(sceneGroup, "Daily reminder?", display.contentCenterX, 350, "CHOWFUN_.ttf", 24)
	dailyReminderText:setFillColor(0.8,0.4,0.1)

	local onOffReminder = widget.newSwitch(
		{
			left = display.contentCenterX - 30,
			top = 360,
			style = "checkbox",
			id = "reminderCheckbox",
			width = 70,
			height = 70,
			frameOff = 1,
			frameOn = 2,
			onPress = onReminderSwitchPress,
			sheet = checkboxSheet,
			initialSwitchState = settingsData.isReminderOn 
		}
	)
	sceneGroup:insert(onOffReminder)

	-- local goBackButton = display.newText(sceneGroup, "Save changes", display.contentCenterX, display.contentHeight, "CHOWFUN_.ttf", 30)
	-- goBackButton:setFillColor(0.8,0.4,0.1)
	local goBackButton = display.newImageRect(sceneGroup, "btn_saveChanges.png", 176, 44)
	goBackButton.x, goBackButton.y = display.contentCenterX, display.contentHeight

	goBackButton:addEventListener("touch", buttonHandler)
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
		display.remove(nickNameField)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "settings" )
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
