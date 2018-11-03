Gamestate = require('lib.hump.gamestate')
menu = require('gamestates.menu')

function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(menu)
end
