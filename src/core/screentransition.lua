--- A transition animation to play between game state changes
-- @classmod core.screentransition

local ScreenTransition = {}
ScreenTransition.__index = ScreenTransition

--- Constructor
-- @param type The type of transition to use
-- @param duration The duration of the transition
-- @return A new ScreenTransition instance
function ScreenTransition.new(type, duration)
	local instance = {}

	--- The type of transition this is
	instance.type = type

	--- The duration of the transition
	instance.duration = duration

	--- The elapsed time of the transition
	instance.timer = 0

	--- Whether or not the transition has been finished
	instance.finished = false

	-- Add self to the global updater
	Globals.updater:add(instance)

	setmetatable(instance, ScreenTransition)
	return instance
end

--- Update the screen transition
-- @param dt Delta time
function ScreenTransition:update(dt)
	self.timer = self.timer + dt

	if self.timer >= self.duration then
		self.finished = true
	end
end

--- Draw the transition
function ScreenTransition:draw()
	if self.type == 'fadein' then
		love.graphics.setColor(0, 0, 0, 1 - self.timer / self.duration)
		love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	elseif self.type == 'fadeout' then
		love.graphics.setColor(0, 0, 0, self.timer / self.duration)
		love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end
end

return ScreenTransition
