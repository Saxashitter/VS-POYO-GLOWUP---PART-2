local startWhitty,endWhitty,hasStarted

function create()
	startWhitty = Sprite(state.dad.x-650, state.dad.y-600)
	startWhitty:setFrames(paths.getSparrowAtlas("cutscenes/WhittyCutscene"))
	
	startWhitty:addAnimByPrefix("startup", "Whitty Cutscene Startup 1", 24, false)
	startWhitty:play("startup")
	
	state.timer:after(153/24, function()
		state.boyfriend:sing(0)
	end)
	state.timer:after(224/24-((150/60)/4), function()
		state:startCountdown()
		state.timer:tween(0.25, state.camNotes, {alpha = 1}, "linear")
	end)
	
	state:add(startWhitty)
	state.camNotes.alpha = 0
	state.dad.alpha = 0
end

function goodNoteHit()
	startWhitty.visible = false
	state.dad.alpha = 1
	close()
end