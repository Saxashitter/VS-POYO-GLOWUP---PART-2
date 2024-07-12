local SpriteButton = ui.UIButton:extend("SpriteButton")
SpriteButton:implement(Sprite)

function SpriteButton:new(x, y, image, callback)
	self.texture = image

	SpriteButton.super.new(self, x, y, self.texture:getWidth(), self.texture:getHeight(), nil, callback)
	
	self.color = Color.WHITE
end

SpriteButton.updateHitbox = Sprite.updateHitbox
SpriteButton.centerOffsets = Sprite.centerOffsets
SpriteButton.fixOffsets = Sprite.fixOffsets
SpriteButton.centerOrigin = Sprite.centerOrigin
SpriteButton.__render = Sprite.__render

return SpriteButton