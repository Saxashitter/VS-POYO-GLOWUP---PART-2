function create()
	self.camZoom = 0.35

	local bg = Sprite(-1000, -600):loadTexture(
		paths.getImage(SCRIPT_PATH .. "bg"))
	bg.antialiasing = true
	bg.scale = {x = 1.25, y = 1.25}
	bg:setScrollFactor(1, 1)
	bg:updateHitbox()
	self:add(bg); self.bg = bg

	self.boyfriendPos = {
		x = 1450; y = 680
	}
	self.gfPos = {
		x = 850; y = 580
	}
	self.dadPos = {
		x = 250; y = 680
	}
end