
require 'm_import_csv'
require 'm_io_util'

--make_cfg_file()

local ic = {}
lines = line_reader('/usr/local/itvision/model/input/ics.csv')

for i,v in ipairs(lines) do
	if i ~= 1 then
		table.insert(ic, fromCSV(v))
	end
end

for _,v in ipairs(ic) do
	print('-----------------------')
	for i,w in ipairs(v) do
		print(i..' --- '..w)
	end
end
print('-----------------------')
s = toString(ic)
print(s)



--[[
host_cfg, ic = make_host_cfg_file()
print(host_cfg)

appl_cfg, all = make_applic_cfg_file()
print(appl_cfg)

serv_cfg, serc, cmd = make_service_cfg_file()
print(serv_cfg)

user_cfg = make_user_cfg_file()
print(user_cfg)

]]--

