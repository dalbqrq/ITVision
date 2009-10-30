#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_auth"
require "m_users"
require "m_io_util"


local cmd = cgilua.QUERY.cmd
local date = os.date('%Y-%m-%d')
local date_time = os.date('%Y-%m-%d %H:%M:%S')
local log_filename = '/usr/local/itvision/model/db/system.log'
local bkp_filename = '/usr/local/itvision/bin/backup '..date

print(html_header)
print(html_menui)
print(html_body)

if not checkauth('admin') then
	cgilua.redirect('../login.lp?mess=LOGOUT')
end

if ( cmd ) then
	print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>"..cmd.."</h1>")
	print("\t\t\t</div>")

	os.execute("echo \""..date_time.."|"..cmd.."\" >> "..log_filename)

	if ( cmd == "reboot" ) then
		os.execute("reboot")
		print("O sistema ir&aacute reinicializa imediatamente...")
	elseif ( cmd == "shutdown" ) then
		os.execute("poweroff")
		print("O sistema ir&aacute se desligar imediatamente...")
	elseif ( cmd == "backup" ) then
		os.execute(bkp_filename)
		--cgilua.redirect('../backup_download.lp')
		print("O backup do sistema foi realizado em "..date_time)
	end
end


print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t<br>")

print(html_footer)
?>


