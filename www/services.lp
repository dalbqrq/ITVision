#!/usr/bin/env /usr/local/bin/cgilua.cgi

<%
require "v_monitor_inc"
require "c_monitor"
require "c_util"
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
print("\t\t\t\t<TH>status info</TH>")
print("\t\t\t</TR>")

local services_tab = {}
for i, s in ipairs(status.servicestatus) do
	local st = { ic_get_label(1,s.service_description,3), ic_get_label(1,s.host_name,3), 
		s.service_description, s.host_name, color[s_alert[s.current_state+1].color], 
		s_alert[s.current_state+1].name, s.plugin_output }
	table.insert(services_tab, st)
end

table.sort(services_tab, sort_services)
for i, s in ipairs(services_tab) do
	print("\t\t\t<TR>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s[3]..">" .. s[1] .. "</a></TD>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s[4]..">" .. s[2] .. "</a></TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. s[5] .."\" TEXT=\"FFFFFF\" >" .. s[6] .. "</TD>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s[7] .. "</TD>")
	print("\t\t\t</TR>")
end


print("\t\t</TABLE>")
print("\t<br>")

print(html_footer)
%>
