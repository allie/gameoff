--- Gameplay game state
-- @module gamestates.play

local TestHead = require('player.parts.heads.test')
local TestTorso = require('player.parts.torsos.test')
local TestLegs = require('player.parts.legs.test')

local Play = {}
Play.__index = menu

function Play:init()
	self.boy = love.graphics.newImage('assets/images/boy.png')
	self.music = love.audio.newSource('assets/audio/test.mp3', 'stream')

	self.player = Player.new()
	self.player.setHead(TestHead.new())
	self.player.setTorso(TestTorso.new())
	self.player.setLegs(TestLegs.new())
end

function Play:enter()
	love.audio.play(self.music)
end

function Play:draw()
	love.graphics.draw(self.boy, 0, 0)
end

function Play:update(dt)

end

return Menu
