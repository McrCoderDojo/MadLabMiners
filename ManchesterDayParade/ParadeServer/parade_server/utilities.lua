list_dir = nil

local last_files = nil

function list_dir_diff(path)
	local files = list_dir(path)
	local diff = {}
	local hasFile = false
	
	if last_files == nil then
		last_files = files
		return files
	end

	for k1,v1 in ipairs(files) do
		hasFile = false
		for k2,v2 in ipairs(last_files) do
			if v1 == v2 then
				hasFile = true
				break
			end
		end

		if not hasFile then
			table.insert(diff,v1)
		end
	end

	last_files = files

	return diff
end

function unix_listdir(path)
	print(path)
	local p = string.gsub(path,"\\","/")

	local ls = io.popen('ls ' .. p,'r')

	local files = {};

	for ln in ls:lines() do table.insert(files,ln) end

	ls:close()

	return files
end

function windows_listdir(path)
	print(path)
	local p = string.gsub(path,"/","\\")

	local ls = io.popen('dir /b ' .. p,'r')

	local files = {};

	for ln in ls:lines() do table.insert(files,ln) end

	ls:close()

	return files
end

-- Copied from worldedit_commands.
function loadSchematic(param)
	local name = "WorldController"
	local pos1 = worldedit.pos1["WorldController"]
	if pos1 == nil then
		worldedit.player_notify(name, "no region selected")
		return
	end

	if param == "" then
		worldedit.player_notify(name, "invalid usage: " .. param)
		return
	end

	--find the file in the world path
	local testpaths = {
		minetest.get_worldpath() .. "/schems/" .. param,
		minetest.get_worldpath() .. "/schems/" .. param .. ".we",
		minetest.get_worldpath() .. "/schems/" .. param .. ".wem",
	}
	local file, err
	for index, path in ipairs(testpaths) do
		file, err = io.open(path, "rb")
		if not err then
			break
		end
	end
	if err then
		worldedit.player_notify(name, "could not open file \"" .. param .. "\"")
		return
	end
	local value = file:read("*a")
	file:close()

	if worldedit.valueversion(value) == 0 then --unknown version
		worldedit.player_notify(name, "invalid file: file is invalid or created with newer version of WorldEdit")
		return
	end

	local count = worldedit.deserialize(pos1, value)

	worldedit.player_notify(name, count .. " nodes loaded")
end


-- Test whether to use dir/ls
if os.execute('ls') == 0 then
	list_dir = unix_listdir
elseif os.execute('dir') == 0 then
	list_dir = windows_listdir
end
