--- Gameplay game state
-- @module gamestates.play

local Player = require('player.player')

local TestHead = require('player.parts.heads.test')
local TestTorso = require('player.parts.torsos.test')
local TestLegs = require('player.parts.legs.test')

local Level = require('level.level')

local Play = {}
Play.__index = menu

function Play:init()
	self.music = love.audio.newSource('assets/audio/test.mp3', 'stream')

	self.player = Player.new()
	self.player:setHead(TestHead.new())
	self.player:setTorso(TestTorso.new())
	self.player:setLegs(TestLegs.new())

	self.level = Level.new(self.player)
end

function Play:enter()
	love.audio.play(self.music)
end

function Play:draw()
	self.level:draw()
end

function Play:update(dt)
	self.level:update(dt)
end

return Play
