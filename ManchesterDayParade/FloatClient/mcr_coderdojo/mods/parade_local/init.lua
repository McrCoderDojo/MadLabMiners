-- I need a load in region and a load out region
-- Might have ot change this to use camera movement and spawn in float after float
-- need to track distance and do jump back in that case.
local path = minetest.get_modpath(minetest.get_current_modname())

dofile(path .. "/utilities.lua")
dofile(path .. "/chatcommands.lua")

parade_local = {}

parade_local.Prefix = 1

local schematic_folder = minetest.get_worldpath() .. "/schems"
local build_region = {pos1={x=-73,y=4,z=5},pos2={x=-43,y=34,z=20}}
local player_start_pos = {x=-56,y=3.5,z=-17}

minetest.register_on_joinplayer(function (player)
	player:setpos(player_start_pos)
	player:set_look_yaw((3*math.pi)/2)
end)

load_config()

-- Copy of worldedit /save command
parade_local.Save_Parade = function ()
	local name = "WorldController"
	local param = string.format("%05d",parade_local.Prefix) .. "_Parade"
	parade_local.Prefix = parade_local.Prefix + 1
	save_config()
	local pos1, pos2 = build_region.pos1, build_region.pos2
	if pos1 == nil or pos2 == nil then
		return
	end

	if param == "" then
		return
	end

	local result, count = worldedit.serialize(pos1, pos2)

	local path = minetest.get_worldpath() .. "/schems"
	local config = minetest.get_worldpath() .. "/local_parade_config.txt"
	local filename = path .. "/" .. param .. ".we"
	os.execute("mkdir \"" .. path .. "\"") --create directory if it does not already exist
	local file, err = io.open(filename, "wb")
	if err ~= nil then
		return
	end
	file:write(result)
	file:flush()
	file:close()

	local node = worldedit.normalize_nodename("air")
	worldedit.set(pos1,pos2,node)
end