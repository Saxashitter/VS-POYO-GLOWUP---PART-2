local _dialogue = require "funkin.substates.dialogue"
local music
local timer

function postCreate()
	timer = Timer.new()

	music = game.sound.load(paths.getMusic('dialogue/week1'))
	music:fade(1, 0, ClientPrefs.data.menuMusicVolume / 100)
	music:setLooping(true)
	music:play()

	local chars = {
		{tag = "p", char = "poyo", side = "left"},
		{tag = "b", char = "poyo", side = "right"}
	}

	local dialogue = {
		{tag = "_", text = "It is a beautiful day inside Fuckadork City."};
		{tag = "_", text = "Fuckadork City is a city where mostly crazy people live."};
		{tag = "_", text = "...Besides a select few."};
		{tag = "_", text = "For our story, we will be focusing on said few."};
		{tag = "_", text = "Our protagionist, Poyo, got called by his friend Nafri. He wants to attend a singing competition."};
		{tag = "_", text = "He agreed, cause why not? It's all in good fun, isn't it?"};
		{tag = "_", text = "Well, of course. But there's a slight issue."};
		{tag = "_", text = "Poyo is a competitive singer."};
		{tag = "p", anim = "scared",   text = "BAAAHAAAAHSIAIOWODOWPFPWPFORIGIEOG"};
		{tag = "z", anim = "confused", text = "dude calm down it aint that deep"};
		{tag = "p", anim = "scared",   text = "BUT I WANNA WIIIINNNNNNNN"};
		{tag = "m", anim = "laugh",    text = "talk about desperate"};
		{tag = "b", anim = "default",  text = "beep"};
		{tag = "p", anim = "neutral",      text = "."};
		{tag = "p", anim = "neutral",    text = "YEAAAAAAAAAAAAAAAAAAH"};
		{tag = "m", anim = "confused", text = "why is poyo so happy over a dude"};
		{tag = "m", anim = "confused", text = "i thought i was gay"};
		{tag = "z", anim = "default",  text = "o yea thats bf"};
		{tag = "z", anim = "default",  text = "hes a very famous singer, he got his bitch from her dad after rapping against a bunch of guys"};
		{tag = "m", anim = "default",  text = "oh"};
		{tag = "p", anim = "neutral",   text = "BF PLEASE SING WITH ME"};
		{tag = "b", anim = "default",  text = "brap"};
		{tag = "b", anim = "default",  text = "uhhh i mean ok"};
		{tag = "p", anim = "neutral",    text = "YEAAAAAAAAAH"};
		{tag = "z", anim = "default",  text = "ill hold the camera"};
	}

	local dialogueState = _dialogue(chars, dialogue)
	dialogueState.cameras = {state.camOther}
	dialogueState.camera = state.camOther -- yea this is for the transition

	dialogueState.onFinish = function(s)
		music:fade(0.5, ClientPrefs.data.menuMusicVolume / 100, 0)
		timer:after(0.75, function() music:stop(); state:startCountdown(); close() end)
	end

	state:openSubstate(dialogueState)
end

function update(dt)
	timer:update(dt)
end