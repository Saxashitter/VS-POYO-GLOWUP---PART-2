function create()
	self.camZoom = 0.8

	local bg = Sprite(-600, -250):loadTexture(
		paths.getImage(SCRIPT_PATH .. "bg"))
	bg.antialiasing = true
	bg:setScrollFactor(1, 1)
	bg:updateHitbox()
	self:add(bg); self.bg = bg

	close()
end