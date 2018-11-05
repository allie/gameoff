--- A parallax scrolling background
-- @classmod level.background

local Background = {}
Background.__index = Background

--- Constructor
-- @param images A table of images to use for the layers
-- @param[opt] intensity Specifies how intense the parallax effect should be; 0 disables the effect
-- @param[opt] scale Scale to draw the background with
-- @param[opt] xOffset X offset for drawing the background
-- @param[opt] yOffset Y offset for drawing the background
-- @return A new Level instance
function Background.new(images, intensity, scale, xOffset, yOffset)
	local instance = {}

	--- Layers of the background
	instance.layers = {}

	--- Parallax intensity; 0 disables the effct
	instance.intensity = intensity or 0

	--- Scale to draw the background with
	instance.scale = scale or 1

	--- Drawing position
	-- @field x X coordinate
	-- @field y Y coordinate
	instance.position = {x=x, y=y}

	--- Drawing offset
	-- @field x X offset
	-- @field y Y offset
	instance.offset = {x=xOffset or 0, y=yOffset or 0}

	-- Add layers in order
	for i, image in ipairs(images) do
		table.insert(instance.layers, love.graphics.newImage(image))
	end

	--- X coordinate limits (for drawing along the X axis)
	instance.limit = (instance.layers[1]:getWidth() / 2) * (instance.intensity / 100)

	--- The canvas to render to
	instance.canvas = love.graphics.newCanvas(
		(instance.limit - (-instance.limit)) + instance.layers[1]:getWidth(),
		instance.layers[1]:getHeight()
	)

	setmetatable(instance, Background)
	return instance
end

--- Draw the background
-- @param scroll How far along the map's X axis to calculate for; between 0 and 1
function Background:draw(scroll)
	-- Convert scroll to be between -1 and 1 for convenience
	scroll = scroll * 2 - 1

	-- Find the centre point
	local cx = self.canvas:getWidth() / 2
	local cy = self.canvas:getHeight() / 2

	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	for i, layer in ipairs(self.layers) do
		local mul = 1 / ((#self.layers - i) + 1)
		love.graphics.draw(
			layer,
			cx - (mul * self.limit * scroll),
			cy,
			0, 1, 1,
			layer:getWidth() / 2,
			layer:getHeight() / 2
		)
	end

	love.graphics.setCanvas()

	love.graphics.draw(
		self.canvas,
		love.graphics.getWidth() / 2 + self.offset.x,
		love.graphics.getHeight() / 2 + self.offset.y,
		0,
		self.scale, self.scale,
		self.canvas:getWidth() / 2,
		self.canvas:getHeight() / 2
	)
end

return Background
