local Splash = State:extend("Splash")
local UpdateState = require "funkin.states.update"

function Splash:enter()
	self.skipTransIn = true
	Splash.super.enter(self)

	if Project.splashScreen then
		Timer.after(1, function() self:startSplash() end)
	else
		self:finishSplash()
	end
end

function Splash:startSplash()
	local font = paths.getFont("phantommuff.ttf", 24)
	local text = "is made by Stilic, and his dev team."
	local width = font:getWidth(text)

	self.funkinLogo = Sprite():loadTexture(
		paths.getImage('menus/splashscreen/FNFLOVE_logo'))
	self.funkinLogo.scale = {x = 0.4, y = 0.4}
	self.funkinLogo.visible = false
	self.funkinLogo:updateHitbox()
	self.funkinLogo:screenCenter()
	self.funkinLogo.x = self.funkinLogo.x - (width/2)
	self:add(self.funkinLogo)

	self.funkinLogoText = Text((game.width/2),
		self.funkinLogo.y+(self.funkinLogo.height/2)-8,
		"is made by Stilic, and his dev team.",
		font,
		nil,
		"left"
	)
	self.funkinLogoText.alpha = 0
	self.funkinLogoText.scale = {x = 1, y = 1}
	self.funkinLogoText:updateHitbox()
	self:add(self.funkinLogoText)

	self.saxashitterPresents = Text(0, 0,
		"Saxashitter presents...",
		font,
		nil,
		"left"
	)
	self.saxashitterPresents:screenCenter()
	self.saxashitterPresents.alpha = 0
	self:add(self.saxashitterPresents)

	self.poyoRunning = Sprite(0,game.height*0.8)
	self.poyoRunning:setFrames(paths.getUFAtlas("menus/splashscreen/poyo"))
	self.poyoRunning:addAnimByPrefix("run", "run", 16, true)
	self.poyoRunning:play("run")
	self.poyoRunning.scale = {x = 1.25, y = 1.25}
	self.poyoRunning:updateHitbox()
	self.poyoRunning.x = -self.poyoRunning.width
	self:add(self.poyoRunning)

	self.skipText = Text(6, game.height * 0.96, 'Press ACCEPT to skip.',
		paths.getFont('phantommuff.ttf', 24))
	self.skipText.alpha = 0
	self:add(self.skipText)

	Timer.after(3, function() Timer.tween(0.5, self.skipText, {alpha = 1}) end)

	Timer.script(function(setTimer)
		self.funkinLogo.visible = true
		self.funkinLogo.alpha = 0
	
		Timer.tween(5, self.funkinLogo.scale, {x = 0.35, y = 0.35})
		Timer.tween(0.2, self.funkinLogo, {alpha = 1})
		Timer.tween(0.2, self.funkinLogoText, {alpha = 1})

		setTimer(3.8)

		Timer.tween(0.2, self.funkinLogo, {alpha = 0})
		Timer.tween(0.2, self.funkinLogoText, {alpha = 0})

		setTimer(0.4)

		Timer.tween(0.2, self.saxashitterPresents, {alpha = 1})

		setTimer(0.5)
		
		Timer.tween(3, self.poyoRunning, {x = game.width})
		setTimer(4.5)

		self:finishSplash(false)
	end)

	if love.system.getDevice() == "Mobile" then
		self:add(VirtualPad("return", 0, 0, game.width, game.height, false))
	end
end

function Splash:finishSplash(skip)
	if UpdateState.check(true) then
		game.switchState(TitleState(), skip)
	end
end

function Splash:update(dt)
	Splash.super.update(self, dt)

	if controls:pressed("accept") then
		self:finishSplash(true)
	end
end

return Splash
