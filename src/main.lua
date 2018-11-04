--- Entry point for love
-- @script main

Gamestate = require('lib.hump.gamestate')
Play = require('gamestates.play')

--- Register game state and do initialization
function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(Play)
end
