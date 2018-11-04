--- Base class for leg parts
-- @classmod player.parts.legs
-- @see player.player

local Legs = {}
Legs.__index = Legs

--- Constructor
-- @return A new Legs instance
function Legs.new()
	local instance = {}

	--- The graphic to render for the legs
	-- @todo Animation states
	instance.sprite = nil

	--- The size of this part
	-- @field w Width
	-- @field h Height
	instance.size = {w=0, h=0}

	--- Attachment point for the torso part relative to the top left of the legs' bounding box
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.torsoAttachment = {x=0, y=0}

	setmetatable(instance, Legs)
	return instance
end

--- Set the sprite for this part
-- @param sprite An Image object
function Legs:setSprite(sprite)
	self.sprite = sprite
	self.size.w = sprite:getWidth()
	self.size.h = sprite:getHeight()
end

--- Draw the legs on the screen
-- @param x X coordinate
-- @param y Y coordinate
function Legs:draw(x, y)
	if self.sprite == nil then
		return
	end

	love.graphics.draw(self.sprite, x, y)
end

return Legs
