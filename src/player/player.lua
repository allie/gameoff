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

	--- Canvas to render the whole body to
	instance.canvas = nil

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

	-- Current input state
	instance.input = {}

	-- Valid keys for handling input
	instance.validKeys = {
		['a'] = true,
		['d'] = true,
		['space'] = true,
		['left'] = true,
		['right'] = true
	}

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
	self.aabb.cx = math.floor(self.aabb.w / 2)
	self.aabb.cy = math.floor(self.aabb.h / 2)

	-- Update the relative positions of each body part
	self.head.position.x = math.abs(bounds.left)
	self.head.position.y = math.abs(bounds.top)
	self.torso.position.x = self.head.position.x + tx
	self.torso.position.y = self.head.position.y + ty
	self.legs.position.x = self.head.position.x + lx
	self.legs.position.y = self.head.position.y + ly

	-- Adjust the size of the canvas
	self.canvas = love.graphics.newCanvas(self.aabb.w, self.aabb.h)
end

--- Update the current input state
-- @param input The last pressed or released key
-- @param pressed Whether the key was pressed or released
function Player:updateInput(input, pressed)
	-- Return if this key isn't applicable
	if self.validKeys[input] == nil then
		return
	end

	-- Add pressed key to the input state if it's not there
	if pressed then
		for i, key in ipairs(self.input) do
			if key == input then
				return
			end
		end

		table.insert(self.input, input)

	-- Remove released key from the input state if it's there
	else
		for i = #self.input, 1, -1 do
			if self.input[i] == input then
				table.remove(self.input, i)
				return
			end
		end
	end
end

--- Update the player (handle input, etc.)
-- @param dt Delta time
-- @todo Add max velocity
function Player:update(dt)
	-- Recalculate the player's x velocity based on pressed keys
	-- (only if a jump is not occurring)
	if self.velocity.y == 0 then
		self.velocity.x = 0

		for i, key in ipairs(self.input) do
			-- Left
			if key == 'a' or key == 'left' then
				self.velocity.x = -1 * dt
				self.facing = -1

			-- Right
			elseif key == 'd' or key == 'right' then
				self.velocity.x = 1 * dt
				self.facing = 1
			end
		end
	end

	-- If space was pressed, begin a jump
	if self.input[#self.input] == 'space' and self.velocity.y == 0 then
		if self.weight == 0 then
			self.velocity.y = 0
		else
			self.velocity.y = -7 / self.weight
		end
	end
end

--- Draw the player on the screen
-- @todo Incorporate camera coords
-- @param camera The level's camera
function Player:draw(camera)
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	-- Draw body parts to the canvas
	self.legs:draw() 
	self.torso:draw()
	self.head:draw()

	love.graphics.setCanvas()

	-- Draw the canvas to the screen
	camera:attach()

	if self.facing == -1 then
		love.graphics.draw(self.canvas, self.aabb.x, self.aabb.y, 0, self.facing, 1, self.aabb.w, 0)
	else
		love.graphics.draw(self.canvas, self.aabb.x, self.aabb.y)
	end

	camera:detach()
end

return Player
