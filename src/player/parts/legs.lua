--- Base class for leg parts
-- @classmod player.parts.legs
-- @see player.player

local Legs = {}
Legs.__index = {}

--- Constructor
-- @return A new Legs instance
function Legs.new()
	local self = setmetatable({}, Legs)
	-- Initialize instance variables
	return self
end

return Legs
