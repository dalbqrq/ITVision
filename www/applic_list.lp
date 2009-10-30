#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_gviz"
require "c_monitor"
require "m_dbs"
require "v_auth"

checkauth_redirect()

app_name = cgilua.QUERY.app_name

local app = get_application(app_name)
hosts, services = get_uniq_hosts_and_services(app)
t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()

print(html_header)
print(html_header_refresh)
print(html_menui)
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
--print("\t\t\t\t<TH width=80px;>host</TH>")
print("\t\t\t\t<TH>hardware</TH>")
print("\t\t\t\t<TH width=120px;>status</TH>")
--print("\t\t\t\t<TH>status info</TH>")
print("\t\t\t</TR>")
print("\t\t\t</div>")

for i, s in ipairs(status.hoststatus) do
	fh = table.find_entry(hosts, s.host_name)
	if fh > 0 then
		print("\t\t\t<TR>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s.host_name..">" 
				.. ic_get_label(1,s.host_name,3) .. "</a></TD>")
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. color[h_alert[s.current_state+1].color] .. "\">"
				..h_alert[s.current_state+1].name .. "</TD>")
		--print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.plugin_output .. "</TD>")
		print("\t\t\t</TR>")
	end
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
print("\t\t\t\t<TH width=120px;>hardware onde roda</TH>")
print("\t\t\t\t<TH width=60px;>status</TH>")
--print("\t\t\t\t<TH width=50px;>attempt</TH>")
--print("\t\t\t\t<TH>status info</TH>")
print("\t\t\t</TR>")

for i, s in ipairs(status.servicestatus) do
	for j, w in ipairs(app.services) do
		if w[1] == s.service_description and w[2] == s.host_name then
			print("\t\t\t<TR>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s.service_description..">" 
					.. ic_get_label(1,s.service_description,3) .. "</a></TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=ics.lp?ickey="..s.host_name..">" 
					.. ic_get_label(1,s.host_name,3) .. "</a></TD>")

			print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"" .. color[s_alert[s.current_state+1].color]  
					.."\" TEXT=\"FFFFFF\" >" ..s_alert[s.current_state+1].name .. "</TD>")
--			print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">" .. s.current_attempt .. "/" 
--					.. s.max_attempts .. "</TD>")
			--print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. s.plugin_output .. "</TD>")
			print("\t\t\t</TR>")
			break
		end
	end
end

print("\t\t</TABLE>")
print("\t<br>")
app = string.gsub(app_name, " ", "%%20")
print("\n<a href=applic_graph.lp?app_name="..app..">Mudar para modo gr&aacute;fico</a>")

print(html_footer)
?>
