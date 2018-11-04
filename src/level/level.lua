--- Base class for levels
-- @classmod level.level

local bump = require('lib.bump.bump')
local sti = require('lib.sti.sti')
local Camera = require('lib.hump.camera')

local Level = {}
Level.__index = Level

--- Constructor
-- @return A new Level instance
-- @param player A Player instance to use within the level
-- @param mapFile Path to the Tiled map file
function Level.new(player, mapFile)
	local instance = {}

	--- Enable wireframe rendering for game objects (debug)
	instance.wireframes = false

	--- bump world
	instance.world = bump.newWorld()

	--- Player instance
	instance.player = player
	instance.player.aabb.x = 0

	--- Game objects affected by gravity
	instance.objects = {}

	--- Gravity of the world in units/s^2
	instance.gravity = 20

	--- Camera
	instance.camera = Camera.new(
		instance.player.aabb.x + instance.player.aabb.cx,
		instance.player.aabb.cy + instance.player.aabb.cy
	)

	--- Tiled map
	instance.map = sti(mapFile, {'bump'})

	-- The bounds of the camera
	instance.cameraBounds = {
		left = love.graphics.getWidth() / 2,
		right = instance.map.width * instance.map.tilewidth - love.graphics.getWidth() / 2,
		top = love.graphics.getHeight() / 2,
		bottom = instance.map.height * instance.map.tileheight - love.graphics.getHeight() / 2,
	}

	-- Add player to the game objects collection
	table.insert(instance.objects, instance.player)

	-- Add game objects to the world
	for i, obj in ipairs(instance.objects) do
		instance.world:add(obj, obj.aabb.x, obj.aabb.y, obj.aabb.w, obj.aabb.h)
	end

	-- Initialize STI with the world
	instance.map:bump_init(instance.world)

	setmetatable(instance, Level)
	return instance
end

--- Update the game world
-- @param dt Delta time
function Level:update(dt)
	-- Update all game objects
	for i, obj in ipairs(self.objects) do
		obj:update(dt)
	end

	-- Update the positions of game objects accounting for gravity
	local gdiff = dt * self.gravity
	for i, obj in ipairs(self.objects) do
		local newY = obj.aabb.y + obj.velocity.y + gdiff
		local ax, ay, cols, len = self.world:move(obj, obj.aabb.x + (obj.velocity.x * 200), newY)

		obj.velocity.y = obj.velocity.y + gdiff

		if len > 0 and ay ~= newY then
			obj.velocity.y = 0
		end

		obj.aabb.x = ax
		obj.aabb.y = ay
	end

	-- Update the position of the camera to follow the character
	self.camera:lookAt(
		self.player.aabb.x + self.player.aabb.cx,
		self.player.aabb.y + self.player.aabb.cy
	)

	-- Clamp the camera within the bounds of the level
	self.camera.x = math.max(self.cameraBounds.left, self.camera.x)
	self.camera.x = math.min(self.cameraBounds.right, self.camera.x)
	self.camera.y = math.max(self.cameraBounds.top, self.camera.y)
	self.camera.y = math.min(self.cameraBounds.bottom, self.camera.y)
end

--- Draw the level on the screen
function Level:draw()
	-- Reset the draw colour
	love.graphics.setColor(255, 255, 255)

	local tx = self.camera.x - love.graphics.getWidth() / 2
	local ty = self.camera.y - love.graphics.getHeight() / 2

	if tx < 0 then 
		tx = 0 
	end

	if tx > self.map.width  * self.map.tilewidth  - love.graphics.getWidth() then
		tx = self.map.width  * self.map.tilewidth  - love.graphics.getWidth()  
	end

	if ty > self.map.height * self.map.tileheight - love.graphics.getHeight() then
		ty = self.map.height * self.map.tileheight - love.graphics.getHeight()
	end

	tx = math.floor(tx)
	ty = math.floor(ty)

	-- Draw the map
	self.map:draw(-tx, -ty)

	-- Draw game objects
	for i, obj in ipairs(self.objects) do
		obj:draw(self.camera)

		if self.wireframes then
			love.graphics.setLineWidth(1)
			love.graphics.setColor(0, 255, 0)
			love.graphics.rectangle('line', obj.aabb.x, obj.aabb.y, obj.aabb.w, obj.aabb.h)
			love.graphics.setColor(255, 255, 255)
		end
	end

	-- Draw UI here
end

return Level
