--require "v_monitor_inc"
--require "c_monitor"
dofile("/usr/local/itvision/view/v_monitor_inc.lua")
dofile("/usr/local/itvision/controler/c_monitor.lua")


function www_index()
	local lcolor
	t_hosts, t_servs = get_status_resume()
	
	print(html_content_type)
	print(html_header)
	
	if t_hosts > 0 then
		-- HOSTS
		print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>hosts</h1>")
		print("\t\t\t\t<div id=\"allalerts\">")
		print("\t\t\t\t\t<div id=\"semialert\"></div>")
		for i, h in ipairs(host_alert) do
			if h.num > 0 then lcolor = h.color else lcolor = "gray" end
			print("\t\t\t\t\t<div id=\"alert\"> <div id=\"" .. lcolor .. "\">" .. h.num .. "</div>" .. h.name .. "</div>")
		end
		
		
		if t_servs > 0 then
			-- SERVICES
			print("\t\t\t\t</div>")
			print("\n\t\t\t\t<h1><a name=\"css\" id=\"css\"></a>services</h1>")
			print("\t\t\t\t<div id=\"allalerts\">")
			for i, s in ipairs(service_alert) do
				if s.num > 0 then lcolor = s.color else lcolor = "gray" end
				print("\t\t\t\t\t<div id=\"alert\"> <div id=\"" .. lcolor .. "\">" .. s.num .. "</div>" .. s.name .. "</div>")
			end
		
		end
		
		-- CLOSE
		print("\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>")
	else
		print("IT Vision - [monitor] malfunction. Please contact system administrator.")
	end

	print(html_footer)

end



function www_hosts(selfunc)
	--status = get_status()
	t_hosts, t_servs, status = get_status_resume()
	
	print(html_content_type)

	print(html_header)
	
	-- HOSTS
	print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>hosts</h1>")
	print("\t\t\t</div>")
	print("\t\t\t</div>")
	print("\t\t<TABLE width=600px;>")
	print("\t\t\t<TR>")
	print("\t\t\t\t<TH width=120px;>host</TH>")
	print("\t\t\t\t<TH width=120px;>status</TH>")
	print("\t\t\t\t<TH>status info</TH>")
	print("\t\t\t</TR>")
	
	for i, s in ipairs(status.hoststatus) do
		if (selfunc(s.current_state+1)) then
			print("\t\t\t<TR>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.host_name .. "</TD>")
--			print("\t\t\t\t<TD style=\"color:white;\" ALIGN=\"CENTER\" BGCOLOR=\"" .. color[host_alert[s.current_state+1].color] .. "\">"..host_alert[s.current_state+1].name .. "</TD>")
			print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. color[host_alert[s.current_state+1].color] .. "\">"..host_alert[s.current_state+1].name .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.plugin_output .. "</TD>")
			print("\t\t\t</TR>")
		end
	end
	
	print("\t\t</TABLE>")
	print("\t<br>")
	
	print(html_footer)
end



function www_services(selfunc)
	--status = get_status()
	t_hosts, t_servs, status = get_status_resume()
	
	print(html_content_type)
	print(html_header)
	
	-- SERVICES
	print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>services</h1>")
	print("\t\t\t</div>")
	print("\t\t\t</div>")
	print("\t\t<TABLE width=800;>")
	print("\t\t\t<TR>")
	print("\t\t\t\t<TH width=120px;>host</TH>")
	print("\t\t\t\t<TH width=120px;>services</TH>")
	print("\t\t\t\t<TH width=80px;>status</TH>")
	print("\t\t\t\t<TH width=50px;>attempt</TH>")
	print("\t\t\t\t<TH>status info</TH>")
	print("\t\t\t</TR>")
	
	for i, s in ipairs(status.servicestatus) do
		if (selfunc(s.current_state+1)) then
			print("\t\t\t<TR>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.host_name .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.service_description .. "</TD>")
--			print("\t\t\t\t<TD style=\"color:white;\" ALIGN=\"CENTER\" BGCOLOR=\"" .. color[service_alert[s.current_state+1].color]  .. "\">"..service_alert[s.current_state+1].name .. "</TD>")
			print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. color[service_alert[s.current_state+1].color]  .. "\">"..service_alert[s.current_state+1].name .. "</TD>")
			print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">" .. s.current_attempt .. "/" .. s.max_attempts .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.plugin_output .. "</TD>")
			print("\t\t\t</TR>")
		end
	end
	
	print("\t\t</TABLE>")
	print("\t<br>")
	
	print(html_footer)
end

function www_period(ref, params, period)
	local res, i, v, p = {}

	p = { {'day', 'dia'}, {'week','semana'}, {'month','m&ecirc;s'}, {'year','ano'} }
	if (params ~= nil or params ~= '') then
		params = params..'&'
	end

	res = "\n\t<h6>| "
	for i,v in ipairs(p) do
		res = res .. '<a href='..ref..'?'..params..'period='..v[1]..'>'
		if period == v[1] then
			res = res .. '<big>'..v[2]..'</big>'
		else
			res = res .. v[2]
		end
		res = res .. ' |'
	end
	res = res .. "</h6>"

	return res
end

function www_test()
	t_hosts, t_servs = get_status_resume()

	print(html_content_type)
	print(t_hosts, t_servs)

end
