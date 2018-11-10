--- Main menu game state
-- @module gamestates.mainmenu

local Background = require('core.background')

local Menu = {}
Menu.__index = Menu

function Menu:init()
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
end

function Menu:enter()

end

function Menu:draw()
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
end

function Menu:update(dt)

end

return Menu
