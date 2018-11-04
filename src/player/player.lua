--- The main character of the game
-- @classmod player.player

local Gameobject = require('core.gameobject')

local Player = {}
Player.__index = Player
setmetatable(Player, {__index = Gameobject})

--- Constructor
-- @return A new Player instance
function Player.new()
	local instance = Gameobject.new()

	--- The player's head; an object inheriting player.parts.head
	-- @see player.parts.head
	instance.head = nil

	--- The player's torso; an object inheriting player.parts.torso
	-- @see player.parts.torso
	instance.torso = nil

	--- The player's legs; an object inheriting player.parts.legs
	-- @see player.parts.legs
	instance.legs = nil

	--- The player's current animation state
	instance.state = 'idle'

	--- The player's health state
	-- @field total Total health, including bonuses from torso, etc.
	-- @field current Current health
	instance.health = {total=10, current=10}

	setmetatable(instance, Player)
	return instance
end

--- Set the head of the player's body. If there are three parts present,
-- the AABB and relative part positions will be recalculated.
-- @param head An object inheriting player.parts.head
function Player:setHead(head)
	self.head = head

	if self.torso ~= nil and self.legs ~= nil then
		self:adjustAABB()
	end
end

--- Set the torso of the player's body. If there are three parts present,
-- the AABB and relative part positions will be recalculated.
-- @param torso An object inheriting player.parts.torso
function Player:setTorso(torso)
	self.torso = torso

	if self.head ~= nil and self.legs ~= nil then
		self:adjustAABB()
	end
end

--- Set the legs of the player's body. If there are three parts present,
-- the AABB and relative part positions will be recalculated.
-- @param legs An object inheriting player.parts.legs
function Player:setLegs(legs)
	self.legs = legs

	if self.torso ~= nil and self.head ~= nil then
		self:adjustAABB()
	end
end

--- Recalculate the player's AABB
function Player:adjustAABB()
	local left = {0}
	local top = {0}
	local right = {0}
	local bottom = {0}

	-- Treat the top-left of the head as (0,0)
	-- Calculate the x coordinate of the torso, record left and right
	local tx = self.head.torsoAttachment.x - self.torso.headAttachment.x
	table.insert(left, tx)
	table.insert(right, tx + self.torso.size.w)

	-- Calculate the y coordinate of the torso, record top and bottom
	local ty = self.head.torsoAttachment.y - self.torso.headAttachment.y
	table.insert(top, ty)
	table.insert(bottom, ty + self.torso.size.h)

	-- Calculate the x coordinate of the legs, record left and right
	local lx = tx + self.torso.legsAttachment.x - self.legs.torsoAttachment.x
	table.insert(left, lx)
	table.insert(right, lx + self.legs.size.w)

	-- Calculate the y coordinate of the legs, record top and bottom
	local ly = ty + self.torso.legsAttachment.y - self.legs.torsoAttachment.y
	table.insert(top, ly)
	table.insert(bottom, ly + self.legs.size.h)

	-- Find the outermost bounds of all the recorded values
	table.sort(left)
	table.sort(top)
	table.sort(right)
	table.sort(bottom)

	local bounds = {
		left=left[1],
		top=top[1],
		right=right[#right],
		bottom=bottom[#bottom]
	}

	-- Use the calculated bounds to build the final AABB. Keep x and y in the same spot, but adjust the dimensions
	self.aabb.w = bounds.right - bounds.left
	self.aabb.h = bounds.bottom - bounds.top

	-- Update the relative positions of each body part
	self.head.position.x = math.abs(bounds.left)
	self.head.position.y = math.abs(bounds.top)
	self.torso.position.x = self.head.position.x + tx
	self.torso.position.y = self.head.position.y + ty
	self.legs.position.x = self.head.position.x + lx
	self.legs.position.y = self.head.position.y + ly
end

--- Move the character by the specified x and y deltas
-- @param dx X position delta
-- @param dy Y position delta
-- @param dt Delta time
function Player:move(dx, dy, dt)

end

--- Draw the player on the screen
-- @todo Incorporate camera coords
function Player:draw()
	self.legs:draw(self.aabb.x, self.aabb.y) 
	self.torso:draw(self.aabb.x, self.aabb.y)
	self.head:draw(self.aabb.x, self.aabb.y)
end

return Player
