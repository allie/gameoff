--- Test level
-- @classmod level.levels.test
-- @see level.level

local Level = require('level.level')

local Test = {}
Test.__index = Test
setmetatable(Test, {__index = Level})

--- Constructor
-- @param player The Player object to use for this level
-- @return A new Test instance
function Test.new(player)
	local instance = Level.new(player, 'assets/levels/test/test.lua')

	instance:setBackground(love.graphics.newImage('assets/levels/test/bg.png'), 0, -200, 0.5)

	setmetatable(instance, Test)
	return instance
end

return Test
