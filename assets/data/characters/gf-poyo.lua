function create()
	local speaker = Sprite(self.x-130, self.y+50)
	speaker:setFrames(paths.getSparrowAtlas("characters/Speaker"))
	speaker.antialiasing = true

	speaker:addAnimByPrefix("bop", "SpeakerLol", 24, false)
	speaker:play("bop")

	speaker:setScrollFactor(self.scrollFactor.x, self.scrollFactor.y)
	speaker:updateHitbox()

	PlayState.__speaker = speaker
	self.speaker = speaker
end

function beat()
	if curBeat % 1 == 0 then
		self.speaker:play("bop")
	end
end