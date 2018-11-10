--- Entry point for love
-- @script main

-- Load external libraries
Signal = require('lib.hump.signal')
Gamestate = require('lib.hump.gamestate')
Camera = require('lib.hump.camera')
bump = require('lib.bump.bump')
sti = require('lib.sti.sti')

local AutoUpdater = require('core.autoupdater')
local InputManager = require('core.inputmanager')
local Play = require('gamestates.play')
local Menu = require('gamestates.mainmenu')

--- Table holding anything that should be easily accessible anywhere within the game
Globals = {}

--- Register game state and do initialization
function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)

	Globals.updater = AutoUpdater.new()
	Globals.input = InputManager.new()
	Globals.input:findGamepads()

	Gamestate.registerEvents()
	Gamestate.switch(Play)
end

function love.update(dt)
	Globals.updater:update(dt)
end
