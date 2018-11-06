--- A global manager that automatically updates all sprites
-- @classmod core.spritemanager

local Signal = require('lib.hump.signal')

local SpriteManager = {}
SpriteManager.__index = SpriteManager

--- Constructor
-- @return A new SpriteManager instance
function SpriteManager.new()
	local instance = {}

	--- The collection of sprites managed by this class
	instance.sprites = {}

	instance.test = 'test'

	-- Listen for sprite-add events
	Signal.register('sprite-add', function(sprite)
		table.insert(instance.sprites, sprite)
	end)

	setmetatable(instance, SpriteManager)
	return instance
end

--- Update sprite animations
-- @param dt Delta time
function SpriteManager:update(dt)
	for i, sprite in ipairs(self.sprites) do
		if sprite.animated then
			sprite:update(dt)
		end
	end
end

return SpriteManager
