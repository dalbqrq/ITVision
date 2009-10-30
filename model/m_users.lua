
local t_users = { }


function user (_table)
	table.insert(t_users, _table)
end


function select_users(clause)
	-- clause object shout be used to select status entries
	local select_clause = clause
	t_users = { }

	dofile ("/usr/local/itvision/model/db/db_users.lua")

	return t_users
end


function get_user(c_name)
	users = select_users('all')

	for i, v in ipairs(users) do
		if c_name == v.name then
			return v
		end
	end
end


function auth_user(username, password)

	u = get_user(username)

	if u ~= nil and u.password == password then
		return true
	else
		return false
	end
end



function show_users()
	users = select_users('all')

	print ('\n\nusers:\n-----------------')
	for i, v in ipairs(users) do
		print(i..' : '..v.name..' : '..v.password)
	end
	print()
end


