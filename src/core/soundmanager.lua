--- A class to manage loading and playback of sounds
-- @classmod core.soundmanager

local SoundManager = {}
SoundManager.__index = SoundManager

--- Constructor
-- @return A new SoundManager instance
function SoundManager.new()
	local instance = {}

	--- Collection of sounds
	instance.sounds = {
		['ui-move'] = love.audio.newSource('assets/audio/SFX_Blip06.ogg', 'stream'),
		['ui-select'] = love.audio.newSource('assets/audio/SFX_Blip04.ogg', 'stream'),
		['player-jump'] = love.audio.newSource('assets/audio/SFX_Jump04.ogg', 'stream')
	}

	setmetatable(instance, SoundManager)
	return instance
end

--- Play a sound
-- @param sound The name of the sound to be played
function SoundManager:play(sound)
	if self.sounds[sound] ~= nil then
		self.sounds[sound]:play()
	end
end

return SoundManager
