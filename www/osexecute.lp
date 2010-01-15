#!/usr/bin/env cgilua.cgi

<?lua
require "m_io_util"
require "v_monitor_inc"
require "v_monitor_html"
require "v_auth"
require "m_users"
require "c_util"

local auth = checkauth_redirect()
local u = get_user(auth)


local cmd = cgilua.QUERY.cmd
local date = os.date('%Y-%m-%d')
local date_time = os.date('%Y-%m-%d %H:%M:%S')
local log_filename = '/usr/local/itvision/model/db/system.log'
local bkp_filename = '/usr/local/itvision/bin/backup '..date

print(html_header)
print(do_html_menui(u.name))
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

	elseif ( cmd == "reinit" ) then
		-- Nagios restart requires sudo password!
		-- Using my own script to start (but the init.d to stop!)
		s = os.capture("sudo -u root /etc/init.d/nagios restart")
		print("<p>")
		--print(s)
		print("check sudoers!")
		print("<p>")
		print("O sistema ir&aacute reiniciar o sub-sistema monitor...")

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


