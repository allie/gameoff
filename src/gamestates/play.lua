--- Gameplay game state
-- @module gamestates.play

local Sprite = require('core.sprite')
local Player = require('player.player')
local TestHead = require('player.parts.heads.test')
local TestTorso = require('player.parts.torsos.test')
local TestLegs = require('player.parts.legs.test')
local TestLevel = require('level.levels.test')
local Hud = require('hud.hud')
local ScreenTransition = require('core.screentransition')

local Play = {}
Play.__index = menu

function Play:init()
	Globals.player = Player.new()
	Globals.player:setHead(TestHead.new())
	Globals.player:setTorso(TestTorso.new())
	Globals.player:setLegs(TestLegs.new())

	self.level = TestLevel.new()

	self.hud = Hud.new()

	self.fadein = nil
	self.fadeout = nil
end

function Play:enter()
	self.fadein = ScreenTransition.new('fadein', 0.5)
end

function Play:draw()
	self.level:draw()
	self.hud:draw()

	-- Draw fade in if necessary
	if self.fadein ~= nil and not self.fadein.finished then
		self.fadein:draw()
	else
		self.fadein = nil
	end
end

function Play:update(dt)
	self.level:update(dt)
end

return Play
