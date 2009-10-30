require 'm_io_util'			-- only used for 'showtable()' function
require 'c_monitor'
require 'c_monitor_inc'

--[[ 
	TODO: Eh possivel generalizar a funcao "appl_state_toString" de "d_daemon.lua"
    e utiliza-la para gravar as informacoes relativas as eficiencias!!! 

	Hoje essas informacoes estao sendo gravadas em um arquivo tipo CSV nomeado logo a baixo!
]]--

local filename = '/usr/local/itvision/model/db/db_eficiency.log'
local sep = '|'

function resume_eficiency ()

	local old_efic = read_applications_eficiency()

	local resume = { 
		name          = "Resume",
		max_last      = 0.0,
		max_day       = 0.0,
		max_week      = 0.0,
		max_month     = 0.0,
		max_year      = 0.0,
		average_last  = 0.0,
		average_day   = 0.0,
		average_week  = 0.0,
		average_month = 0.0,
		average_year  = 0.0,
		count_day     = 0,
		count_week    = 0,
		count_month   = 0,
		count_year    = 0,
		day           = curr_day,
		week          = curr_week,
		month         = curr_month,
		year          = curr_year,
		count_applic  = 0
	}

	if not old_efic then return resume end

	for i, v in ipairs(old_efic) do
		local w = {
			name          = v[1],
			max_last      = tonumber(v[2]),
			max_day       = tonumber(v[3]),
			max_week      = tonumber(v[4]),
			max_month     = tonumber(v[5]),
			max_year      = tonumber(v[6]),
			average_last  = tonumber(v[7]),
			average_day   = tonumber(v[8]),
			average_week  = tonumber(v[9]),
			average_month = tonumber(v[10]),
			average_year  = tonumber(v[11]),
			count_day     = tonumber(v[12]),
			count_week    = tonumber(v[13]),
			count_month   = tonumber(v[14]),
			count_year    = tonumber(v[15]),
			day           = v[16],
			week          = v[17],
			month         = v[18],
			year          = v[19]
		}

		if resume.max_last  < w.max_last  then resume.max_last  = w.max_last  end
		if resume.max_day   < w.max_day   then resume.max_day   = w.max_day   end
		if resume.max_week  < w.max_week  then resume.max_week  = w.max_week  end
		if resume.max_month < w.max_month then resume.max_month = w.max_month end
		if resume.max_year  < w.max_year  then resume.max_year  = w.max_year  end

		resume.average_last  = (( resume.average_last  * (i-1) ) + w.average_last )  / i
		resume.average_day   = (( resume.average_day   * (i-1) ) + w.average_day )   / i
		resume.average_week  = (( resume.average_week  * (i-1) ) + w.average_week )  / i
		resume.average_month = (( resume.average_month * (i-1) ) + w.average_month ) / i
		resume.average_year  = (( resume.average_year  * (i-1) ) + w.average_year )  / i

		resume.count_day   = (( resume.count_day   * (i-1) ) + w.count_day )   / i
		resume.count_week  = (( resume.count_week  * (i-1) ) + w.count_week )  / i
		resume.count_month = (( resume.count_month * (i-1) ) + w.count_month ) / i
		resume.count_year  = (( resume.count_year  * (i-1) ) + w.count_year )  / i

		resume.count_applic = i
	end

	return resume
end

function calc_applications_eficiency(old_efic, curr_efic)
	local ini_efic = init_applications_eficiency(old_efic) 
	--[[ DEBUG
	print('~INI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	showtable(ini_efic[4])
	]]--

	local curr_day, curr_week, curr_month, curr_year
	local applic_efic = {} 
	local resume = {}
	local applic = select_applications('all')

	curr_day   = os.date('%d')
	curr_week  = os.date('%w')
	curr_month = os.date('%m')
	curr_year  = os.date('%Y')

	local i, j, k, v, w, s, curr_i

	--[[
		curr_efic[i] = { 
			name     = ap.name, 
			average  = app_average, 
			max      = app_max, 
			count    = app_count,
			host_num = host_total, 
			serv_num = serv_total 
		}
	]]--

	for i, v in ipairs(applic) do
		for j, w in ipairs(ini_efic) do

			for k, s in ipairs(curr_efic) do
				if v.name == s.name then
					curr_i = k
					break
				end
			end

			-- [[ DEBUG ]] print("     w.name = "..w.name)
			if v.name == w.name then
				--resume = {}
				--resume.name = w.name

				resume = { 
					name          = w.name,
					max_last      = 0.0,
					max_day       = 0.0,
					max_week      = 0.0,
					max_month     = 0.0,
					max_year      = 0.0,
					average_last  = 0.0,
					average_day   = 0.0,
					average_week  = 0.0,
					average_month = 0.0,
					average_year  = 0.0,
					count_day     = 0,
					count_week    = 0,
					count_month   = 0,
					count_year    = 0,
					day           = curr_day,
					week          = curr_week,
					month         = curr_month,
					year          = curr_year
				}

				resume.max_last     = curr_efic[curr_i].max
				resume.average_last = curr_efic[curr_i].average

				-- DAY resume
				if ( w.day..w.month..w.year ~= curr_day..curr_month..curr_year ) then
					resume.count_day = 1
					resume.max_day = curr_efic[curr_i].max
					resume.average_day = curr_efic[curr_i].average
				else
					resume.count_day = w.count_day + 1
					if w.max_day < curr_efic[curr_i].max then 
						resume.max_day = curr_efic[curr_i].max else
						resume.max_day = w.max_day end
					resume.average_day = ((w.average_day * w.count_day) + curr_efic[curr_i].average) / 
											resume.count_day
				end
				resume.day = curr_day

				-- WEEK resume
				if ( curr_week == "0" and w.day..w.month..w.year ~= curr_day..curr_month..curr_year ) then
					resume.count_week = 1
					resume.max_week = curr_efic[curr_i].max
					resume.average_week = curr_efic[curr_i].average
				else
					resume.count_week = w.count_week + 1
					if w.max_week < curr_efic[curr_i].max then 
						resume.max_week = curr_efic[curr_i].max else
						resume.max_week = w.max_week end
					resume.average_week = ((w.average_week * w.count_week) + curr_efic[curr_i].average) / 
											resume.count_week
				end
				resume.week = curr_week

				-- MONTH resume
				if ( w.month..w.year ~= curr_month..curr_year ) then
					resume.count_month = 1
					resume.max_month = curr_efic[curr_i].max
					resume.average_month = curr_efic[curr_i].average
				else
					resume.count_month = w.count_month + 1
					if w.max_month < curr_efic[curr_i].max then 
						resume.max_month = curr_efic[curr_i].max else
						resume.max_month = w.max_month end
					resume.average_month = ((w.average_month * w.count_month) + curr_efic[curr_i].average) / 
											resume.count_month
				end
				resume.month = curr_month

				-- YEAR resume
				if ( w.year ~= curr_year ) then
					resume.count_year = 1
					resume.max_year = curr_efic[curr_i].max
					resume.average_year = curr_efic[curr_i].average
				else
					resume.count_year = w.count_year + 1
					if w.max_year < curr_efic[curr_i].max then 
						resume.max_year = curr_efic[curr_i].max else
						resume.max_year = w.max_year end
					resume.average_year = ((w.average_year * w.count_year) + curr_efic[curr_i].average) / 
											resume.count_year
				end
				resume.year = curr_year

				table.insert(applic_efic, resume)
				break
			end
		end
	end

	return applic_efic
end


function init_applications_eficiency(old_efic)
	old_efic = old_efic or { "dummy table" }

	local curr_day, curr_week, curr_month, curr_year
	local applic_efic = {} 
	local resume = {}
	local applic = select_applications('all')

	curr_day   = os.date('%d')
	curr_week  = os.date('%w')
	curr_month = os.date('%m')
	curr_year  = os.date('%Y')

	for i, v in ipairs(applic) do
		resume = { 
			name          = v.name,
			max_last      = 0.0,
			max_day       = 0.0,
			max_week      = 0.0,
			max_month     = 0.0,
			max_year      = 0.0,
			average_last  = 0.0,
			average_day   = 0.0,
			average_week  = 0.0,
			average_month = 0.0,
			average_year  = 0.0,
			count_day     = 0,
			count_week    = 0,
			count_month   = 0,
			count_year    = 0,
			day           = curr_day - 1,
			week          = curr_week - 1,
			month         = curr_month - 1,
			year          = curr_year - 1
		}

		for j, w in ipairs(old_efic) do
			if w[1] == v.name then
				resume = {
					name          = w[1],
					max_last      = tonumber(w[2]),
					max_day       = tonumber(w[3]),
					max_week      = tonumber(w[4]),
					max_month     = tonumber(w[5]),
					max_year      = tonumber(w[6]),
					average_last  = tonumber(w[7]),
					average_day   = tonumber(w[8]),
					average_week  = tonumber(w[9]),
					average_month = tonumber(w[10]),
					average_year  = tonumber(w[11]),
					count_day     = tonumber(w[12]),
					count_week    = tonumber(w[13]),
					count_month   = tonumber(w[14]),
					count_year    = tonumber(w[15]),
					day           = w[16],
					week          = w[17],
					month         = w[18],
					year          = w[19]
				}
				break
			end
		end

		table.insert(applic_efic, resume)
	end

	return applic_efic
end


--[[ 
	TODO: Eh possivel generalizar a funcao "appl_state_toString" de "d_daemon.lua"
    e utiliza-la para gravar as informacoes relativas as eficiencias!!! 
]]--



function read_applications_eficiency()
	local e = {}
	local old = {}
	local efic = line_reader(filename)

	if not efic then return nil end

	for i, ve in ipairs(efic) do
		e = fromCSV(ve,sep)
		table.insert(old,  e)
	end

	return old
end


function write_applications_eficiency(new_efic)
	local f = io.open(filename, 'w')
	f:close()
	f = io.open(filename, 'a')

	for i, v in ipairs(new_efic) do
		-- RE-ORDER TABLE
		efic_ordered = { 
			v.name,
			v.max_last,
			v.max_day,
			v.max_week,
			v.max_month,
			v.max_year,
			v.average_last,
			v.average_day,
			v.average_week,
			v.average_month,
			v.average_year,
			v.count_day,
			v.count_week,
			v.count_month,
			v.count_year,
			v.day,
			v.week,
			v.month,
			v.year
		}

		s = toCSV(efic_ordered,sep)
		f:write(s..'\n')

	end
	f:close()
end


