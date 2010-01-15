require "m_applications"
require "m_monitor"
require "m_io_util"
require "m_persistence_table"
--dofile("/usr/local/itvision/model/m_monitor.lua")

--[[
color = {
	blue =   { name = "blue",	rgb="#0066ff" },	-- blue color used by peding hosts and services
	green =  { name = "green",	rgb="#33ff00" },	-- green color used by up hosts and ok services
	yellow = { name = "yellow",	rgb="#f2f200" },	-- yellow color used by unreachable hosts and unknown services
	orange = { name = "orange",	rgb="#ff9900" },	-- orange color used by warning services
	red =    { name = "red",	rgb="#d90000" },	-- red color used by down hosts and critical services
	gray =   { name = "gray",	rgb="#333333" }		-- gray color used by all non problem status
}

host_alert = {   
	{ name= "up", 		status = HOST_UP,		num = 0, color = color.green.name },
	{ name= "down", 	status = HOST_DOWN,		num = 0, color = color.red.name },
	{ name= "unreachable", 	status = HOST_UNRRACHABLE,	num = 0, color = color.yellow.name },
	{ name= "pending", 	status = 0,			num = 0, color = color.blue.name }
}

service_alert = {
	{ name= "ok", 		status = STATE_OK,		num = 0, color = color.green.name },
	{ name= "warning", 	status = STATE_WARNING,		num = 0, color = color.orange.name },
	{ name= "critial", 	status = STATE_CRITICAL,	num = 0, color = color.red.name },
	{ name= "unknown", 	status = STATE_UNKNOWN,		num = 0, color = color.yellow.name },
	{ name= "pending",	status = 0,			num = 0, color = color.blue.name }
}


]]--

color = {
	blue =   "0066ff",	-- blue color used by peding hosts and services
	green =  "00f200",	-- green color used by up hosts and ok services
	yellow = "f2f200",	-- yellow color used by unreachable hosts and unknown services
	orange = "ff9900",	-- orange color used by warning services
	red =    "d90000",	-- red color used by down hosts and critical services
	gray =   "333333"	-- gray color used by all non problem status
}

function get_status()
	return select_status("all")
end


function get_status_resume()
	local total_hosts = 0
	local total_services = 0
	local status = nil
	local host_alert = nil
	local service_alert = nil
	
	status = select_status("all")

	host_alert = {   
		{ name= "up", 		status = HOST_UP,		num = 0, color = "green" },
		{ name= "down", 	status = HOST_DOWN,		num = 0, color = "red" },
		{ name= "unreachable",	status = HOST_UNREACHABLE,	num = 0, color = "yellow" },
		{ name= "pending", 	status = 0,			num = 0, color = "blue" }
	}

	service_alert = {
		{ name= "ok", 		status = STATE_OK,		num = 0, color = "green" },
		{ name= "warning", 	status = STATE_WARNING,		num = 0, color = "orange" },
		{ name= "critial", 	status = STATE_CRITICAL,	num = 0, color = "red" },
		{ name= "unknown", 	status = STATE_UNKNOWN,		num = 0, color = "yellow" },
		{ name= "pending",	status = 0,			num = 0, color = "blue" }
	}

	applic_alert = {   
		{ name= "up", 		status = APPLIC_UP,		color = "green" },
		{ name= "down", 	status = APPLIC_DOWN,		color = "red" },
		{ name= "warning",	status = APPLIC_WARNING,	color = "yellow" },
		{ name= "pending",	status = APPLIC_PENDING,	color = "blue" }
	}

	if status == nil then
		return nil
	else
		--  make resume for hosts
		for i, v in ipairs(status.hoststatus) do
			if v.has_been_checked == 1 then
				host_alert[v.current_state+1].num = host_alert[v.current_state+1].num + 1
			else
				host_alert[4].num = host_alert[4].num + 1			-- pending hosts
			end
			total_hosts = total_hosts + 1
		end

		--  make resume for services
		for i, v in ipairs(status.servicestatus) do
			if v.has_been_checked == 1 then
				service_alert[v.current_state+1].num = service_alert[v.current_state+1].num + 1
			else
				service_alert[5].num = service_alert[5].num + 1	-- pending services
			end
			total_services = total_services + 1
		end
	end

	return total_hosts, total_services, host_alert, service_alert, status
end


function get_applications_resume(apls)
	apls = apls or "all"
	local applic = select_applications(apls)
	local status = select_status("all")
	local app_resume = { }
	local resume = { }
	local host_status, service_status, app_status

	local _resume = { }
	local _app_resume = { }


	-- ITERACT THROW APPLICATIONS
	for i, ap in ipairs(applic) do
		app_status     = APPLIC_UP
		host_status    = HOST_UP
		service_status = STATE_OK
		local hosts_list    = { }
		local services_list = { }

		-- [[ DEBUG ]] print("-- APLIC: "..ap.name)

		-- HOSTS --
		for j, ap_h in ipairs(ap.hosts) do
			for l, z in ipairs(status.hoststatus) do
				if ( z.host_name == ap_h ) then
					-- ------------------
					host_status = z.current_state
					host_enable = z.active_checks_enabled
					--if app_status == APPLIC_UP or app_status == APPLIC_PENDING or app_status == APPLIC_WARNING then
--print(z.host_name, z.current_state, z.active_checks_enabled)
					if host_enable == 1 then
						if host_status == HOST_DOWN or host_status == HOST_UNREACHEBLE then
							app_status = APPLIC_DOWN
							table.insert(hosts_list, {z.host_name, z.plugin_output} )
							-- [[ DEBUG ]] print("hosts_list: " .. ap.name..":"..z.host_name)
						elseif host_status == HOST_PENDING then
							app_status = APPLIC_PENDING
						end
					end
					--end
					-- ------------------
				end
			end
		end

		-- SERVICES --
		for k, ap_s in ipairs(ap.services) do
			for l, z in ipairs(status.servicestatus) do
				if (( z.host_name == ap_s[2] ) and ( z.service_description == ap_s[1] )) then
					-- ------------------
					service_status = z.current_state
					service_enable = z.active_checks_enabled
					--if app_status == APPLIC_UP or app_status == APPLIC_WARNING or app_status == APPLIC_PENDING then
--print(z.host_name, z.current_state, z.active_checks_enabled)
					if service_enable == 1 then
						if service_status == STATE_CRITICAL or service_status == STATE_UNKOWN then
							app_status = APPLIC_DOWN
							table.insert(services_list, {z.host_name, z.service_description, z.plugin_output })
							-- [[ DEBUG ]] print("services_list: "..ap.name..":"..z.host_name.." , "..z.service_description)
						elseif service_status == STATE_PENDING then
							app_status = APPLIC_PENDING
							table.insert(services_list, {z.host_name, z.service_description, z.plugin_output })
						elseif service_status == STATE_WARNING then
							app_status = APPLIC_WARNING
							table.insert(services_list, {z.host_name, z.service_description, z.plugin_output })
						end
					end
					--end
					-- ------------------
				end
			end
		end

		app_resume = { name = ap.name, status = app_status, 
					hosts_down = hosts_list, services_down = services_list }
		table.insert(resume, app_resume)
	end

	-- [[ DEBUG ]] persistence.store("storage.lua", resume);
	return resume
end


function extract_from_ping(s)
	local a, b, result
	a,b = string.find(s,'RTA = *%d\.*%d ms')
	result = tonumber(string.sub(s, a+6,b-3))
	return result
end

--[[ EXAMPLES OF POSSIBLE PLUGIN-RESULTS
	plugin_output="PING OK - Packet loss = 0%, RTA = 6.30 ms",
	plugin_output="DNS OK: 0.135 seconds response time. www.globo.com returns 201.7.178.45",
	plugin_output="HTTP OK HTTP/1.0 200 OK - 117289 bytes in 0.521 seconds",
	plugin_output="HTTP OK HTTP/1.0 200 OK - 14727 bytes in 0.070 seconds",
	plugin_output="HTTP OK - HTTP/1.0 302 Found - 0.582 second response time",
	plugin_output="SSH OK - OpenSSH_4.7p1 Debian-8ubuntu1.2 (protocol 2.0)",
]]--
function extract_plugin_output(s)
	local a, b, c, d, result, service_name, search_string

	a, b = string.find(s,'^%a*%s*OK')
	if not a or not b then
		-- [[ DEBUG ]] print("extract_plugin_output error: Service string ["..s.."] not registered 1")
		result = 0
		return 0
	end

	service_name = string.sub(s, a, b-3)

	if service_name == 'PING' then
		--search_string = 'RTA = *%d\.*%d ms'
		search_string = 'RTA = %d+\.*%d+ ms'
	elseif service_name == 'HTTP' then
		search_string = '%d+\.%d+ second'
	elseif service_name == 'DNS' then
		search_string = ' %d+\.%d+ second'
	elseif service_name == 'Service DNS' then
		search_string = ' %d+\.%d+ second'
	elseif service_name == 'SSH' then
		search_string = ''
	elseif service_name == 'IMAP' then
		search_string = ' %d+\.%d+ second'
	elseif service_name == 'SMTP' then
		search_string = ' %d+\.%d+ sec\.'
	else
		-- [[ DEBUG ]] print("extract_plugin_output error: Service string ["..s.."] not registered 2")
		result = 0
		return 0
	end

	a, b = string.find(s,search_string)
	if not a or not b then
		-- [[ DEBUG ]] print("extract_plugin_output error: Service string ["..s.."] not registered 3")
		result = 0
		return 0
	end
	s_   = assert(string.sub(s, a, b))

	-- TO TREAT EXCEPTION
	-- When a command doesn't return any kind of time, it will be discarted
	-- by setting this value to 0.0 seconds.
	if s_ == '' then
		if service_name == 'SSH' then s_ = '0.0' end
	end

	c, d = string.find(s_, '%d+\.*%d+')
	s__  = string.sub(s_, c, d)

	result = tonumber(s__)
	-- [[ DEBUG ]] print('service = ', service_name, 'result = ', result)

	return result
end


function get_applications_eficiency(apls)
	apls = apls or "all"
	local applic = select_applications(apls)
	local status = select_status("all")

	local app_resume = { }
	local resume = { }

	local host_status, service_status, app_status

	local app_max  = 0
	local app_count  = 0
	local app_average  = 0

	local host_max = 0
	local host_count = 0
	local host_average = 0

	local serv_max = 0
	local serv_count = 0
	local serv_average = 0


	-- ITERACT THROW APPLICATIONS
	for i, ap in ipairs(applic) do
		app_status     = APPLIC_UP
		host_status    = HOST_UP
		service_status = STATE_OK

		--print('====================='..applic[i].name..'========================')

		app_max  = 0
		app_count  = 0
		app_average  = 0

		host_max = 0
		host_count = 0
		host_average = 0
		host_total = 0

		serv_max = 0
		serv_count = 0
		serv_average = 0
		serv_total = 0

		-- HOSTS --
		for j, ap_h in ipairs(ap.hosts) do
			for l, z in ipairs(status.hoststatus) do
				if ( z.host_name == ap_h ) then
					host_status = z.current_state
					if  host_status == HOST_UP then
						host_total = host_total + 1
						--host_efic = extract_from_ping(z.plugin_output)
						host_efic = extract_plugin_output(z.plugin_output)
						host_average = host_average + host_efic
						if host_efic ~= 0 then host_count = host_count + 1 end
						if host_max < host_efic then host_max = host_efic end

						-- [[ DEBUG ]] print(z.host_name, host_efic, host_average, z.plugin_output)
					end
				end
			end
		end
		if host_count ~= 0 then 
			host_average  = host_average / host_count
		end

		-- SERVICES --
		for k, ap_s in ipairs(ap.services) do
			for l, z in ipairs(status.servicestatus) do
				if (( z.host_name == ap_s[2] ) and ( z.service_description == ap_s[1] )) then
					service_status = z.current_state

					if service_status == STATE_OK then
						serv_total = serv_total + 1
						serv_efic = extract_plugin_output(z.plugin_output)
						serv_average = serv_average + serv_efic
						if serv_efic ~= 0 then serv_count = serv_count + 1 end
						if serv_max < serv_efic then serv_max = serv_efic end

						-- [[ DEBUG ]] print(z.serv_name, serv_efic, serv_average, z.plugin_output)
					end

				end
			end
		end

		if host_count == 0 then
			app_average = serv_average
		elseif serv_count == 0 then
			app_average = host_average
		elseif host_count ~= 0 and serv_count ~= 0 then 
			app_average = ( host_average + serv_average ) /2
		end

		if host_max > serv_max then app_max = host_max else app_max = serv_max end

		app_count  = host_count + serv_count


		--[[ DEBUG
		print(
			ap.name,
			app_max, app_count, app_average,
			host_max, host_count, host_average,
			serv_max, serv_count, serv_average
			)
		]]--

		app_resume = { name = ap.name, average = app_average, max = app_max, count = app_count,
			host_num = host_total, serv_num = serv_total }
		table.insert(resume, app_resume)

		--[[ DEBUG
		showtable(app_resume)
		showtable(ap)
		]]--
	end

	return resume
end


--[[
res = get_applications_resume()
showtable(res)
s = res[1].services_down
if s ~= nil then
	showtable(s)
else 
	print("s is nil")
end

s = res[1].hosts_down
if s ~= nil then
	showtable(s)
else 
	print("s is nil")
end

]]--
