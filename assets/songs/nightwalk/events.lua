local isZoomIn = false
local bfTrail,dadTrail

function postCreate()
	bfTrail = Trail(state.boyfriend, 3, 4.5)
	dadTrail = Trail(state.dad, 3, 4.5)
	state:insert(state:indexOf(state.boyfriend), bfTrail)
	state:insert(state:indexOf(state.dad), dadTrail)
end

function update(dt)
	bfTrail.visible = isZoomIn
	dadTrail.visible = isZoomIn
end

function section()
	local _zoom
	
	if curSection == 47 then
		state.timer:tween((crotchet/1000)*8, state, {camZoom = 1.35}, "in-out-back", nil, 0.05)
	end
	if curSection == 48 then
		state.timer:tween((crotchet/1000), state.stage.bg, {alpha = 0.5}, "linear")
		state.camNotes:flash(Color.WHITE, crotchet/2000)
	end

	if curSection == 48+15 then
		state.timer:tween((crotchet/1000)*4, state, {camZoom = 0.5}, "in-cubic")
	end
	if curSection == 48+16 then
		state.timer:tween(crotchet/1000, state.stage.bg, {alpha = 1}, "linear")
		state.camNotes:flash(Color.WHITE, crotchet/2000)
	end

	if curSection >= 48 then
		_zoom = true
	end
	if curSection >= 48+16 then
		_zoom = false
	end

	isZoomIn = _zoom
end