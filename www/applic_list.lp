#!/usr/bin/env /usr/local/bin/cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_monitor_html"
require "v_gviz"
require "c_monitor"
require "c_util"
require "m_dbs"
require "v_auth"
require "m_users"

local auth = checkauth_redirect()
local u = get_user(auth)

app_name = cgilua.QUERY.app_name

local app = get_application(app_name)
hosts, services = get_uniq_hosts_and_services(app)
t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()

local hosts_tab = {}
local services_tab = {}

print(html_header)
print(html_header_refresh)
print(do_html_menui(u.name))
print(html_body)
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>aplica&ccedil;&atilde;o: ".. app_name .."</h1>")
print("\t\t\t</div>")
print("\t\t\t</div>")
print("<div id=\"content\">")
print("<div id=\"mainbar\">")

-- HOSTS
print("\n\t\t\t\t<h2><a name=\"intro\" id=\"intro\"></a>hardwares que comp&otilde;e a aplica&ccedil;&atilde;o</h2>")
print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t\t<TABLE width=400px;>")
print("\t\t\t<TR>")
print("\t\t\t\t<TH>hardware</TH>")
print("\t\t\t\t<TH width=120px;>status</TH>")
print("\t\t\t</TR>")
print("\t\t\t</div>")


table.sort(hosts)

for i, h in ipairs(hosts) do
	fh = table.find_entry(status.hoststatus, h, 'host_name')
	s = status.hoststatus[fh]
	if fh > 0 then
		local ht = { ic_get_label(1,s.host_name,3), s.host_name, color[h_alert[s.current_state+1].color], 
		h_alert[s.current_state+1].name }
		table.insert(hosts_tab, ht)
	end
end

table.sort(hosts_tab, sort_hosts)
for i,h in pairs(hosts_tab) do
	print("\t\t\t<TR>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..h[2]..">" .. h[1] .. "</a></TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. h[3] .. "\">" .. h[4] .. "</TD>")
	print("\t\t\t</TR>")
end


print("\t\t</TABLE>")
print("\t<br>")

-- SERVICES
print("<div id=\"content\">")
print("<div id=\"mainbar\">")
print("\n\t\t\t\t<h2><a name=\"intro\" id=\"intro\"></a>softwares que comp&otilde;e a aplica&ccedil;&atilde;o</h2>")
print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t\t<TABLE width=700px;>")
print("\t\t\t<TR>")
print("\t\t\t\t<TH width=120px;>software</TH>")
print("\t\t\t\t<TH width=120px;>hardware</TH>")
print("\t\t\t\t<TH width=60px;>status</TH>")
print("\t\t\t</TR>")


table.sort(app.services, sort_services)

for j, w in ipairs(app.services) do
	for i, s in ipairs(status.servicestatus) do
		if w[1] == s.service_description and w[2] == s.host_name then
			st = { ic_get_label(1,s.service_description,3), ic_get_label(1,s.host_name,3), 
				s.service_description, s.host_name, color[s_alert[s.current_state+1].color], 
				s_alert[s.current_state+1].name }
			table.insert(services_tab, st)
			break
		end
	end
end


table.sort(services_tab, sort_services)
for i, s in ipairs(services_tab) do
	print("\t\t\t<TR>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s[3]..">" .. s[1] .. "</a></TD>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s[4]..">" .. s[2] .. "</a></TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. s[5] .."\" TEXT=\"FFFFFF\" >" .. s[6] .. "</TD>")
	print("\t\t\t</TR>")
end


table.sort(services_tab, sort_services)
for i, s in ipairs(services_tab) do
	print("\t\t\t<TR>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s[3]..">" .. s[1] .. "</a></TD>")
	print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s[4]..">" .. s[2] .. "</a></TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. s[5] .."\" TEXT=\"FFFFFF\" >" .. s[6] .. "</TD>")
	print("\t\t\t</TR>")
end


print("\t\t</TABLE>")
print("\t<br>")
app = string.gsub(app_name, " ", "%%20")
print("\n<a href=applic_graph.lp?app_name="..app..">Mudar para modo gr&aacute;fico</a>")

print(html_footer)
?>
