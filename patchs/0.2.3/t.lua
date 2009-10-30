require "m_applications"
require "m_dbs"
require "c_util"
require "c_monitor"

function status_count(app_name)
	local app = get_application(app_name)
	local app_file_name = string.gsub(app_name, " ", "_")

	hosts, services = get_uniq_hosts_and_services(app)
	t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()

	for i, v in ipairs(hosts) do
		for j, s in ipairs(status.hoststatus) do
			if s.host_name == v then
				c = h_alert[s.current_state+1].color
				l = ic_get_label(1,v,3)
				print(l, c, app_name, v)
			end
		end
	end

	for i, v in ipairs(app.services) do
		for i, s in ipairs(status.servicestatus) do
			if s.host_name == v[2] and s.service_description == v[1] then
				c =  s_alert[s.current_state+1].color
				l = ic_get_label(1,v[1],3)
				print(l, c, app_name, v[1], v[2])
			end
		end
	end

end

local applic = select_applications("all")
for _, a in ipairs(applic) do
	--status_count(a)
	print(a)
end
