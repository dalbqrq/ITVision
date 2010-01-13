#!/usr/bin/env cgilua.cgi

<%
require "v_monitor_inc"
require "c_monitor"
require "m_dbs"
require "v_monitor_html"
require "v_auth"
require "m_users"

local auth = checkauth_redirect()
local u = get_user(auth)

--checkauth()

t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()

print(html_header)
print(do_html_menui(u.name))
print(html_body)

-- HOSTS
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>hardwares</h1>")
print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t\t<TABLE width=650px;>")
print("\t\t\t<TR>")
print("\t\t\t\t<TH width=120px;>hardware</TH>")
print("\t\t\t\t<TH width=120px;>status</TH>")
print("\t\t\t\t<TH>status info</TH>")
print("\t\t\t</TR>")

for i, s in ipairs(status.hoststatus) do
	estado = 'NORMAL'
	if h_alert[s.current_state+1].name == "up" then estado = "NORMAL"
	elseif h_alert[s.current_state+1].name == "down" then estado = "CRITICO"
	elseif h_alert[s.current_state+1].name == "unreachable" then estado = "NAO ALCANçADO"
	elseif h_alert[s.current_state+1].name == "pending" then estado = "PENDENTE DE TESTE"
	end
	print("\t\t\t<TR>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic_get_label(1,s.host_name,3) .. "</TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. color[h_alert[s.current_state+1].color] .. "\">"
			..estado .. "</TD>")
			--..h_alert[s.current_state+1].name .. "</TD>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.plugin_output .. "</TD>")
	print("\t\t\t</TR>")
end

print("\t\t</TABLE>")
print("\t<br>")

print(html_footer)

%>
