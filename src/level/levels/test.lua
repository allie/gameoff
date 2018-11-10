--- Test level
-- @classmod level.levels.test
-- @see level.level

local Level = require('level.level')
local Background = require('core.background')

local Test = {}
Test.__index = Test
setmetatable(Test, {__index = Level})

--- Constructor
-- @param player The Player object to use for this level
-- @return A new Test instance
function Test.new(player)
	local instance = Level.new(player, 'assets/levels/test/test.lua')

	instance.bg = Background.new({
		'assets/levels/test/bg/1.png',
		'assets/levels/test/bg/2.png',
		'assets/levels/test/bg/3.png',
		'assets/levels/test/bg/4.png',
		'assets/levels/test/bg/5.png'
	}, 100, 6, 0, -100)

	instance.bg:autoscroll(5, 5, 'right')

	setmetatable(instance, Test)
	return instance
end

return Test
