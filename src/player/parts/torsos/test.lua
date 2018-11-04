--- Test torso
-- @classmod player.parts.torsos.test
-- @see player.parts.torso

local Torso = require('player.parts.torso')

local Test = Torso.new()
Test.__index = Test

--- Constructor
-- @return A new Test instance
function Test.new()
	local self = setmetatable({}, Test)
	-- Initialize instance variables
	return self
end

return Test
