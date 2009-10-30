require 'm_io_util'
require 'm_applications'

local alert_file = '/usr/local/itvision/model/db/alerts.log'

function select_alerts(app, sep)
	app = app or ''
	sep = sep or '|'

	local result = {}
	local app_list = {}
	local a, lines, i, v, app_name

	if ( app == '' ) then
		app_list = select_applications('')
	else
		app_list = { { name = app } }
	end

	-- Read log file line by line
	local lines = line_reader(alert_file)
	if not lines then return result end

	if lines then 
		for i,v in ipairs(lines) do
			t = fromCSV(v, sep)
			app_name = t[3]
	
			for _,w in ipairs(app_list) do
				if w.name == app_name then 
					if ( result[app_name] == nil ) then
						result[app_name] = { }
					end

					table.insert(result[app_name], t)
				end
			end
		end
	end

	return result
end

--[[
apps = select_alerts('','|')
for i, v in pairs(apps) do
	print('===================='..i..'=====================')
	showtable( v )
end
]]--

