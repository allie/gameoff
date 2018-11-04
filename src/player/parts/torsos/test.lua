--- Test torso
-- @classmod player.parts.torsos.test
-- @see player.parts.torso

local Torso = require('player.parts.torso')

local Test = {}
Test.__index = Test
setmetatable(Test, {__index = Torso})

--- Constructor
-- @return A new Test instance
function Test.new()
	local instance = Torso.new()

	instance:setSprite(love.graphics.newImage('assets/images/player/torsos/test.png'))
	instance.headAttachment.x = instance.size.w / 2 - 2
	instance.headAttachment.y = 8
	instance.legsAttachment.x = instance.size.w / 2 + 2
	instance.legsAttachment.y = instance.size.h - 1

	setmetatable(instance, Test)
	return instance
end

return Test
