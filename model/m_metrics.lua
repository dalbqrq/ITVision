require "m_monitor"
require "c_monitor_inc"

local t_metrics = { }
local t_names = { }


function metric (_table)
	table.insert(t_metrics, _table)
end

function metric_list (_table)
	table.insert(t_names, _table)
end


function select_metrics(clause)
	local select_clause = clause

	--require "db_metrics"
	dofile ("/usr/local/itvision/model/db/db_metrics.lua")

	-- Return only the last metrics entry!!!
	local r_metrics = t_metrics[table.getn(t_metrics)]

	-- Return only the last metric_list entry!!!
	local r_names = t_names[table.getn(t_names)]

	return r_metrics, r_names
end


function get_metrics(clause)
	local metrics = select_metrics("all")
	result = {}

	for i, v in ipairs(metrics) do
		if clause(v)  then
			table.insert(result, v)
		end
	end
	return result
end


function show_metrics(clause)
	clause = clause or "all"

	local metrics = get_metrics(clause)

	print ("\n\nmetrics:\n-----------------")
	for i, v in ipairs(metrics) do
		print(i.." : "..v.name)
	end
	print()
end


