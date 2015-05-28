minetest.register_privilege("parade_local","Can use parade_local commands")

minetest.register_chatcommand("parade_local_set_prefix", {
	params = "",
	description = "Set Prefix value for file saves",
	privs = {parade_local=true},
	func = function (name,param)
		parade_local.Prefix = tonumber(param)
		save_config()
	end
})
minetest.register_chatcommand("parade_local_get_prefix", {
	params = "",
	description = "Set Prefix value for file saves",
	privs = {parade_local=true},
	func = function (name,param)
		worldedit.player_notify(name,"Prefix: " .. parade_local.Prefix)
	end
})