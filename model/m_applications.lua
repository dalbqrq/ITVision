require "m_monitor"
require "c_monitor_inc"

local t_app = { }
local select_clause = { }


function application (_table)
	table.insert(t_app, _table)
end


function select_applications(clause)
	-- clause object must be used to select status entries

	if type(clause) == "string" then
		select_clause = nil
	else
		select_clause = clause
	end
	t_app = { }
	t_napp = { }

	dofile ("/usr/local/itvision/model/db/db_applications.lua")

	if select_clause then
		local found = false
		for i, v in ipairs(t_app) do
			for j, w in ipairs(select_clause) do
				if v.name == w then
					found = true
					table.insert(t_napp,v)
					break
				end
			end
		end
		t_app = t_napp
	end

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


