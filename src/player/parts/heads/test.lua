--- Test head
-- @classmod player.parts.heads.test
-- @see player.parts.head

local Head = require('player.parts.head')

local Test = Head.new()
Test.__index = Test

--- Constructor
-- @return A new Test instance
function Test.new()
	local self = setmetatable({}, Test)
	-- Initialize instance variables
	return self
end

return Test
