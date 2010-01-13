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

-- SERVICES
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>softwares</h1>")
print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t\t<TABLE width=800;>")
print("\t\t\t<TR>")
print("\t\t\t\t<TH width=120px;>hardware</TH>")
print("\t\t\t\t<TH width=120px;>software</TH>")
print("\t\t\t\t<TH width=80px;>status</TH>")
--print("\t\t\t\t<TH width=50px;>attempt</TH>")
print("\t\t\t\t<TH>status info</TH>")
print("\t\t\t</TR>")

for i, s in ipairs(status.servicestatus) do
	estado = 'NORMAL'
	if s_alert[s.current_state+1].name == "ok" then estado = "NORMAL"
	elseif s_alert[s.current_state+1].name == "critical" then estado = "CRITICO"
	elseif s_alert[s.current_state+1].name == "warning" then estado = "ANORMAL"
	elseif s_alert[s.current_state+1].name == "pending" then estado = "PENDENTE DE TESTE"
	elseif s_alert[s.current_state+1].name == "unknown" then estado = "DESCONHECIDO"
	end
	print("\t\t\t<TR>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic_get_label(1,s.host_name,3) .. "</TD>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic_get_label(1,s.service_description,3) .. "</TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. color[s_alert[s.current_state+1].color]  .. "\">"
			..estado.. "</TD>")
--[[
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. color[s_alert[s.current_state+1].color]  .. "\">"
			..s_alert[s.current_state+1].name .. "</TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">" .. s.current_attempt .. "/" 
			.. s.max_attempts .. "</TD>")
]]--
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.plugin_output .. "</TD>")
	print("\t\t\t</TR>")
end

print("\t\t</TABLE>")
print("\t<br>")

print(html_footer)
%>
