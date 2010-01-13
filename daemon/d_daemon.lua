require 'm_io_util'			-- only used for 'showtable()' function
require 'm_contacts'
require 'm_applications_state'
require 'm_dbs'
require 'c_monitor'
require 'c_monitor_inc'

require 'd_daemon_conf'

-- Se declarar [old|new]_state NAO FUNCIONA!
--local old_state = {}
--local new_state = {}

function proc_app_state()
	old_state = select_application_state()
	new_state = get_applications_resume()
	set_applications_infos()

	--[[ DEBUG
	showtable(old_state)
	showtable(new_state)
	]]--

	if table.getn(old_state) > 0 then
		--compare_app_state(old_state, new_state)
		compare_app_state2(old_state, new_state)
	end
	insert_application_state(appl_state_toString(new_state))
end

function set_applications_infos()
	for _,v in ipairs(new_state) do
		v.date = os.date()
		v.time = os.time()
		v.has_changed = 0
		v.attempts = 0
		v.alert_sent = 0
	end
	-- [[ DEBUG ]] print( appl_state_toString(new_state) )
end


function compare_app_state2(old_state, new_state)
	for i,n in ipairs(new_state) do				-- iteracts throuth new application states
		found = false
		for j,o  in ipairs(old_state) do		-- for each new application state, iteracts throuth old states

			--print(n.name, o.name)
			if n.name == o.name then			-- if application found on old_state table...
				found = true
				if n.status == o.status then	-- state hasn't changed
					--print(n.name..' state HASN\'T changed')

					if n.status == APPLIC_UP then
						n.attempts = 0
					elseif n.status == APPLIC_DOWN then
						n.attempts = 0
					elseif n.status == APPLIC_WARNING then
						n.attempts = 0
					elseif n.status == APPLIC_PENDING then
						n.attempts = 0
					end

				else							-- else, if state has changed
					--print(n.name..' state HAS changed', o.status, n.status)
					-- from 'pending' status
					if o.status == APPLIC_PENDING and n.status == APPLIC_UP then
						n.attempts = 0
					elseif o.status == APPLIC_PENDING and n.status == APPLIC_DOWN then
						alert_dispatcher(n)
						log_dispatcher(n)
						n.attempts = 0
					elseif o.status == APPLIC_PENDING and n.status == APPLIC_WARNING then
						n.attempts = 0

					-- from 'up' to 'down'
					elseif o.status == APPLIC_UP and n.status == APPLIC_DOWN then
						n.attempts = o.attempts + 1
						--print(n.attempts, o.attempts)

						if n.attempts >= daemon_conf.max_check_attempts then
							--print('hi')
							alert_dispatcher(n)
							log_dispatcher(n)
							n.attempts = 0
						else
							--print('ho')
							n.status = APPLIC_UP -- don't change the status
						end

					-- from 'up' to 'warning'
					elseif o.status == APPLIC_UP and n.status == APPLIC_WARNING then
						log_dispatcher(n)
						n.attempts = 0

					-- from 'down' to 'up'
					elseif o.status == APPLIC_DOWN and n.status == APPLIC_UP then
						--print('down to up')
						alert_dispatcher(n)
						log_dispatcher(n)
						n.attempts = 0

					-- from 'down' to 'warning'
					elseif o.status == APPLIC_DOWN and n.status == APPLIC_WARNING then
						log_dispatcher(n)
						n.attempts = 0

					-- from 'warning' to 'up'
					elseif o.status == APPLIC_WARNING and n.status == APPLIC_UP then
						log_dispatcher(n)
						n.attempts = 0

					-- from 'warning' to 'down'
					elseif o.status == APPLIC_WARNING and n.status == APPLIC_DOWN then
						n.attempts = o.attempts + 1

						if n.attempts >= daemon_conf.max_check_attempts then
							alert_dispatcher(n)
							log_dispatcher(n)
							n.attempts = 0
						else
							n.status = APPLIC_WARNING -- don't change the status
						end
					end
				end

			end
		end
	if not found then
		n.attempts = 1
		n.status = APPLIC_UP
	end
	end
end



function compare_app_state(old_state, new_state)
	for i,n in ipairs(new_state) do				-- iteracts throuth new application states
		for j,o  in ipairs(old_state) do		-- for each new application state, iteracts throuth old states

			if n.name == o.name then			-- if application found on old_state table...
				--------------------------------------------
				if n.status == APPLIC_DOWN or n.status == APPLIC_WARNING then -- and if this applic is down then...
					n.attempts = o.attempts + 1	-- adds one attempt
					-- [[ DEBUG ]] print(n.name..' is DOWN or WARNING '..n.status)
					if n.attempts >= daemon_conf.max_check_attempts then -- if max_check_attenpts has reachead...
						-- [[ DEBUG ]] print('ST: '..n.status..' AT: '..n.attempts..' AS: '..o.alert_sent)
						if o.alert_sent == 0 then				 -- and if old status was UP 
							alert_dispatcher(n)
							log_dispatcher(n)
						end
						n.attempts = daemon_conf.max_check_attempts      -- n.attempts stays at maximum
						n.alert_sent = 1
					end
				end
				--------------------------------------------
				if n.status ~= o.status then
					-- [[ DEBUG ]] print(o.status..' -> '..n.status)
					if ( o.status == APPLIC_DOWN or o.status == APPLIC_WARNING ) 
									and n.status == APPLIC_UP and o.alert_sent == 1 then
						alert_dispatcher(n)
						log_dispatcher(n)
						n.alert_sent = 0
					end
					if o.status ~= APPLIC_UP and n.status ~= APPLIC_DOWN then -- if it was not a UP to DOWN change
						n.attempts = 0
					end
				end 
				--------------------------------------------
			end
		end
	end
end


function alert_dispatcher(app)
	app.has_changed = 0
	loca = os.setlocale('pt_BR')
	date = os.date()
	local hd = ''
	local sd = ''

--[[
	if app.status == 0 then
		state = 'UP'
	elseif app.status == 1 then
		state = 'DOWN'
	elseif app.status == 2 then
		state = 'WARNING'
	elseif app.status == 3 then
		state = 'PENDING'
	end
]]--
	if app.status == 0 then
		state = 'NORMALIZADO'
	elseif app.status == 1 then
		state = 'CRITICO'
	elseif app.status == 2 then
		state = 'ANORMAL'
	elseif app.status == 3 then
		state = 'PENDENTE DE VERIFICACAO'
	end

	-- [[ DEBUG ]] print ('ALERT BY EMAIL FOR APP: '..app.name..' WITH STATUS: '..state)


	-- List of the DOWN hosts and services
	for i, h in ipairs(app.hosts_down) do hd = hd..'\t- '..ic_get_label(1,h[1],3)..'\n' end -- Serialize 'hosts_down'
	for i, s in ipairs(app.services_down) do sd = sd..'\t- '..ic_get_label(1,s[2],3)..' (sendo executado em '..ic_get_label(1,s[1],3)..')\n' end -- Serialize 'services_down'
	if app.status == 0 then
		critical_ics = ''
	else
		critical_ics = 'Hardwares em estado STATE:\n'..hd..'\nServicos em estado STATE:\n'..sd..'\n'
	end

	e_msg = daemon_conf.notification_email
	e_msg = string.gsub(e_msg, 'CRITICAL_ICS', critical_ics)
	e_msg = string.gsub(e_msg, 'APPLIC_NAME', app.name)
	e_msg = string.gsub(e_msg, 'STATE', state)
	e_msg = string.gsub(e_msg, 'DATE', date)

	s_msg = daemon_conf.notification_sms
	s_msg = string.gsub(s_msg, 'APPLIC_NAME', app.name)
	s_msg = string.gsub(s_msg, 'STATE', state)
	s_msg = string.gsub(s_msg, 'DATE', date)

	contacts = get_contacts(function() return true end)
	--showtable(contacts)

	for _,v in ipairs(contacts) do
		for _,w in ipairs(v.applications) do
			if app.name == w then
				if v.e_mail ~= '' and v.e_mail ~= '-' and v.e_mail ~= nil then
					e_cmd = 'echo "'..e_msg..'" | '..daemon_conf.command_line 
						.. ' "ITVision - Monitor" '.. v.e_mail
					os.execute(e_cmd)
					--[[ DEBUG
					print('--- MAIL -------------------------')
					print(e_cmd)
					print('email')
					]]--
				end
				if v.sms ~= '' and v.sms ~= '-' and v.sms ~= nil then
					s_cmd = 'echo "'..s_msg..'" | '..daemon_conf.command_line 
						.. ' "ITVision - Monitor" '.. v.sms
					os.execute(s_cmd)
					--[[ DEBUG
					print('--- SMS -------------------------')
					print(s_cmd)
					print('sms')
					]]--
				end
			end
		end
	end
end

	
function log_dispatcher(app)
	local date = os.date("%Y-%m-%d %X")
	local time = os.time()
	local sep = '|'
	local hd = ''
	local sd = ''
	local filename = '/usr/local/itvision/model/db/alerts.log'

	if app.status == 0 then
		state = 'UP'
	elseif app.status == 1 then
		state = 'DOWN'
	elseif app.status == 2 then
		state = 'WARNING'
	elseif app.status == 3 then
		state = 'PENDING'
	end

	-- [[ DEBUG ]] print ('LOG FOR APP: '..app.name..' WITH STATUS: '..state)

	-- Serialize 'hosts_down' into 'hd' string
	for i, h in ipairs(app.hosts_down) do hd = hd..'/'..ic_get_label(1,h[1],3)..'+'..h[2] end
	hd = string.sub(hd, 2) -- remove first separator
	-- Serialize 'services_down' into 'sd' string
	for i, s in ipairs(app.services_down) do sd = sd..'/'..ic_get_label(1,s[2],3)..'+'..ic_get_label(1,s[1],3)..'+'..s[3] end
	sd = string.sub(sd, 2) -- remove first separator

	local line = date .. sep .. time .. sep .. app.name .. sep .. state .. sep .. hd .. sep .. sd
	local ofile, omess, oerr = assert(io.open(filename, 'a'))
	-- [[ DEBUG ]] print(line)

	ofile:write (line .. '\n')
	ofile:close()
end


function appl_state_toString(t, level)
	level = level or 0
	local s = ''

	for i,v in pairs (t) do
		if type(v) == 'table' and level == 0 then
			s = s .. 'application_state {\n'
			s = s .. appl_state_toString(v, 1)
			s = s .. '}\n\n'
		elseif type(v) == 'table' and level >= 1 then
			if level <= 1 then s = s .. '\t'..i..' = ' end
			s = s .. '\t{'
			s = s .. appl_state_toString(v, 2)
			s = s .. '\t},\n'
		elseif type(v) == 'string' then
			if level <= 1 then s = s .. '\t'..i..' = ' end
			s = s .. '\t"'..tostring(v)..'",\n'
		else
			s = s .. '\t'..i..' = '..tostring(v)..',\n'
		end
	end

	return s
end



