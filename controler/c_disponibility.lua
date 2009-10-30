require 'c_date'
require 'm_read_log'
require 'm_alerts'
require 'm_io_util'
require 'c_date'

-- Esta funcao deve substituir o codigo usado em 'report_show.lp' para criacao da 
-- tabela de disponibilidade
function disponibility(app, d1, d2)
	local t = {}
	local s = 0
	local l = 0
	local i = 0
	local Tu = 0
	local Tw = 0
	local Td = 0
	local Nw = 0
	local Nd = 0
	local count = 0
	local pr = 3  -- numeros de casas decimais depois da virgula

	s , t = alert_report_resume_4(app, d1, d2)

	for i, l in ipairs(t) do
		count = count + 1
		name = string.gsub(l.name, " ", "%%20")

		n = (l.perc_uptime > 10) and pr+2 or pr+1
		Tu = Tu + l.perc_uptime;
		u = string.sub(tostring(l.perc_uptime), 1, n)

		n = (l.perc_warntime > 10) and pr+2 or pr+1
		Tw = Tw + l.perc_warntime
		w = string.sub(tostring(l.perc_warntime), 1, n)

		n = (l.perc_downtime > 10) and pr+2 or pr+1
		Td = Td + l.perc_downtime
		d = string.sub(tostring(l.perc_downtime), 1, n)

		Nw = Nw + l.n_warn
		Nd = Nd + l.n_down



--[[
		-- REVISAR ESTAS CONTAS DE XXXtime! PROBLEMA COM DIFERENCAS DE 1 SEGUNDO!
		u = l.uptime * 100 / (l.totaltime-1); n = (u > 10) and pr+2 or pr+1
		Tu = Tu + u
		u = string.sub(tostring(u), 1, n)

		w = l.warntime * 100 / (l.totaltime-1); n = (w > 10) and pr+2 or pr+1
		Tw = Tw + w
		w = string.sub(tostring(w), 1, n)

		d = l.downtime * 100 / (l.totaltime-1); n = (d > 10) and pr+2 or pr+1
		Td = Td + d
		d = string.sub(tostring(d), 1, n)

		Nw = Nw + l.n_warn
		Nd = Nd + l.n_down

		-- The commented lines below include seconds
		D, H, M, S = os.splittime(l.uptime+1)
		--U = D..'D '..H..'h '..M..'m '..S..'s'
		U = D..'D '..H..'h '..M..'m '

		D, H, M, S = os.splittime(l.warntime); 
		--W = D..'D '..H..'h '..M..'m '..S..'s'
		W = D..'D '..H..'h '..M..'m '

		D, H, M, S = os.splittime(l.downtime); 
		--D = D..'D '..H..'h '..M..'m '..S..'s'
		D = D..'D '..H..'h '..M..'m '

		D, H, M, S = os.splittime(l.totaltime+1); 
		--T = D..'D '..H..'h '..M..'m '..S..'s'
		T = D..' Dias'
]]--

		-- TODO: completar. Esta funcao deve retornar tambem os valores perrcentuais por aplicacao
	end

end

-- Esta funcao deveria retornar valores para dia, semana, mes e ano como em c_eficienty.lua.
-- Deve-se portanto generalizar o conceito de periodo.
function resume_disponibility(app, d1, d2)
	app = app or ''
	--d1, d2 = last_month()
	--print( d1, d2)

	local t = {}
	local s = 0
	local down = 0
	local total = 0

	s , t = alert_report_resume(app, d1, d2)

	for i, l in ipairs(t) do
		--print (l.downtime, l.totaltime)
		down = down + l.downtime
		total = total + l.totaltime
	end

	local perc =  100. - ( down * 100 / total )
	local result = tonumber(string.format("%.3f", perc))

	return result
end

--print(resume_disponibility())


-----------------------------------------------------------------------------

function calc_disponibility(app, d1, d2)

resume = {
	UP = 0,
	DOWN = 0,
	WARNING = 0,
	PENDING = 0,
}

print(d1, d2, d2 - d1)

local first = true
local last  = false
local found = false

local initTime, finalTime, prevTime, totalTime = d2 - d1
local initState, finalState, prevState
local i, v

app_alerts = select_alerts(app,'|')

for a,alerts in pairs(app_alerts) do
	for i,v in ipairs(alerts) do
		t = tonumber(v[2])
		if t > d1 and t < d2 then
			found = true
			if first then
				first = false
				if i ~= 1 then
					initTime = d1
					initState = alerts[i-1][4]
				else
					initTime = t
					initState = alerts[1][4]
				end

				finalTime = d2
				totalTime = finalTime - initTime

				prevState = initState
				prevTime  = initTime
			end
			finalState = v[4]

			--[[
			print('-------')
			print('sum ('..t..' - '..prevTime..') = '..t - prevTime..' to state '..prevState)
			print('entry['..i..'] = '..v[4]..' : '..t)
			]]--
			resume[prevState] = resume[prevState] + t - prevTime

			prevState = finalState
			prevTime  = t

		elseif found == true and last == false then
			last = true
			--[[
			print('=========')
			print('sum ('..finalTime..' - '..prevTime..') = '..finalTime - prevTime..' to state '..prevState)
			print('entry['..i..'] = '..v[4]..' : '..t)
			]]--
			resume[prevState] = resume[prevState] + finalTime - prevTime

			break
		end
	end

	n = table.getn(alerts)
	if not last and finalTime > tonumber(alerts[n][2]) then
			last = true
			--[[
			print('++++++++')
			print('sum ('..finalTime..' - '..prevTime..') = '..finalTime - prevTime..' to state '..prevState)
			print('no related entry at time = '..finalTime)
			]]--
			resume[prevState] = resume[prevState] + finalTime - prevTime

			break
	end

	if not found then
		if d2 < alerts[1][2] then
			initState = 'none'
			finalState = 'none'
		else
			initState = alerts[n][4]
			finalState = initState
			resume[initState] = resume[initState] + finalTime - initTime

		end
	end

end

return totalTime, resume

end

--[[
t, r = calc_disponibility('', 1240967530, 1241477821)
print('-----------------------\n')
print('totalTime = '..t)
showtable(resume)
]]--




