--- Base class for head parts
-- @classmod player.parts.head
-- @see player.player

local Head = {}
Head.__index = {}

--- Constructor
-- @return A new Head instance
function Head.new()
	local self = setmetatable({}, Head)
	-- Initialize instance variables
	return self
end

return Head
