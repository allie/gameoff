--- The main character of the game
-- @classmod player.player

local Player = {}
Player.__index = player

--- The player's head; an object inheriting player.parts.head
-- @see player.parts.head
Player.head = nil

--- The player's torso; an object inheriting player.parts.torso
-- @see player.parts.torso
Player.torso = nil

--- The player's legs; an object inheriting player.parts.legs
-- @see player.parts.legs
Player.legs = nil

--- The player's current position
-- @field x X coordinate
-- @field y Y coordinate
Player.position = {x=0, y=0}

--- The player's current velocity
-- @field x X velocity
-- @field y Y velocity
Player.velocity = {x=0, y=0}

--- The player's current animation state
-- @field state
Player.state = 'idle'

--- Constructor
-- @return A new Player instance
function Player.new()
	local self = setmetatable({}, Player)

	-- Initialize instance variables
	self.position = {x=0, y=0}
	self.velocity = {x=0, y=0}
	self.state = 'idle'

	-- Load some body parts
	self.head = TestHead.new()
	self.torso = TestTorso.new()
	self.legs = TestTorso.new()

	return self
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

return Player
