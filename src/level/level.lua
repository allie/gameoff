--- Base class for levels
-- @classmod level.level

local bump = require('lib.bump.bump')
local sti = require('lib.sti.sti')

local Level = {}
Level.__index = Level

--- Constructor
-- @return A new Level instance
-- @param player A Player instance to use within the level
-- @param mapFile Path to the Tiled map file
function Level.new(player, mapFile)
	local instance = {}

	--- Enable wireframe rendering for game objects (debug)
	instance.wireframes = true

	--- bump world
	instance.world = bump.newWorld()

	--- Player instance
	instance.player = player

	--- Game objects affected by gravity
	instance.objects = {}

	--- Gravity of the world in units/s^2
	instance.gravity = 10

	--- Tiled map
	instance.map = sti(mapFile, {'bump'})

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
	-- Update the positions of game objects accounting for gravity
	local gdiff = dt * self.gravity
	for i, obj in ipairs(self.objects) do
		local newY = obj.aabb.y + obj.velocity.y + gdiff
		local ax, ay, cols, len = self.world:move(obj, obj.aabb.x, newY)

		obj.velocity.y = obj.velocity.y + gdiff

		if len > 0 and ay ~= newY then
			obj.velocity.y = 0
		end

		obj.aabb.x = ax
		obj.aabb.y = ay
	end
end

--- Draw the level on the screen
function Level:draw()
	-- Draw game objects
	for i, obj in ipairs(self.objects) do
		obj:draw()

		if self.wireframes then
			love.graphics.setLineWidth(1)
			love.graphics.setColor(0, 255, 0)
			love.graphics.rectangle('line', obj.aabb.x, obj.aabb.y, obj.aabb.w, obj.aabb.h)
			love.graphics.setColor(255, 255, 255)
		end
	end
end

return Level
