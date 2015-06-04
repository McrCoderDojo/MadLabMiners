minetest.register_privilege("parade_server","Can use parade_local commands")

minetest.register_chatcommand("pStart",{
	params = "",
	description = "",
	privs = {parade_server=true},
	func = function ()
		parade_server.Started = true
		if ps.camera ~= nil then
			ps.camera:setpos(ps.camera_start_pos)
		end
	end
})

minetest.register_chatcommand("pStop",{
	params = "",
	description = "",
	privs = {parade_server=true},
	func = function ()
		parade_server.Started = false
	end
})

minetest.register_chatcommand("pCamSpeed",{
	params = "speed",
	description = "",
	privs = {parade_server=true},
	func = function (name,speed)
		ps.CameraSpeed = tonumber(speed)
	end
})

minetest.register_chatcommand("pCamDeltaTime",{
	params = "",
	description = "",
	privs = {parade_server=true},
	func = function (name,deltaTime)
		ps.DeltaTime = tonumber(deltaTime)
	end
})

minetest.register_chatcommand("parade_server_control",{
	params = "start/stop/update",
	description = "Start Camera movement and allow force update of loaded parade",
	privs = {parade_server=true},
	func = function (name,param)
		if param == "start" then
			parade_server.Started = true
			if not ps.camera == nil then
				ps.camera:setpos(ps.camera_start_pos)
			end
		elseif param == "stop" then
			parade_server.Started = false
		elseif param == "update" then
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
			end

			ps.Timer = 0.0
		end
	end
})