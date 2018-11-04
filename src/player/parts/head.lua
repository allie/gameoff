--- Base class for head parts
-- @classmod player.parts.head
-- @see player.player

local Head = {}
Head.__index = Head

--- Constructor
-- @return A new Head instance
function Head.new()
	local instance = {}

	--- The graphic to render for the head
	-- @todo Animation states
	instance.sprite = nil

	--- The size of this part
	-- @field w Width
	-- @field h Height
	instance.size = {w=0, h=0}

	--- The position of this part, relative to its bounding box. This
	-- value is calculated in the Player class after all three body parts
	-- have been loaded.
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.position = {x=0, y=0}

	--- Attachment point for the torso part relative to the top left of the head's bounding box
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.torsoAttachment = {x=0, y=0}

	setmetatable(instance, Head)
	return instance
end

--- Set the sprite for this part
-- @param sprite An Image object
function Head:setSprite(sprite)
	self.sprite = sprite
	self.size.w = sprite:getWidth()
	self.size.h = sprite:getHeight()
end

--- Draw the head on the screen
-- @param x X offset
-- @param y Y offset
function Head:draw(x, y)
	if self.sprite == nil then
		return
	end

	love.graphics.draw(self.sprite, x + self.position.x, y + self.position.y)
end

return Head
