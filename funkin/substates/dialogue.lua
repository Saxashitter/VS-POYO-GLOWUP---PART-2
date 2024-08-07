local Dialogue = Substate:extend "Dialogue"
local BackDrop = require "loxel.effects.backdrop"
local Graphic = require "loxel.graphic"
local TypeText = require "loxel.typetext"

local offsetData = {
	['poyo'] = {
		x = 0,
		y = 0,
		scale = 0.5,
	}
}

local function _characterBop(self, c)
	if not c then return end

	local data = offsetData[c.char] or {x = 0, y = 0}

	c.y = data.y + 15
	self.timer:tween(0.2, c, {y = data.y}, "out-cubic")
end

local function loadDialogueSprite(x,y,char,flip)
	local sprite = Sprite(x,y)
	sprite:setFrames(paths.getSparrowAtlas("dialogue/" .. char))

	sprite:addAnimByPrefix("neutral", "neutral", 1)
	sprite:addAnimByPrefix("scared", "scared", 1)
	sprite:addAnimByPrefix("mad", "mad", 1)
	sprite:addAnimByPrefix("sad", "sad", 1)
	sprite:addAnimByPrefix("with rizz", "with rizz", 1)

	if offsetData[char]
	and offsetData[char].scale then
		sprite.scale = {x = offsetData[char].scale, y = offsetData[char].scale}
		sprite:updateHitbox()
	end

	sprite.char = char
	return sprite
end

function Dialogue:new(chars, dialogue)
	Dialogue.super.new(self)

	self.ended = false
	self.background = BackDrop(0, 0, game.width, game.height, 32, nil, nil, 64)

	self.timer = Timer.new()
	self.dialogue = dialogue or {
		{tag = "1",  text = "bro"};
		{tag = "2", text = "what"};
		{tag = "1",  text = "ur gay"};
		{tag = "2", text = "you stupid bitch"};
		{tag = "3", text = "pleasegooffscreenkeifosdkaofosocoasofoaskfiaskvksovoskvkskvdofksov"};
	}
	self.line = 0
	self.chars = {}
	for _,data in pairs(chars) do
		self.chars[data.tag] = {
			spr = loadDialogueSprite(0,0,data.char),
			side = data.side
		}
	end

	for _,i in pairs(self.chars) do
		local data = offsetData[i.spr.char] or {x = 0, y = 0}

		local ox = data.x
		local oy = data.y
		if i.side == "right" then
			local f = i.spr:getCurrentFrame()
			ox = game.width-f.width-ox
			i.spr.flipX = not i.spr.flipX
		end
	
		i.spr:setPosition(ox, oy)
		i.spr:updateHitbox()
	end

	self.textbox = Graphic(0,game.height/2,game.width,game.height/2)

	self.text = TypeText(16, (game.height/2)+8, "Nothing.", paths.getFont("vcr.ttf", 32), {1,1,1,0}, "left", (game.width-16))
	self.text.onAddLetter = function(s)
		if not self.curChar then return end

		_characterBop(self, self.curChar.char)
	end
	self.text.sound = paths.getSound("gameplay/pixelText")
	self.text:updateHitbox()

	self:add(self.background)
	for _,c in pairs(self.chars) do
		self:add(c.spr)
	end
	self:add(self.textbox)
	self:add(self.text)

	if love.system.getDevice() == "Mobile" then
		self.buttons = VirtualPadGroup()
		local w = 134
		local gw, gh = game.width, game.height

		local enter = VirtualPad("return", gw - w, 0)
		enter.color = Color.GREEN

		self.buttons:add(enter)
		self:add(self.buttons)
	end

	self:switchDialogue()
end

function Dialogue:switchDialogue()
	local nextLine = self.dialogue[self.line + 1]

	if not nextLine then
		if self.onFinish then
			self:onFinish()
		end
		local _alpha = self.camera.alpha
		self.timer:tween(0.25, self.camera, {alpha = 0}, "linear")
		self.timer:after(0.251, function() self.camera.alpha = _alpha; self:close() end)
		return
	end

	self.curChar = nil
	local target = self.chars[nextLine.tag]
	for _,c in pairs(self.chars) do
		if c ~= target then
			c.spr.visible = false
		else
			self.curChar = c
			c.spr.visible = true
			if nextLine.anim then
				c.spr:play(nextLine.anim)
			end
			_characterBop(self, c.spr)
		end
	end

	self.text:resetText(nextLine.text)

	self.line = self.line + 1
	return nextLine
end

function Dialogue:update(dt)
	Dialogue.super.update(self, dt)
	self.timer:update(dt)
	if self.ended then return end
	if controls:pressed("accept") then
		local line = self:switchDialogue()
		if not line then return end
	end
end

function Dialogue:close()
	if self.buttons then self.buttons:destroy() end
	if self.chars then
		for _,c in pairs(self.chars) do
			if c
			and c.char then
				self.chars[_].char:destroy()
			end
		end
	end
	
	Dialogue.super.close(self)
end

return Dialogue