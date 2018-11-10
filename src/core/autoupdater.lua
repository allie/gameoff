--- A global manager that automatically updates all items given to it
-- @classmod core.autoupdater

local AutoUpdater = {}
AutoUpdater.__index = AutoUpdater

--- Constructor
-- @return A new AutoUpdater instance
function AutoUpdater.new()
	local instance = {}

	--- The collection of objects managed by this class
	instance.objects = {}

	-- Listen for object-add events
	Signal.register('object-add', function(object)
		table.insert(instance.objects, object)
	end)

	setmetatable(instance, AutoUpdater)
	return instance
end

--- Update all objects
-- @param dt Delta time
function AutoUpdater:update(dt)
	for i, object in ipairs(self.objects) do
		object:update(dt)
	end
end

return AutoUpdater
