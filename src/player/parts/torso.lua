--- Base class for torso parts
-- @classmod player.parts.torso
-- @see player.player

local Torso = {}
Torso.__index = Torso

--- Constructor
-- @return A new Torso instance
function Torso.new()
	local self = setmetatable({}, Torso)
	-- Initialize instance variables
	return self
end

return Torso
