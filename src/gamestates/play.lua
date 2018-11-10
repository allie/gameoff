--- Gameplay game state
-- @module gamestates.play

local Sprite = require('core.sprite')
local Player = require('player.player')
local TestHead = require('player.parts.heads.test')
local TestTorso = require('player.parts.torsos.test')
local TestLegs = require('player.parts.legs.test')
local TestLevel = require('level.levels.test')
local Hud = require('hud.hud')

local Play = {}
Play.__index = menu

function Play:init()
	Globals.player = Player.new()
	Globals.player:setHead(TestHead.new())
	Globals.player:setTorso(TestTorso.new())
	Globals.player:setLegs(TestLegs.new())

	self.level = TestLevel.new()

	self.hud = Hud.new()
end

function Play:enter()

end

function Play:draw()
	self.level:draw()
	self.hud:draw()
end

function Play:update(dt)
	self.level:update(dt)
end

return Play
