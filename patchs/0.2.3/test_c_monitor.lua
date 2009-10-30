require "c_monitor"
require "m_monitor"
require "m_io_util"

--[[
status = select_status()
t_hosts, t_services, host_alert, service_alert, status = get_status_resume(status)

if ret == nil then
	print("PROBLEM")
end


for i, s in ipairs(host_alert) do
	print(" HOST "..s.name.." ["..i.."]: "..s.num)
end
print("Total hosts: " .. t_hosts)

for i, s in ipairs(service_alert) do
	print(" SERVICE "..s.name.." ["..i.."]: "..s.num)
end
print("Total services: " .. t_services)

print("\n\n")

show_applications()

res = get_applications_resume()
print()
print()
showtable(res)
]]--


t = nil
for i, v in ipairs (t) do
	print(v)
end


res = get_applications_eficiency()
print()
showtable(res)

--[[
for i, j in ipairs(res) do
	print(i.." : "..res[i].name.." = "..res[i].status)
end
]]--


