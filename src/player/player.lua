--- The main character of the game
-- @classmod player.player

local Player = {}
Player.__index = Player

--- Constructor
-- @return A new Player instance
function Player.new()
	local instance = {}

	--- The player's head; an object inheriting player.parts.head
	-- @see player.parts.head
	instance.head = nil

	--- The player's torso; an object inheriting player.parts.torso
	-- @see player.parts.torso
	instance.torso = nil

	--- The player's legs; an object inheriting player.parts.legs
	-- @see player.parts.legs
	instance.legs = nil

	--- The player's current position
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.position = {x=100, y=100}

	--- The player's current velocity
	-- @field x X velocity
	-- @field y Y velocity
	instance.velocity = {x=0, y=0}

	--- The player's current animation state
	instance.state = 'idle'

	--- The player's health state
	-- @field total Total health, including bonuses from torso, etc.
	-- @field current Current health
	instance.health = {total=10, current=10}

	--- The player's weight
	instance.weight = 20

	setmetatable(instance, Player)
	return instance
end

--- Set the head of the player's body
-- @param head An object inheriting player.parts.head
function Player:setHead(head)
	self.head = head
end

--- Set the torso of the player's body
-- @param torso An object inheriting player.parts.torso
function Player:setTorso(torso)
	self.torso = torso
end

--- Set the legs of the player's body
-- @param legs An object inheriting player.parts.legs
function Player:setLegs(legs)
	self.legs = legs
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
	local tx = self.position.x + self.head.torsoAttachment.x - self.torso.headAttachment.x
	local ty = self.position.y + self.head.torsoAttachment.y - self.torso.headAttachment.y
	local lx = tx + self.torso.legsAttachment.x - self.legs.torsoAttachment.x
	local ly = ty + self.torso.legsAttachment.y - self.legs.torsoAttachment.y
	self.legs:draw(lx, ly) 
	self.torso:draw(tx, ty)
	self.head:draw(self.position.x, self.position.y)
end

return Player
