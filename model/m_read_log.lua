require 'm_io_util'
require 'm_applications'
require 'c_date'

-- List entries in ALERT-LOG limited by 'ini' and 'fin' dates, using 'sep' separator.
-- If 'bFile' string specified, the result will be recorded in a file with this name.
function alert_report_list(app, ini, fin, sep, bFile)
	sep = sep or ','
	app = string.gsub(app, "_", " ")

	local time = os.time()
	local log_file = '/usr/local/itvision/model/db/alerts.log'
	local tmp_file = '/tmp/alerts.'..time
	local ofile, omess, oerr
	local s = ''
	local t = ''
	local result = {}

	-- If it's anything else but nil, it will write the result into a file them return the name of this file. 
	if bFile then
		ofile, omess, oerr = assert(io.open(tmp_file, 'w'))
	end

	di = string.sub(ini, 1, 2); mi = string.sub(ini, 4, 5); yi = string.sub(ini, 7, 10)
	df = string.sub(fin, 1, 2); mf = string.sub(fin, 4, 5); yf = string.sub(fin, 7, 10)
	ti = os.time{year=yi, month=mi, day=di, hour=0}
	tf = os.time{year=yf, month=mf, day=df+1, hour=0} -1

	--[[ DEBUG
	print(yi..mi..di)
	print(yf..mf..df)
	print(os.date('%Y-%m-%d %H:%M:%S', ti))
	print(os.date('%Y-%m-%d %H:%M:%S', tf))
	print('app = '..app..' and sep = '..sep) 
	]]--

	local lines = line_reader(log_file)

	for i,v in ipairs(lines) do
		t = fromCSV(v, '|')

		if (app == t[3] or app == '') and ti < tonumber(t[2]) and tf > tonumber(t[2]) then
			table.insert(result, t)
			s = s .. toCSV(t,sep) .. '\n'
			-- [[ DEBUG ]] print(s)

			if bFile then
				ofile:write (s .. '\n')
			end
		end
	end
	
	if bFile then
		ofile:close()
		return tmp_file
	else
		return s, result
	end
end


-- ALMOST THE SAME AS THE FUNCTION 'alert_report_list()' ABOVE !!!
-- ... but it returns only a table and includes one event before 'ini' date if exists.
function alert_report_list_2(app, ini, fin, sep)
	sep = sep or ','
	app = string.gsub(app, "_", " ")

	local time = os.time()
	local log_file = '/usr/local/itvision/model/db/alerts.log'
	local t = ''
	local result_ = {}
	local result = {}
	local min = 0
	local max = 0

	di = string.sub(ini, 1, 2); mi = string.sub(ini, 4, 5); yi = string.sub(ini, 7, 10)
	df = string.sub(fin, 1, 2); mf = string.sub(fin, 4, 5); yf = string.sub(fin, 7, 10)
	ti = os.time{year=yi, month=mi, day=di, hour=0}
	tf = os.time{year=yf, month=mf, day=df+1, hour=0} -1

	local lines = line_reader(log_file)

	for i,v in ipairs(lines) do
		t = fromCSV(v, '|')

		if (app == t[3] or app == '') then
			table.insert(result_, t)
		end
	end

	for i,v in ipairs(result_) do
		if ( ti < tonumber(v[2]) and min == 0 ) then
			min = i
		end

		if ( tf > tonumber(v[2]) ) then
			max = i
		end
	end

	if min == 0 then max = 0 end
	if max == 0 then min = 0 end
	if min > max then min = 0; max = 0 end

	if min ~= 0  then
		for i,v in ipairs(result_) do
			if i >= min and i <= max then
				table.insert(result, v)
			end
		end
	end

	return result
end


function alert_report_resume(app, ini, fin)
	app = string.gsub(app, "_", " ")

	local Tt, nu, nw, nd, itu, wti, dti, n, e, a, te, statei, statef, s
	local t = {}
	local r = {}
	local app_list = {}

	-- s, t = alert_report_list(app, ini, fin)
	t = alert_report_list_2(app, ini, fin)

	if ( app == '' ) then
		app_list = select_applications('')
	else
		app_list = { { name = app } }
	end

	di = string.sub(ini, 1, 2); mi = string.sub(ini, 4, 5); yi = string.sub(ini, 7, 10)
	df = string.sub(fin, 1, 2); mf = string.sub(fin, 4, 5); yf = string.sub(fin, 7, 10)
	ti = os.time{year=yi, month=mi, day=di, hour=0}
	tf = os.time{year=yf, month=mf, day=df+1, hour=0} -1

	--[[ DEBUG
	print('-------------')
	print(app)
	print('-------------')
	print('ini = '..ini..' -> '..ti)
	print('fim = '..fin..' -> '..tf)
	print('-------------')
	showtable(t)
	showtable(app_list)
	print('-------------')
	]]--

	for _, a in ipairs(app_list) do
		Tt = tf - ti
		te = 0 -- event time

		nu = 0 -- number of up events
		nw = 0 -- number of warning events
		nd = 0 -- number of down events

		uti = ti -- initial uptime
		wti = ti -- initial warningtime
		dti = ti -- initial downtime

		ut = 0 -- total uptime
		wt = 0 -- total warningtime
		dt = 0 -- total downtime

		first = true
		for n, e in ipairs(t) do
			--[[ DEBUG ]]-- showtable(e)
			if ( a.name == e[3] ) then
				te = e[2]
				statef = e[4]
				if ( first ) then -- TODO: THIS IS A BAD statei INITIALIZATION!!!!
					if ( statef == 'DOWN' ) then
						statei = 'UP'
					else
						statei = 'DOWN'
					end
					first = false
				end

				if ( statei == 'UP' and statef == 'WARNING' ) then
					wti = te
					ut = ut + (te - uti)
					nw = nw + 1
				elseif ( statei == 'UP' and statef == 'DOWN' ) then
					dti = te
					ut = ut + (te - uti)
					nd = nd + 1
				elseif ( statei == 'WARNING' and statef == 'UP' ) then
					uti = te
					wt = wt + (te - wti)
					nu = nu + 1
				elseif ( statei == 'WARNING' and statef == 'DOWN' ) then
					dti = te
					wt = wt + (te - wti)
					nd = nd + 1
				elseif ( statei == 'DOWN' and statef == 'UP' ) then
					uti = te
					dt = dt + (te - dti)
					nu = nu + 1
				elseif ( statei == 'DOWN' and statef == 'WARNING' ) then
					wti = te
					dt = dt + (te - dti)
					nw = nw + 1
				end

				--[[ DEBUG ]]-- print(a.name, statei, statef, ut, dt, wt, te)
				statei = statef
			end
		end

		if ( te ~= 0 ) then  -- (te == 0) mean that there was no event
			if ( statef == 'UP' ) then
				ut = ut + (tf - te)
			elseif ( statef == 'WARNING' ) then
				wt = wt + (tf - te)
			elseif ( statef == 'DOWN' ) then
				dt = dt + (tf - te)
			end
		end

		if ( ut == 0 and wt == 0 and dt == 0 ) then 
			ut = Tt
		end

		--[[ DEBUG
		if ( a.name == 'DNS Externo' ) then
			print(a.name..': ', ut, wt, dt, ut+wt+dt)
		end
		]]--

		table.insert(r, { name = a.name, totaltime = Tt, 
			uptime = ut, warntime = wt, downtime = dt, 
			n_up = nu, n_warn = nw, n_down = nd} )

		-- [[ DEBUG ]] -- showtable(r)
	end

	return table.getn(r), r

end

----------- 4 -----------------

-- reads alert log file and separate events by application
function alert_report_list_4(app, ini, fin, sep)
	sep = sep or ','
	--app = string.gsub(app, "_", " ")

	local time = os.time()
	local log_file = '/usr/local/itvision/model/db/alerts.log'
	local t = ''
	local result = {}
	local app_name

	if ( app == '' ) then
		app_list = select_applications('')
	else
		app_list = { { name = app } }
	end

	di = string.sub(ini, 1, 2); mi = string.sub(ini, 4, 5); yi = string.sub(ini, 7, 10)
	df = string.sub(fin, 1, 2); mf = string.sub(fin, 4, 5); yf = string.sub(fin, 7, 10)
	ti = os.time{year=yi, month=mi, day=di, hour=0}
	tf = os.time{year=yf, month=mf, day=df+1, hour=0} -1

	for _, a in ipairs(app_list) do
		result[a.name] = { events = {}, min = 0, max = 0 }    -- THIS LINE DETERMINES THE RESULT STRUCTURE
	end

	--showtable(result)

	-- Read log file line by line
	local lines = line_reader(log_file)
	if lines then 
		for i,v in ipairs(lines) do
			t = fromCSV(v, '|')
			app_name = t[3]
	
			if ( result[app_name] == nil ) then
				result[app_name] = { events = {}, min = 0, max = 0 } -- THIS LINE DETERMINES THE RESULT STRUCTURE
			end

			table.insert(result[app_name].events, t)
		end
	end

	--showtable(result)

	for _, a in ipairs(app_list) do
		for i, v in ipairs(result[a.name].events) do
			if ( ti < tonumber(v[2]) and result[a.name].min == 0 ) then
				if ( i == 1 ) then
					result[a.name].min = 1
				else
					result[a.name].min = i - 1
				end
			end

			if ( tf > tonumber(v[2]) ) then
				result[a.name].max = i
			end

			--[[
			if result[a.name].min == 0 then result[a.name].max = 0 end
			if result[a.name].max == 0 then result[a.name].min = 0 end
			if result[a.name].min > result[a.name].max then result[a.name].min = 0; result[a.name].max = 0 end
			]]--
		end
		if result[a.name].min == 0 then result[a.name].min = 1 end
	end

	return result
end

function alert_report_resume_4(app, ini, fin)
	--[[ DATA-DICT
	result = {
		{ 
			name = a.name, 
			totaltime = Tt, 
			uptime = ut, 
			warntime = wt, 
			downtime = dt, 
			n_up = nu, 
			n_warn = nw, 
			n_down = nd
		}
		,'REPEAT'
	}
	]]--
	--app = string.gsub(app, "_", " ")

	local Tt, nu, nw, nd, itu, wti, dti, n, e, a, te, statei, statef, s
	local t = {}
	local r = {}
	local app_list = {}

	t = alert_report_list_4(app, ini, fin)

	-- showtable(t['Infra'].events)

	if ( app == '' ) then
		app_list = select_applications('')
	else
		app_list = { { name = app } }
	end

	di = string.sub(ini, 1, 2); mi = string.sub(ini, 4, 5); yi = string.sub(ini, 7, 10)
	df = string.sub(fin, 1, 2); mf = string.sub(fin, 4, 5); yf = string.sub(fin, 7, 10)
	ti = os.time{year=yi, month=mi, day=di, hour=0}
	tf = os.time{year=yf, month=mf, day=df, hour=0}


	--[[ DEBUG
	print('-------------')
	print(app)
	print('-------------')
	print('ini = '..ini..' -> '..ti)
	print('fim = '..fin..' -> '..tf)
	print('-------------')
	showtable(t)
	showtable(app_list)
	print('-------------')
	]]--

	for _, a in ipairs(app_list) do
		--[[
		if ( t[a.name].min ~= 0 ) then
			print('ti = ', ti)
			showtable(os.date('*t', ti))
			to = t[a.name].events[t[a.name].min][2]
			print('to = ', to)
			print('ti - to = ', ti-to)
			showtable(os.date('*t', to))
			ti = to
		end
		]]--
		--print("==========================================")
		--print(t[a.name].events[t[a.name].min][2])
		--print("==========================================")
		--showtable(t[a.name].events)
		--print("==========================================")
		--showtable(t[a.name].events[t[a.name].min])
		--print("==========================================")

		--print(t[a.name].min)
		--to = tonumber(t[a.name].events[t[a.name].min][2])
		to = ti
		if ti < to then ti = to end

		Tt = tf - ti
		te = 0 -- event time

		nu = 0 -- number of up events
		nw = 0 -- number of warning events
		nd = 0 -- number of down events

		uti = ti -- initial uptime
		wti = ti -- initial warningtime
		dti = ti -- initial downtime

		ut = 0 -- total uptime
		wt = 0 -- total warningtime
		dt = 0 -- total downtime

		first = true
		for n, e in ipairs(t[a.name].events) do
			--[[ DEBUG ]]-- showtable(e)
			if ( n >= t[a.name].min and n <= t[a.name].max ) then -- min e max sao a primeira e a ultima
																-- entradas dentro do periodo entre ini e fin 
				te = tonumber(e[2])
				statef = e[4]
				if ( first ) then -- TODO: THIS IS A BAD statei INITIALIZATION!!!!
					if ( statef == 'DOWN' ) then
						statei = 'UP'
					else
						statei = 'DOWN'
					end
					first = false
					if ( ti < te ) then
						statei = 'DOWN'
					else
						te = ti
						statei = statef
					end
				end
	
				if ( statei == 'UP' and statef == 'WARNING' ) then
					wti = te
					ut = ut + (te - uti)
					nw = nw + 1
				elseif ( statei == 'UP' and statef == 'DOWN' ) then
					dti = te
					ut = ut + (te - uti)
					nd = nd + 1
				elseif ( statei == 'WARNING' and statef == 'UP' ) then
					uti = te
					wt = wt + (te - wti)
					nu = nu + 1
				elseif ( statei == 'WARNING' and statef == 'DOWN' ) then
					dti = te
					wt = wt + (te - wti)
					nd = nd + 1
				elseif ( statei == 'DOWN' and statef == 'UP' ) then
					uti = te
					dt = dt + (te - dti)
					nu = nu + 1
				elseif ( statei == 'DOWN' and statef == 'WARNING' ) then
					wti = te
					dt = dt + (te - dti)
					nw = nw + 1
				end
	
				--[[ DEBUG ]]-- print(a.name, statei, statef, ut, dt, wt, te)
				statei = statef
			end
		end
	
		if ( te ~= 0 ) then  -- (te == 0) mean that there was no event
			if ( statef == 'UP' ) then
				ut = ut + (tf - te)
			elseif ( statef == 'WARNING' ) then
				wt = wt + (tf - te)
			elseif ( statef == 'DOWN' ) then
				dt = dt + (tf - te)
			end
		end

		if ( ut == 0 and wt == 0 and dt == 0 ) then 
			ut = Tt
		end

		p_up   = ut * 100 / (Tt-1)
		p_warn = wt * 100 / (Tt-1)
		p_down = dt * 100 / (Tt-1)

		table.insert(r, { name = a.name, totaltime = Tt, 
			uptime = ut, warntime = wt, downtime = dt, 
			n_up = nu, n_warn = nw, n_down = nd,
			perc_uptime = p_up, perc_warntime = p_warn, perc_downtime = p_down})
	end

	return table.getn(r), r

end


--[[
app = 'MY_APP'
d1, d2 = last_day()
d1, d2 = last_month()
s , t = alert_report_resume_4(app, d1, d2)
print('++++++++++++++++++++++++++++++++++++++++++++++++')
showtable(t)
print('++++++++++++++++++++++++++++++++++++++++++++++++')
]]--


