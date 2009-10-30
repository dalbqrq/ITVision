#!/usr/bin/env cgilua.cgi

<%
require "v_monitor_inc"
require "c_monitor"
require "m_dbs"
require "v_auth"

checkauth()

t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()

print(html_header)
print(html_menui)
print(html_body)

-- HOSTS
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>hardwares</h1>")
print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t\t<TABLE width=600px;>")
print("\t\t\t<TR>")
print("\t\t\t\t<TH width=120px;>hardware</TH>")
print("\t\t\t\t<TH width=120px;>status</TH>")
print("\t\t\t\t<TH>status info</TH>")
print("\t\t\t</TR>")

for i, s in ipairs(status.hoststatus) do
		print("\t\t\t<TR>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic_get_label(1,s.host_name,3) .. "</TD>")
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. color[h_alert[s.current_state+1].color] .. "\">"
				..h_alert[s.current_state+1].name .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.plugin_output .. "</TD>")
		print("\t\t\t</TR>")
end

print("\t\t</TABLE>")
print("\t<br>")

print(html_footer)

%>
