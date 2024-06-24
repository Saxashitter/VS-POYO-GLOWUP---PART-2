local decodeJson = (require "lib.json").decode

local function readFile(key)
	if paths.exists(key, "file") then return love.filesystem.read(key) end
	return nil
end

local function excludeAssets(path)
	local i, n = path:find("assets/")
	if i == 1 then
		return path:sub(n + 1)
	elseif path:find("mods/") == 1 then
		i = path:find("/", 6)
		if i then return path:sub(i + 1) end
	end
	return path
end

local paths = {
	images = {},
	audio = {},
	atlases = {},
	fonts = {},
	noteskins = {},
	persistantAssets = {"music/freakyMenu.ogg"}
}

function paths.addPersistant(path)
	path = excludeAssets(path)
	if not table.find(paths.persistantAssets, path) then
		table.insert(paths.persistantAssets, path)
	end
end

function paths.isPersistant(path)
	path = excludeAssets(path)
	for _, k in pairs(paths.persistantAssets) do
		if path:startsWith(k) then return true end
	end
	return false
end

function paths.clearCache()
	for k, o in pairs(paths.images) do
		if not paths.isPersistant(k) then
			o:release()
			paths.images[k] = nil
		end
	end
	for k, o in pairs(paths.audio) do
		if not paths.isPersistant(k) then
			o:release()
			paths.audio[k] = nil
		end
	end
	for k, o in pairs(paths.atlases) do
		if not paths.isPersistant(k) then
			o.texture:release()
			for _, f in ipairs(o.frames) do f.quad:release() end
			paths.atlases[k] = nil
		end
	end
	for k, o in pairs(paths.noteskins) do
		if not paths.isPersistant(k) then
			paths.noteskins[k] = nil
		end
	end
	collectgarbage()
end

function paths.getMods(key)
	if Mods.currentMod then
		return "mods/" .. Mods.currentMod .. "/" .. key
	end
	return "mods/" .. key
end

function paths.getPath(key, allowMods)
	if allowMods == nil then allowMods = true end
	local path = paths.getMods(key)
	return (allowMods and paths.exists(path)) and path or "assets/" .. key
end

function paths.exists(path, type)
	local info = love.filesystem.getInfo(path)
	return info ~= nil and (not type or info.type == type:lower())
end

function paths.getItems(key, type)
	local path = paths.getPath(key)

	if type == nil then type = "any" end
	if not paths.exists(path, "directory") then return {} end

	local files, result = love.filesystem.getDirectoryItems(path), {}
	for _, v in ipairs(files) do
		local f = path .. "/" .. v
		local info = love.filesystem.getInfo(f)

		if info then
			if type == "any" or info.type == type:lower() then
				table.insert(result, v)
			end
		end
	end

	return result
end

function paths.getText(key)
	local path = paths.getPath("data/" .. key .. ".txt")
	return readFile(path), path
end

function paths.getJSON(key)
	local path = paths.getPath(key .. ".json")
	local data = readFile(path)
	if data then return decodeJson(data), path end
	return nil, path
end

function paths.getSkin(key)
	local obj = paths.noteskins[key]
	if obj then return obj end
	obj = paths.getJSON("data/skins/" .. key)
	if obj then
		obj.skin = key
		paths.noteskins[key] = obj
		return obj
	end

	print('oh no its returning "noteskin" null NOOOO: ' .. key)
	return nil
end

function paths.getFont(key, size)
	if size == nil then size = 12 end

	local path = paths.getPath("fonts/" .. key)
	local obj = paths.fonts[path .. "_" .. size]
	if obj then return obj end
	if paths.exists(path, "file") then
		obj = love.graphics.newFont(path, size)
		paths.fonts[path .. "_" .. size] = obj
		return obj
	end

	print('oh no its returning "font" null NOOOO: ' .. path)
	return nil
end

function paths.getImage(key)
	local path = paths.getPath("images/" .. key .. ".png")
	local obj = paths.images[path]
	if obj then return obj end
	if paths.exists(path, "file") then
		obj = love.graphics.newImage(path)
		paths.images[path] = obj
		return obj
	end

	print('oh no its returning "image" null NOOOO: ' .. key)
	return nil
end

function paths.getAudio(key, stream, logError)
	local path = paths.getPath(key .. ".ogg")
	local obj = paths.audio[path]
	if obj then return obj end
	if paths.exists(path, "file") then
		obj = stream and love.audio.newSource(path, "stream") or
			love.sound.newSoundData(path)
		paths.audio[path] = obj
		return obj
	end

	if not logError then print('oh no its returning "audio" null NOOOO: ' .. key) end
	return nil
end

function paths.getMusic(key) return paths.getAudio("music/" .. key, true) end

function paths.getSound(key) return paths.getAudio("sounds/" .. key, false) end

function paths.getInst(song)
	return paths.getAudio("songs/" .. paths.formatToSongPath(song) .. "/Inst", true)
end

function paths.getVoices(song, suffix, logError)
	return paths.getAudio("songs/"
		.. paths.formatToSongPath(song)
		.. "/Voices" .. (suffix and "-" .. suffix or ""), true, logError)
end

function paths.getSparrowAtlas(key)
	local imgPath, xmlPath = key, paths.getPath("images/" .. key .. ".xml")
	local obj = paths.atlases[paths.getPath("images/" .. key)]
	if obj then return obj end
	img = paths.getImage(imgPath)
	if img and paths.exists(xmlPath, "file") then
		obj = Sprite.getFramesFromSparrow(img, readFile(xmlPath))
		paths.atlases[paths.getPath("images/" .. key)] = obj
		return obj
	end
	return nil
end
function paths.getUFAtlas(key)
	local imgPath, jsonPath = key, paths.getPath("images/" .. key .. ".json")
	local obj = paths.atlases[paths.getPath("images/" .. key)]
	if obj then return obj end
	img = paths.getImage(imgPath)
	if img and paths.exists(jsonPath, "file") then
		obj = Sprite.getFramesFromUF(img, decodeJson(readFile(jsonPath)))
		paths.atlases[paths.getPath("images/" .. key)] = obj
		return obj
	end
	return nil
end

function paths.getPackerAtlas(key)
	local imgPath, txtPath = key, paths.getPath("images/" .. key .. ".txt")
	local obj = paths.atlases[paths.getPath("images/" .. key)]
	if obj then return obj end
	local img = paths.getImage(imgPath)
	if img and paths.exists(txtPath, "file") then
		obj = Sprite.getFramesFromPacker(img, readFile(txtPath))
		paths.atlases[paths.getPath("images/" .. key)] = obj
		return obj
	end
	return nil
end

function paths.getAtlas(key)
	if paths.exists(paths.getPath("images/" .. key .. ".xml"), "file") then return paths.getSparrowAtlas(key) end
	return paths.getPackerAtlas(key)
end

function paths.getLua(key)
	local path = paths.getPath(key .. ".lua")
	if paths.exists(path, "file") then
		local chunk = love.filesystem.load(path)
		return chunk
	end
	return nil
end

local invalidChars = '[~&\\;:<>#]'
local hideChars = '[.,\'"%?!]'
function paths.formatToSongPath(path)
	return string.lower(string.gsub(string.gsub(path:gsub(" ", "-"),
			invalidChars, "-"), hideChars,
		""))
end

return paths
