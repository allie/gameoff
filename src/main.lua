--- Entry point for love
-- @script main

Gamestate = require('lib.hump.gamestate')
Play = require('gamestates.play')

--- Register game state and do initialization
function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)
	Gamestate.registerEvents()
	Gamestate.switch(Play)
end
