require 'm_alerts'
require 'm_applications'
require 'c_date'

function calc_disponibility(app, ini, fin)
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

	local Tt, nu, nw, nd, itu, wti, dti, n, e, a, te, statei, statef, s
	local t = {}
	local r = {}
	local app_list = {}

	t = select_alerts(app)

	if ( app == '' ) then
		app_list = select_applications('')
	else
		app_list = { { name = app } }
	end

	di = string.sub(ini, 1, 2); mi = string.sub(ini, 4, 5); yi = string.sub(ini, 7, 10)
	df = string.sub(fin, 1, 2); mf = string.sub(fin, 4, 5); yf = string.sub(fin, 7, 10)
	print('orig',ini, fin)
	ti = os.time{year=yi, month=mi, day=di, hour=0}
	tf = os.time{year=yf, month=mf, day=df, hour=0}

	for _, a in ipairs(app_list) do

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

		if ti < tonumber(t[a.name][1][2]) then ti = tonumber(t[a.name][1][2]) end
		Tt = tf - ti

		first = true
		for n, e in ipairs(t[a.name]) do
			print('event #', n)
			print(os.date('%Y-%m-%d %H:%M:%S', ti))
			print(os.date('%Y-%m-%d %H:%M:%S', tf))
			print(os.date('%Y-%m-%d %H:%M:%S', e[2]))
			showtable(e)

			--[[ DEBUG 
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
						print('01')
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
	
				statei = statef
			end
			]]-- 
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



app = 'MY_APP'
d1, d2 = last_day()
d1, d2 = last_month()
s , t = calc_disponibility(app, d1, d2)
--print('++++++++++++++++++++++++++++++++++++++++++++++++')
--showtable(t)
--print('++++++++++++++++++++++++++++++++++++++++++++++++')


