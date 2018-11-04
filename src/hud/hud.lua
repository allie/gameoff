--- HUD (heads up display)
-- @classmod hud.hud

local Health = require('hud.health')

local Hud = {}
Hud.__index = Hud

--- Constructor
-- @return A new Hud instance
function Hud.new()
	local instance = {}

	--- Canvas to draw the HUD to (in order to scale 2x later)
	instance.canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

	--- Health bar instance
	-- @see hud.health
	instance.health = Health.new()

	setmetatable(instance, Hud)
	return instance
end

--- Draw the HUD
function Hud:draw()
	love.graphics.setCanvas(self.canvas)
	self.health:draw(10, 10, 20)
	love.graphics.setCanvas()

	love.graphics.draw(self.canvas, 0, 0, 0, 2, 2)
end

return Hud
