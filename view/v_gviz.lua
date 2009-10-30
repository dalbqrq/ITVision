require "m_applications"
require "m_dbs"
require "c_util"
require "c_monitor"

local config = {
	path = "/usr/local/itvision/www/figs"
}

function make_graphviz_img(app_name)   -- app_name is a string

	local fsz = 8
	local h = 0.3
	local w = 0.8

	local app = get_application(app_name)
	local app_file_name = string.gsub(app_name, " ", "_")
	local box_shape = "shape=box,    style=filled,height="..h..",width="..w
					..",fontsize="..fsz..",fontname=\"Helvetica\","
	local ell_shape = "shape=ellipse,style=filled,height="..h..",width="..w
					..",fontsize="..fsz..",fontname=\"Helvetica\","
	local graphviz_cmd = 'circo'
	local graphviz_cmd = 'twopi'

	hosts, services = get_uniq_hosts_and_services(app)
	t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()


	graphviz_file = "digraph  \""..app.name.."\" {\n"
	graphviz_file = graphviz_file.."ranksep = \"1.2 equally\" ;\n ratio=auto; defaultdist=0.2; \n"


	for i, v in ipairs(hosts) do
		for j, s in ipairs(status.hoststatus) do
			if s.host_name == v then
				c = h_alert[s.current_state+1].color
				l = ic_get_label(1,v,3)
				graphviz_file = graphviz_file .. "\t\""..v.."\" ["..box_shape.. 
					"label=\""..l.."\", \
					color=\"".. c .."\", \
					URL=\"ics.lp?ickey="..s.host_name.."\", \
					target=\"_self\" ];\n"
			end
		end
	end

	for i, v in ipairs(app.services) do
		for i, s in ipairs(status.servicestatus) do
			if s.host_name == v[2] and s.service_description == v[1] then
				c =  s_alert[s.current_state+1].color
				l = ic_get_label(1,v[1],3)
				if not l then l = 'NO_LABEL' end
				graphviz_file = graphviz_file .. "\t\""..v[1].."\"\t\t["..ell_shape..
					"label=\""..l.."\", \
					color=\"".. c .."\", \
					URL=\"ics.lp?ickey="..s.service_description.."\", \
					target=\"_self\" ];\n"
			end
		end
	end

	for i, v in ipairs(app.services) do
		graphviz_file = graphviz_file .. "\t\""..v[1].."\"->\""..v[2].."\" [ arrowsize=1 ]\n"
	end

	for i, v in ipairs(app.dependencies) do
		graphviz_file = graphviz_file .. "\t\""..v[1].."\"->\""..v[2].."\" [ arrowsize=1 ]\n"
	end

	graphviz_file = graphviz_file .. "\n}"

	acommand = "echo '"..graphviz_file.."' > "..config.path.."/"..app_file_name..".gv"
	bcommand = graphviz_cmd.." -Gcharset=latin1 -Tcmapx -o"..config.path.."/"..app_file_name..".map -Tpng -o"
		..config.path.."/"..app_file_name..".png " ..config.path.."/"..app_file_name..".gv"
	
	os.execute(acommand)
	os.execute(bcommand)
end


-- [[ DEBUG ]] make_graphviz_img('Telefonia')

