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

function get_prop_val(vars,prop)
	local i,j,k = nil,nil,nil
	
	i, j = string.find(vars,"Prefix")
	j = j+2
	k, i = string.find(vars,"\n",j)
	
	return string.sub(vars,j,k)
end

function load_config()
	local config = minetest.get_worldpath() .. "/parade_local_config.txt"
	
	local file,err = io.open(config,"rb")
	if err ~= nil then
		minetest.log("error","Error could not load config file: " .. config )
		return
	end
	
	local vars = file:read("*a")
	file:close()
	
	parade_local.Prefix = tonumber(get_prop_val(vars,"Prefix"))
end

function save_config()
	local config = minetest.get_worldpath() .. "/parade_local_config.txt"
	
	local file,err = io.open(config,"wb")
	if err ~= nil then
		print("Error could not load config file: " .. config )
		return
	end
	
	local vars = "";
	
	vars = vars .. "Prefix=" .. parade_local.Prefix
	
	file:write(vars)
	file:flush()
	file:close()
end

-- Test whether to use dir/ls
if os.execute('ls') == 0 then
	list_dir = unix_listdir
elseif os.execute('dir') == 0 then
	list_dir = windows_listdir
end
