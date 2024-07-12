function create()
	self.camZoom = 0.75

	local bg = Sprite(-600, 150):loadTexture(
		paths.getImage(SCRIPT_PATH .. "bg"))
	bg.antialiasing = true
	bg:setScrollFactor(1, 1)
	bg:updateHitbox()

	self:add(bg); self.bg = bg

	close()
end
