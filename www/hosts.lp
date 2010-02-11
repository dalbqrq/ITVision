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

t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()

print(html_header)
print(do_html_menui(u.name))
print(html_body)

-- HOSTS
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>hardwares</h1>")
print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t\t<TABLE width=750px;>")
print("\t\t\t<TR>")
print("\t\t\t\t<TH width=120px;>hardware</TH>")
print("\t\t\t\t<TH width=120px;>status</TH>")
print("\t\t\t\t<TH>status info</TH>")
print("\t\t\t</TR>")

local hosts_tab = {}
for i, s in ipairs(status.hoststatus) do
	local ht = { ic_get_label(1,s.host_name,3), s.host_name, color[h_alert[s.current_state+1].color], 
	h_alert[s.current_state+1].name, s.plugin_output }

	table.insert(hosts_tab, ht)
end

table.sort(hosts_tab, sort_hosts)
for i,h in pairs(hosts_tab) do
	print("\t\t\t<TR>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..h[2]..">" .. h[1] .. "</a></TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. h[3] .. "\">" .. h[4] .. "</TD>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. h[5] .. "</TD>")
	print("\t\t\t</TR>")
end


print("\t\t</TABLE>")
print("\t<br>")

print(html_footer)

%>
