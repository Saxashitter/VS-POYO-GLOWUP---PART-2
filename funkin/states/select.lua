local CharacterSelectState = State:extend "CharacterSelectState"

local characterData = {
	['poyo'] = [[Poyo "BLACK" Oyop]];
	['dee'] = "Mauree Shekkai";
	['nafri'] = "Nafri Somethinf Somethinf Indon8#8iIsos";
	['bf-poyo'] = "Boyfriend";
}

local weekData = {
	['week1'] = {"bf-poyo", "poyo"};
	['week2'] = {"poyo", "nafri"};
	['week3'] = {"poyo", "dee"};
}

local function changeSelection(value, by, max)
	value = value + by
	if value > max then
		value = value-max
	end
	if value < 1 then
		value = value+max
	end
	return value
end

function CharacterSelectState:selectedCharacter()
	
end

function CharacterSelectState:new(storyMode, song, state)
	CharacterSelectState.super.new(self)

	self.storyMode = storyMode
	self.song = song
	self.state = state

	self.curSelected = 1
end

function CharacterSelectState:enter()
	self.bg = Sprite()
	self.bg:loadTexture(paths.getImage('menus/menuDesat'))
	self:add(self.bg)
	self.bg:screenCenter()
	self.bg:setGraphicSize(math.floor(self.bg.width * (game.width / self.bg.width)))
	self.bg:updateHitbox()
	self.bg:screenCenter()

	self.charList = {}
	for _,char in pairs(weekData["week1"]) do
		local character = Character(game.width/2-300, game.height/2-500, char)
		character.scale = {
			x = character.scale.x*0.5,
			y = character.scale.y*0.5,
		}
		character:dance()
		character:updateHitbox()
		self:add(character)
		self.charList[_] = character
	end

	if love.system.getDevice() == "Mobile" then
		self.buttons = VirtualPadGroup()
		local w = 134

		local left = VirtualPad("left", 0, game.height - w)
		local up = VirtualPad("up", left.x + w, left.y - w)
		local down = VirtualPad("down", up.x, left.y)
		local right = VirtualPad("right", down.x + w, left.y)

		local enter = VirtualPad("return", game.width - w, left.y)
		enter.color = Color.GREEN
		local back = VirtualPad("escape", enter.x - w, left.y)
		back.color = Color.RED

		self.buttons:add(left)
		self.buttons:add(up)
		self.buttons:add(down)
		self.buttons:add(right)

		self.buttons:add(enter)
		self.buttons:add(back)

		self:add(self.buttons)
	end

	self.throttles = {}
	self.throttles.left = Throttle:make({controls.down, controls, "ui_left"})
	self.throttles.right = Throttle:make({controls.down, controls, "ui_right"})

	self:changeDir(0)
end

function CharacterSelectState:changeDir(val)
	self.curSelected = changeSelection(self.curSelected, val, #self.charList)
	for _,char in pairs(self.charList) do
		char.visible = (self.curSelected == _)
	end
end

function CharacterSelectState:update(dt)
	CharacterSelectState.super.update(self, dt)

	if self.throttles.left:check() then self:changeDir(-1) end
	if self.throttles.right:check() then self:changeDir(1) end

	if controls:pressed('accept') then
		if self.storyMode
		and self.curSelected == 2 then
			PlayState.mods.leftSide = true
		end
		if not self.storyMode then
			if PlayState.mods.leftSide then
				PlayState.SONG.player2 = self.charList[self.curSelected].char
			else
				PlayState.SONG.player1 = self.charList[self.curSelected].char
			end
		end
		game.switchState(self.state)
	end
end

return CharacterSelectState