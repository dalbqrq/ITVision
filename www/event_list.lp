#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_monitor"
require "v_auth"
require "m_read_log"
require "c_monitor"
require "c_util"
require "c_date"
checkauth_redirect()

local app, app_name, applic, d1, d2, sep, s, l, i, t = {}

if ( cgilua.QUERY.applic ~= nil ) then
	applic = cgilua.QUERY.applic
	d1     = cgilua.QUERY.date1
	d2     = cgilua.QUERY.date2
	sep    = ',' -- separador por default eh virgula. isto deverah ser configuacao geral do sistema
else
	applic = cgilua.POST.applic
	d1     = cgilua.POST.date1
	d2     = cgilua.POST.date2
	sep    = ',' -- separador por default eh virgula. isto deverah ser configuacao geral do sistema
end

-- INPUT DATA
if applic == '_TODAS_' then 
	app = '' 
	app_name = 'TODAS'
else
	app = applic
	app_name = string.gsub(app, '_', ' ')
end

-- RETRIEVES LOG AS STRING AND TABLE
-- [[ DEBUG ]] s, t = alert_report('', '01/10/2008', '01/12/2008', ',')
s, t = alert_report_list(app, d1, d2, sep)

	print(html_header)
	print(html_menui)
	print(html_body)

	print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>lista de eventos</h1>")
	print("<div id=\"links\"><a href=report_download.lp?applic="..app.."&date1="..d1.."&date2="..d2.."&sep="..sep
		..">[ salvar como CSV ]</a>")
	print(" | ")
	print("<a href=\"javascript:window.print()\">[ imprimir ]</a></div>")
	print("Aplica&ccedil;&atilde;o: <b>"..app_name..  "</b> - Data: de  <b>"..d1.."</b> &agrave; <b>"..d2.."</b> ")
	print("\t\t\t</div>")
	print("\t\t\t</div>")
	print("\t\t\t<p>")
	print("\t\t<TABLE width=900px;>")
	print("\t\t\t<TR>")
	print("\t\t\t\t<TH width=120px;>aplica&ccedil;&atilde;o</TH>")
	print("\t\t\t\t<TH width=100px;>data e hora</TH>")
	print("\t\t\t\t<TH>status</TH>")
	print("\t\t\t\t<TH>hardware com problema</TH>")
	print("\t\t\t\t<TH>software com problema</TH>")
	print("\t\t\t</TR>")

	if t then
		for i, l in ipairs(t) do
			if l[4] == "UP" then cor = 'green'
				elseif l[4] == "DOWN" then cor = 'red'
				elseif l[4] == "WARNING" then cor = 'yellow'
				elseif l[4] == "PENDING" then cor = 'blue'
			end
	
			local a = string.gsub(l[3], " ", "%%20")
			if l[5] == "" then l[5] = "-" end
			if l[6] == "" then l[6] = "-" end
	
			print("\t\t\t<TR>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=applic_list.lp?app_name="..a..">" .. l[3] .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. l[1] .. "</TD>")
			print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\""..color[cor].."\">"..l[4] .."</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. l[5] .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. l[6] .. "</TD>")
			print("\t\t\t</TR>")
		end
	end
	
	print("\t\t</TABLE>")
	print("\t<br>")

	print(html_footer)
?>
	
