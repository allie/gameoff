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

	--- Background colour of the level
	instance.bgColour = {r=100, g=149, b=237}

	--- bump world
	instance.world = bump.newWorld()

	--- Player instance
	instance.player = player

	--- Game objects affected by gravity
	instance.objects = {}

	--- Gravity of the world in units/s^2
	instance.gravity = 20

	--- Camera
	instance.camera = Camera.new(
		instance.player.aabb.x + instance.player.aabb.cx,
		instance.player.aabb.cy + instance.player.aabb.cy,
		2
	)

	--- Tiled map
	instance.map = sti(mapFile, {'bump'})

	-- The bounds of the camera
	instance.cameraBounds = {
		left = love.graphics.getWidth() / 2 / instance.camera.scale,
		right = instance.map.width * instance.map.tilewidth - love.graphics.getWidth() / 2 / instance.camera.scale,
		top = love.graphics.getHeight() / 2 / instance.camera.scale,
		bottom = instance.map.height * instance.map.tileheight - love.graphics.getHeight() / 2 / instance.camera.scale,
	}

	-- Set spawn point for the player
	for k, object in pairs(instance.map.objects) do
		if object.name == 'spawn' then
			instance.player.aabb.x = object.x
			instance.player.aabb.y = object.y
			break
		end
	end

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
	-- Clear screen to the background colour
	love.graphics.clear(self.bgColour.r / 255, self.bgColour.g / 255, self.bgColour.b / 255)

	-- Reset the draw colour
	love.graphics.setColor(255, 255, 255)

	local tx = math.floor(self.camera.x - love.graphics.getWidth() / 2 / self.camera.scale)
	local ty = math.floor(self.camera.y - love.graphics.getHeight() / 2 / self.camera.scale)

	-- Draw the map
	self.map:draw(-tx, -ty, self.camera.scale, self.camera.scale)

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
