function create()
	self.camZoom = 0.6

	local bg = Sprite(-600, -200):loadTexture(
		paths.getImage(SCRIPT_PATH .. "back"))
	bg.antialiasing = true
	bg:setScrollFactor(0.5, 0)
	bg:updateHitbox()
	self:add(bg); self.bg = bg

	local stageFront = Sprite(-650, 600):loadTexture(paths.getImage(
		SCRIPT_PATH ..
		"front"))
	stageFront:setGraphicSize(math.floor(stageFront.width * 1.1))
	stageFront:updateHitbox()
	stageFront.antialiasing = true
	stageFront:setScrollFactor(0.9, 0.9)
	self:add(stageFront); self.stageFront = stageFront

	close()
end