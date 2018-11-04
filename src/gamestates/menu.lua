--- Main menu game state
-- @module gamestates.menu

local Menu = {}
Menu.__index = menu

function Menu:init()
	self.boy = love.graphics.newImage('assets/images/boy.png')
	self.music = love.audio.newSource('assets/audio/test.mp3', 'stream')
end

function Menu:enter()
	love.audio.play(self.music)
end

function Menu:draw()
	love.graphics.draw(self.boy, 0, 0)
end

function Menu:update(dt)

end

return Menu
