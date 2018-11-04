--- Test legs
-- @classmod player.parts.legs.test
-- @see player.parts.legs

local Legs = require('player.parts.legs')

local Test = Legs.new()
Test.__index = Test

--- Constructor
-- @return A new Test instance
function Test.new()
	local self = setmetatable({}, Test)
	-- Initialize instance variables
	return self
end

return Test
