local path = minetest.get_modpath(minetest.get_current_modname())

dofile(path .. "/utilities.lua")
dofile(path .. "/chatcommands.lua")

parade_server = {}
parade_server.Started = false
parade_server.Timer = 0
parade_server.CameraTimer = 0

-- Short namespace alias

ps = parade_server

ps.schematic_folder = minetest.get_worldpath() .. "/schems"
ps.air_region = {pos1={x=-141,y=4,z=94},pos2={x=-181,y=34,z=119}}
ps.dirt_region = {pos1={x=-141,y=3,z=94},pos2={x=-181,y=-2,z=119}}
ps.next_region = {x=-146,y=4,z=99}
ps.step_region = -35
ps.float_max_x = 0
ps.float_count = 0

ps.CameraSpeed = 5
ps.DeltaTime = 0.01

ps.camera_start_pos = {x=-113,y=15,z=89}

ps.camera = nil
local firstrun = true
local moveTimer = 0

minetest.register_globalstep(function (dtime)
	if ps.Started == false then
		return
	end

	ps.Timer = ps.Timer + dtime
	if ps.Timer >= 60.0 or firstrun == true then
		for key,val in ipairs(list_dir_diff(ps.schematic_folder)) do
	    	worldedit.set(ps.air_region.pos1,ps.air_region.pos2,worldedit.normalize_nodename("air"))
	    	worldedit.set(ps.dirt_region.pos1,ps.dirt_region.pos2,worldedit.normalize_nodename("dirt_with_grass"))
			worldedit.pos1["WorldController"] = ps.next_region
			loadSchematic(val)
			ps.next_region.x = ps.next_region.x + ps.step_region
			ps.air_region.pos1.x = ps.air_region.pos1.x + ps.step_region
			ps.air_region.pos2.x = ps.air_region.pos2.x + ps.step_region
			ps.dirt_region.pos1.x = ps.dirt_region.pos1.x + ps.step_region
			ps.dirt_region.pos2.x = ps.dirt_region.pos2.x + ps.step_region
			ps.float_count = ps.float_count + 1
		end

		ps.float_max_x = ps.camera_start_pos.x - ps.float_count*40 + 20

		ps.Timer = 0.0
		firstrun = false
	end

	if ps.camera ~= nil then
		local cam = ps.camera
		local cam_pos = cam:getpos()

		cam_pos.x = cam_pos.x - (ps.CameraSpeed * dtime)
		if cam_pos.x < ps.float_max_x then
			cam:setpos(ps.camera_start_pos)
		else
			cam:moveto(cam_pos);
		end
	end
end)

minetest.register_on_joinplayer(function(player)
	if player:get_player_name() == "Camera" then
		ps.camera = player
		ps.camera:setpos(ps.camera_start_pos)
	end
end)

minetest.register_on_leaveplayer(function(player)
	if player:get_player_name() == "Camera" then
		ps.camera = nil
	end
end)