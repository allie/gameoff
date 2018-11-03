local menu = {}
menu.__index = menu

function menu:init()
	self.boy = love.graphics.newImage('assets/images/boy.png')
end

function menu:enter()

end

function menu:draw()
	love.graphics.draw(self.boy, 0, 0)
end

function menu:update(dt)

end

return menu
