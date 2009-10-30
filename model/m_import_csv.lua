--[[ FUNCTIONS DEFINED IN THIS FILE

	function make_cfg_file() 		-- Create nagios config files from ...
	function make_host_cfg_file()	-- Create host config file
	function make_appl_cfg_file()	-- Create application config file
	function make_serv_cfg_file()	-- Create service config file
	function make_user_cfg_file()	-- Create User config file
	function make_proc_cfg_file()	-- Create Procedures config file
	function find_host_in_ic(key, ic) -- Locate host entry in IC table

]]--

require 'm_io_util'
require 'c_util'

local config = {
	-- input/output directories
	   object_dir = '/usr/local/monitor/etc/objects/history/',
	       db_dir = '/usr/local/itvision/model/db/',
	      csv_dir = '/usr/local/itvision/model/input/',
	  monitor_dir = '/usr/local/monitor/',

	-- itvision output files
	 ics_cfg_file = 'db_ics.lua',
	 rel_cfg_file = 'db_relations.lua',
	 cmd_cfg_file = 'db_checkcmds.lua',
	proc_cfg_file = 'db_procedures.lua',
	user_cfg_file = 'db_contacts.lua',
	appl_cfg_file = 'db_applications.lua',

	-- nagios output files
	host_cfg_file = 'hosts.cfg',
	serv_cfg_file = 'services.cfg',

	-- input (csv) file
	 ics_csv_file = '/usr/local/itvision/model/input/ics.csv',
	 rel_csv_file = '/usr/local/itvision/model/input/relacionamentos.csv',
	 cmd_csv_file = '/usr/local/itvision/model/input/checkcmds.csv',
	user_csv_file = '/usr/local/itvision/model/input/contatos.csv',
	proc_csv_file = '/usr/local/itvision/model/input/procedimentos.csv',

}


-- Create nagios and itvision config files
function make_cfg_file()
	os_date = os.date('%Y_%m_%d-%H:%M')

	--[[ OBJECT DIR (NAGIOS) 
		ORIGINAL FILES ARE NOW SAVED BY import-csv SHELL SCRIPT !
	os.execute('mkdir -p '..config.object_dir..'/history/')
	os.execute('cp '..config.object_dir..config.host_cfg_file..' '
			..config.object_dir..'/history/'..config.host_cfg_file..'_'..os_date)
	os.execute('cp '..config.object_dir..config.serv_cfg_file..' '
			..config.object_dir..'/history/'..config.serv_cfg_file..'_'..os_date)
	]]--

	-- DATABASE DIR(ITVision DB)
	os.execute('mkdir -p '..config.db_dir..'/history/')
	os.execute('cp '..config.db_dir..config.ics_cfg_file..' '
			..config.db_dir..'/history/'..config.ics_cfg_file..'_'..os_date)
	os.execute('cp '..config.db_dir..config.rel_cfg_file..' '
			..config.db_dir..'/history/'..config.rel_cfg_file..'_'..os_date)
	os.execute('cp '..config.db_dir..config.cmd_cfg_file..' '
			..config.db_dir..'/history/'..config.cmd_cfg_file..'_'..os_date)
	os.execute('cp '..config.db_dir..config.proc_cfg_file..' '
			..config.db_dir..'/history/'..config.proc_cfg_file..'_'..os_date)
	os.execute('cp '..config.db_dir..config.user_cfg_file..' '
			..config.db_dir..'/history/'..config.user_cfg_file..'_'..os_date)
	os.execute('cp '..config.db_dir..config.appl_cfg_file..' '
			..config.db_dir..'/history/'..config.appl_cfg_file..'_'..os_date)


	host_cfg, ics = make_host_cfg_file()
	io.output(config.object_dir..config.host_cfg_file)
	io.write(host_cfg)
	io.output(config.db_dir..config.ics_cfg_file)
	io.write('ics = '..toString(ics))

	appl_cfg, rel = make_appl_cfg_file()
	io.output(config.db_dir..config.appl_cfg_file)
	io.write(appl_cfg)
	io.output(config.db_dir..config.rel_cfg_file)
	io.write('relations = '..toString(rel))

	serv_cfg, cmd  = make_serv_cfg_file()
	io.output(config.object_dir..config.serv_cfg_file)
	io.write(serv_cfg)
	io.output(config.db_dir..config.cmd_cfg_file)
	io.write('checkcmds = '..toString(cmd))

	user_cfg, user = make_user_cfg_file()          -- user_cfg have the same content but different forms
	io.output(config.db_dir..config.user_cfg_file)
	io.write(user_cfg)

	proc = make_proc_cfg_file()
	io.output(config.db_dir..config.proc_cfg_file)
	io.write('procedures = '..toString(proc))

	--print(os.execute(config.monitor_dir..'bin/nagios -v '..config.monitor_dir..'etc/nagios.cfg'))
	--print(os.execute('service nagios restart'))
end


-- Create host config file
function make_host_cfg_file()
	local ic = {}
	lines = line_reader(config.ics_csv_file)

	
	host_cfg = '# Host config file automatically generated by ITVision\n\n'
	for i,v in ipairs(lines) do
		if i ~= 1 then
			e = fromCSV(v)
--showtable(e)
			table.insert(ic, e)
			if e[6] ~= 'NA' and e[6] ~= 'na' and e[6] ~= '' and e[6] ~= '-' then
				host_cfg = host_cfg .. '# Key: '..e[1]..'; Hostname: '..e[4]..'; IP: '..e[6]..'\n'
				host_cfg = host_cfg .. [[define host{
  use                    generic-server            ; Name of host template to use
  host_name              ]].. e[1] ..[[ 
  alias                  ]].. e[1] ..[[ 
  address                ]].. e[6] ..[[ 
}

]]
			end
		end
	end 

	return host_cfg, ic
end


-- Locate host entry in IC table
function find_host_in_ic(key, ic)
	local res = 0
	for i,v in ipairs(ic) do 
		--if v[1] == key then
		if v[1] == key and v[6] ~= 'NA' and v[6] ~= 'na' and v[6] ~= '' and v[6] ~= '-' then -- index 6 correspond to IP column
			res = i
			break
		end 
	end
	return res
end


-- Create application config file
function make_appl_cfg_file()
	local rel = {}
	local appl = {}
	local host = {}
	local serv = {}
	local pair = {}
	local a = 0
	local b = 0
	
	-- read host csv file
	_, ic = make_host_cfg_file()
	-- read application csv file
	lines = line_reader(config.rel_csv_file)

	-- iteract throw the lines of the relation csv file
	for i,v in ipairs(lines) do
		if i ~= 1 then
			e = fromCSV(v)
			table.insert(rel,  e)
			table.insert(appl, e[1])
		end
	end 
	appl = table.uniq(appl)

	for i,v in ipairs(appl) do
		h = {}
		s = {}
		p = {}
		for _,w in ipairs(rel) do
			if w[1] == v then
				a =  find_host_in_ic(w[2], ic)
				b =  find_host_in_ic(w[4], ic)

				if a > 0 then table.insert(h, w[2]) end 
				if b > 0 then table.insert(h, w[4]) end 

				if w[5] ~= 'NA' and w[5] ~= 'na' and w[5] ~= '' and w[5] ~= '-' then
					table.insert(s, { w[2], w[4], w[5]})
				else
					table.insert(p, { w[2], w[4], w[5]})
				end
			end
		end

		h = table.uniq(h)
		table.insert(host, h)
		table.insert(serv, s)
		table.insert(pair, p)
	end

	applic_cfg = '-- Application config file automatically generated by ITVision\n\n'
	for i,v in ipairs(appl) do
		-- APPLICATION
		applic_cfg = applic_cfg .. 'application {\n\tname = "'..v..'",\n'

		-- APPLICATION's HOSTS
		applic_cfg = applic_cfg .. '\thosts = {\n'
		for _,w in ipairs(host[i]) do
			applic_cfg = applic_cfg .. '\t\t"'..w..'",\n'
		end
		applic_cfg = applic_cfg .. '\t},\n'

		-- APPLICATION's SERVICES
		applic_cfg = applic_cfg .. '\tservices = {\n'
		for _,w in ipairs(serv[i]) do
			applic_cfg = applic_cfg .. '\t\t{"'..w[1]..'","'..w[2]..'"},\n'
		end
		applic_cfg = applic_cfg .. '\t},\n'

		-- APPLICATION's DEPENDENCIES 
		applic_cfg = applic_cfg .. '\tdependencies = {\n'
		for _,w in ipairs(pair[i]) do
			applic_cfg = applic_cfg .. '\t\t{"'..w[1]..'","'..w[2]..'"},\n'
		end
		applic_cfg = applic_cfg .. '\t}\n'

		applic_cfg = applic_cfg .. '}\n\n'
	end

	return applic_cfg, rel
end

-- Create service config file
function make_serv_cfg_file()
	local serv = {}
	local cmds = {}
	
	-- read relation csv file
	rel_lines = line_reader(config.rel_csv_file)
	cmd_lines = line_reader(config.cmd_csv_file)

	-- iteract throw the lines of the relation csv file
	for i,v in ipairs(rel_lines) do
		if i ~= 1 then table.insert(serv,  fromCSV(v)) end
	end 

	-- iteract throw the lines of the cmd_check csv file
	for i,v in ipairs(cmd_lines) do
		if i ~= 1 then table.insert(cmds,  fromCSV(v)) end
	end 

	local cmd_check = function (cmd_name)
		for _,w in ipairs(cmds) do
			if w[1] == cmd_name then return w[2] end
		end
		return ''
	end

	serv_cfg = '# Service config file automatically generated by ITVision\n\n'
	for i,v in ipairs(serv) do
		if (v[5] ~= 'NA') and (v[5] ~= 'na') and (v[5] ~= '') and (v[6] ~= '-') then
			serv_cfg = serv_cfg .. 'define service {\n\tuse\t\t\t\t\t\tgeneric-service\n'
			serv_cfg = serv_cfg .. '\thost_name\t\t\t\t'..v[4]..'\n'
			serv_cfg = serv_cfg .. '\tservice_description\t\t'..v[2]..'\n'
			serv_cfg = serv_cfg .. '\tcheck_command\t\t\t'..cmd_check(v[5])..'\n'
			serv_cfg = serv_cfg .. '}\n\n\n'
		end
	end

	return serv_cfg, cmds
end



-- Create User config file
function make_user_cfg_file()
	local user = {}
	lines = line_reader(config.user_csv_file)
	
	user_cfg = '# User (contacts) config file automatically generated by ITVision\n\n'
	for i,v in ipairs(lines) do
		if i ~= 1 then
			e = fromCSV(v)
			table.insert(user, e)
			user_cfg = user_cfg .. 'contact {\n'
			user_cfg = user_cfg .. '\tname   = "'..e[1]..'",\n'
			user_cfg = user_cfg .. '\tlocation  = "'..e[2]..'",\n'
			user_cfg = user_cfg .. '\tdepto  = "'..e[3]..'",\n'
			user_cfg = user_cfg .. '\ttel_1  = "'..e[4]..'",\n'
			user_cfg = user_cfg .. '\ttel_2  = "'..e[5]..'",\n'
			user_cfg = user_cfg .. '\tcel    = "'..e[6]..'",\n'
			user_cfg = user_cfg .. '\te_mail = "'..e[7]..'",\n'
			user_cfg = user_cfg .. '\tsms    = "'..e[8]..'",\n'
			user_cfg = user_cfg .. '\tturno  = "'..e[9]..'",\n'
			user_cfg = user_cfg .. '\tapplications = {'..e[10]..'},\n'
			user_cfg = user_cfg .. '}\n\n'
		end
	end 

	return user_cfg, user
end


-- Create Procedures config file
function make_proc_cfg_file()
	local proc = {}
	lines = line_reader(config.proc_csv_file)
	
	for i,v in ipairs(lines) do
		if i ~= 1 then
			table.insert(proc, fromCSV(v))
		end
	end

	return proc
end

