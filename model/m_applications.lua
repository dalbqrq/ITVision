require "m_monitor"
require "c_monitor_inc"

local t_app = { }


function application (_table)
	table.insert(t_app, _table)
end


function select_applications(clause)
	-- clause object shout be used to select status entries
	local select_clause = clause
	t_app = { }

	--require "db_applications"
	dofile ("/usr/local/itvision/model/db/db_applications.lua")

	return t_app
end


function get_application(gname)
	local app = select_applications("all")

	for i, v in ipairs(app) do
		if gname == v.name then
			return v
		end
	end
end


function get_uniq_hosts_and_services(app_)
	local hosts_ = {} 
	local services_ = {} 

	for i, v in ipairs(app_.hosts) do
		table.insert(hosts_ , v)
	end
	for i, v in ipairs(app_.services) do
		table.insert(services_, v[1])
		table.insert(hosts_, v[2])
	end

	return table.uniq(hosts_), services_
end


function show_applications()
	local app = select_applications("all")

	print ("\n\nApplications:\n-----------------")
	for i, v in ipairs(app) do
		print(i.." : "..v.name)
		print("    hosts: ")
		for j, w in ipairs(app[i].hosts) do
			print("         "..w)
		end
		print("    Services: ")
		for k, x in ipairs(app[i].services) do
			print("         "..x[1].."+"..x[2])
		end
		print("    Dependencies: ")
		for k, x in ipairs(app[i].dependencies) do
			print("         "..x[1].."+"..x[2])
		end
	end
	print()
end


