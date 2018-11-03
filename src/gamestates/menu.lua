local menu = {}
menu.__index = menu

function menu:init()
	self.boy = love.graphics.newImage('assets/images/boy.png')
	self.music = love.audio.newSource('assets/audio/test.mp3', 'stream')
end

function menu:enter()
	love.audio.play(self.music)
end

function menu:draw()
	love.graphics.draw(self.boy, 0, 0)
end

function menu:update(dt)

end

return menu
