local SpriteButton = require "poyo.spritebutton"
local FreeplayPoyo = State:extend("FreeplayPoyo")

FreeplayPoyo.weekCategories = {
	{
		name = "Week 1",
		subtitle = "BF VS. Poyo",
		songs = {
			"Summer Sunset",
			"Energizer",
			"Epic"
		},
		realsongs = {
			["Summer Sunset"] = "summer-sunset"
		}
	},
	{
		name = "Week 2",
		subtitle = "Poyo VS. Nafri",
		songs = {
			"Challenger",
			"Bars",
			"Synergy"
		}
	},
	{
		name = "Week 3",
		subtitle = "Dee, Momi, Mauree VS. Poyo",
		songs = {
			"Nightwalk",
			"idk",
			"i still dk"
		}
	},
	{
		name = "For Fun",
		subtitle = "Songs we did for the fuck of it.",
		songs = {
			"Poopshit",
			"Scammed"
		}
	},
	{
		name = "Archived Songs",
		subtitle = "Our history is why we're here today.",
		songs = {
			"Epic (Legacy)",
			"Epic (Ultimate)",
			"Energizer (Generic)"
		},
		realsongs = {
			["Epic (Ultimate)"] = "epic-ultimate",
			["Energizer (Generic)"] = "energizer-generic"
		}
	}
}

local function reloadSongs(self)
	if not self.weekText then
		self.weekText = Text(game.width, 32, "", paths.getFont("vcr.ttf", 46))
		self.weekText.outline.width = 1
		self:add(self.weekText)
	end

	self.weekText.content = self.weekCategories[self.weekSelected].name
	self.weekText:updateHitbox()

	self.weekText.x = game.width-self.weekText:getWidth()-130

	self.leftButton.x = self.weekText.x - self.leftButton.width - 16
	self.rightButton.x = self.weekText.x + self.weekText:getWidth() + 16

	for index,texts in pairs(self.songTexts) do
		local visible = index == self.weekSelected
		for _,text in ipairs(texts) do
			text.visible = visible
		end
	end
	for index,buttons in pairs(self.songButtons) do
		local visible = index == self.weekSelected
		for _,button in ipairs(buttons) do
			button.visible = visible
		end
	end
end

local function change_selection(value, by, max)
	value = value + by
	if value > max then
		value = value-max
	end
	if value < 1 then
		value = value+max
	end
	return value
end

local function add_text_and_button(x, y, text, font, align, callback)
	local text = Text(x, y, text, font)
	if align then
		if align == "right" then
			text.x = text.x-text:getWidth()
		elseif align == "center" then
			text.x = text.x-(text:getWidth())
		end
	end
	text.outline.width = 1

	local button = ui.UIButton(text.x, text.y, text:getWidth(), text:getHeight(), nil, callback)
	button.alpha = 0.7

	return text,button
end

function FreeplayPoyo:changeCategorySelection(value)
	self.weekSelected = change_selection(self.weekSelected, value, #self.weekCategories)
	self.selected = 1
	reloadSongs(self)
end

function FreeplayPoyo:changeSongSelection(value)
	self.selected = change_selection(self.selected, value, #self.weekCategories[self.selected].songs)
end

function FreeplayPoyo:enter()
	FreeplayPoyo.super.enter(self)

	self.selected = 1
	self.weekSelected = 1

	self.bg = Sprite()
	self.bg:loadTexture(paths.getImage('menus/menuDesat'))
	self:add(self.bg)
	self.bg:screenCenter()
	self.bg:setGraphicSize(math.floor(self.bg.width * (game.width / self.bg.width)))
	self.bg:updateHitbox()
	self.bg:screenCenter()

	self.leftButton = SpriteButton(0, 8, paths.getImage("menus/freeplay/testButton"), function()
		self:changeCategorySelection(-1)
	end)
	self:add(self.leftButton)

	self.rightButton = SpriteButton(0, 8, paths.getImage("menus/freeplay/testButton"), function()
		self:changeCategorySelection(1)
	end)
	self:add(self.rightButton)

	self.songTexts = {}
	self.songButtons = {}
	for index,week in pairs(self.weekCategories) do
		self.songTexts[index] = {}
		self.songButtons[index] = {}
		local songNums = #week.songs
		local space = 0.25
		for _,song in ipairs(week.songs) do
			local amount = 0.5+(-(space/2)+(space*(_/songNums)))
	
			local text,button = add_text_and_button(game.width-4,
			game.height*amount,
			song,
			paths.getFont("vcr.ttf", 48),
			"right",
			function()
				game.switchState(PlayState(false, week.realsongs and week.realsongs[song] or song, "normal", self.mods))
			end)

			self.songTexts[index][_] = text
			self.songButtons[index][_] = button

			self:add(text)
			self:add(button)
		end
	end

	self.mods = {}
	self.modsText = Text(16, 16, "Modifiers", paths.getFont("vcr.ttf", 48))
	self.modsText.outline.width = 1
	self:add(self.modsText)

	self.modsTexts = {}
	self.modsButtons = {}
	local modsDisplay = {
		{name = "1.25x Speed", index = "fastPlay"};
		{name = "0.75x Speed", index = "slowPlay"};
		{name = "Play on Left Side", index = "leftSide"};
		{name = "Insta-kill on Miss", index = "instaKillMiss"};
	}
	for i,mod in ipairs(modsDisplay) do
		self.mods[mod.index] = false

		local text,button = add_text_and_button(
			16,
			64+(32*(i-1)),
			mod.name,
			paths.getFont("vcr.ttf", 32),
			"left",
			function()
				self.mods[mod.index] = not self.mods[mod.index]
				if self.mods[mod.index] then
					self.modsText[i].color = Color.YELLOW
				else
					self.modsText[i].color = Color.WHITE
				end
			end
		)

		self.modsText[i] = text
		self.modsButtons[i] = button
		self:add(button)
		self:add(text)
	end

	reloadSongs(self)
end

return FreeplayPoyo