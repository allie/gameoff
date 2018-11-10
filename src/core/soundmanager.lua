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

	--- Collection of music tracks
	instance.tracks = {
		['menu'] = love.audio.newSource('assets/audio/Music1.mp3', 'stream')
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

--- Start a looping music track
-- @param track The name of the track to be played
function SoundManager:startTrack(track)
	if self.tracks[track] ~= nil then
		self.tracks[track]:setLooping(true)
		self.tracks[track]:play()
	end
end

return SoundManager
