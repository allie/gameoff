--- Main menu game state
-- @module gamestates.mainmenu

local Background = require('core.background')
local ScreenTransition = require('core.screentransition')

local MainMenu = {}
MainMenu.__index = MainMenu

function MainMenu:init()
	self.itemsStart = love.graphics.getHeight() / 2
	self.itemSize = 64
	self.itemSpacing = 16
	self.itemFont = love.graphics.newFont('assets/fonts/KiwiSoda.ttf', self.itemSize)
	self.itemFont:setFilter('nearest', 'nearest', 1)

	self.titleSize = 128
	self.titleFont = love.graphics.newFont('assets/fonts/KiwiSoda.ttf', self.titleSize)
	self.titleFont:setFilter('nearest', 'nearest', 1)

	self.title = 'GameOff'
	self.menuItems = {
		'Play',
		'Options'
	}

	self.titleColour = {0/255, 255/255, 120/255}
	self.itemColour = {255/255, 255/255, 255/255}
	self.selectedItem = 1

	self.bg = Background.new({
		'assets/images/menu/bg/1.png',
		'assets/images/menu/bg/2.png',
		'assets/images/menu/bg/3.png'
	}, 100, 6, 0, -100)

	self.bg:autoscroll(2, 1, 'right')
	self.bg:autoscroll(3, 2, 'right')

	self.fadein = nil
	self.fadeout = nil

	-- Globals.sound:startTrack('menu')
end

function MainMenu:enter()
	self.fadein = ScreenTransition.new('fadein', 0.5)
end

function MainMenu:draw()
	-- Draw the background
	self.bg:draw()

	-- Draw the game title
	love.graphics.setColor(unpack(self.titleColour))
	love.graphics.setFont(self.titleFont);
	love.graphics.printf(
		self.title,
		0,
		100,
		love.graphics.getWidth(),
		'center'
	)

	-- Draw the menu items
	love.graphics.setFont(self.itemFont);
	for i, item in ipairs(self.menuItems) do
		love.graphics.setColor(unpack(self.itemColour))

		local str = item
		if self.selectedItem == i then
			str = '> ' .. item .. ' <'
		end

		love.graphics.printf(
			str,
			0,
			self.itemsStart + (self.itemSize + self.itemSpacing) * (i - 1),
			love.graphics.getWidth(),
			'center'
		)
	end

	-- Draw fade in if necessary
	if self.fadein ~= nil and not self.fadein.finished then
		self.fadein:draw()
	else
		self.fadein = nil
	end

	-- Draw fade out if necessary
	if self.fadeout ~= nil and not self.fadeout.finished then
		self.fadeout:draw()
	end
end

--- Enter the game state associated with the current menu option
function MainMenu:enterMenuItem()
	if self.menuItems[self.selectedItem] == 'Play' then
		self.nextState = Globals.gamestates.play
	end

	self.fadeout = ScreenTransition.new('fadeout', 0.5)
end

--- Update the main menu
-- @param dt Delta time
function MainMenu:update(dt)
	if self.fadeout ~= nil then
		if self.fadeout.finished then
			self.fadeout = nil
			Gamestate.switch(self.nextState)
		else
			return
		end
	end

	-- Select the highlighted menu item
	if Globals.input:wasActivated('a') or Globals.input:wasActivated('start') then
		Globals.sound:play('ui-select')
		self:enterMenuItem()

	-- Move cursor up
	elseif Globals.input:wasActivated('up') then
		Globals.sound:play('ui-move')
		self.selectedItem = self.selectedItem - 1
		if self.selectedItem < 1 then
			self.selectedItem = #self.menuItems
		end

	-- Move cursor down
	elseif Globals.input:wasActivated('down') then
		Globals.sound:play('ui-move')
		self.selectedItem = self.selectedItem + 1
		if self.selectedItem > #self.menuItems then
			self.selectedItem = 1
		end
	end
end

return MainMenu
