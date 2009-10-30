require "c_monitor_inc"
--dofile("/usr/local/itvision/controler/c_monitor_inc.lua")

local init = 0

local t_info = { }
local t_programstatus = { }
local t_hoststatus = { }
local t_servicestatus = { }
local t_contactstatus = { }
local t_hostcomment = { }
local t_servicecomment = { }
local t_hostdowntime = { }
local t_servicedowntime = { }

function info (_table) 
	table.insert(t_info, _table)
end

function programstatus (_table)
	table.insert(t_programstatus, _table)
end

function hoststatus (_table)
	if _table.has_been_checked == 0 then
		_table.current_state = HOST_PENDING
	end
	table.insert(t_hoststatus, _table)
end

function servicestatus (_table)
	if _table.has_been_checked == 0 then
		_table.current_state = STATE_PENDING
	end
	table.insert(t_servicestatus, _table)
end

function hostcomment (_table)
	table.insert(t_hostcomment, _table)
end

function servicecomment (_table)
	table.insert(t_servicecomment, _table)
end

function hostdowntime (_table)
	table.insert(t_hostdowntime, _table)
end

function servicedowntime (_table)
	table.insert(t_servicedowntime, _table)
end

function contactstatus (_table) 
	table.insert(t_contactstatus, _table)
end


function select_status(clause)
	-- clause object shout be used to select status entries
	local t_status = nil
	local select_clause = clause

	t_info = { }
	t_programstatus = { }
	t_hoststatus = { }
	t_servicestatus = { }
	t_contactstatus = { }
	t_hostcomment = { }
	t_servicecomment = { }
	t_hostdowntime = { }
	t_servicedowntime = { }

	--dofile ("/usr/local/itvision_monitor/var/status_gesti.lua")
	--dofile ("/usr/local/itvision_monitor/var/db_monitor.lua")
	dofile ("/usr/local/monitor/var/db_monitor.lua")
	--dofile ("db_monitor")
	--require "db_monitor"

	t_status = {
		info = t_info, 
		programstatus = t_programstatus, 
		hoststatus = t_hoststatus, 
		servicestatus = t_servicestatus, 
		contactstatus = t_contactstatus, 
		hostcomment = t_hostcomment, 
		servicecomment = t_servicecomment, 
		hostdowntime = t_hostdowntime, 
		servicedowntime = t_servicedowntime
	}

	return t_status
end



function insert_status(status)
	print("-- NOT IMPLEMENTED --")
end

function update_status(status)
	print("-- NOT IMPLEMENTED --")
end

function delete_status(status)
	print("-- NOT IMPLEMENTED --")
end
