#!/usr/bin/env /usr/local/bin/cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_monitor"
require "v_auth"
require "m_read_log"
require "c_monitor"
require "c_util"
require "c_date"
require "v_monitor_html"
require "m_users"

local auth = checkauth_redirect()
local u = get_user(auth)


if ( cgilua.QUERY.applic ~= nil ) then
	applic = cgilua.QUERY.applic
	--d1     = cgilua.QUERY.date1
	--d2     = cgilua.QUERY.date2
	-- separador por default eh virgula. isto deverah ser configuacao geral do sistema
	--sep    = cgilua.QUERY.sep
	sep    = ','
	tipo   = cgilua.QUERY.tipo
	period = cgilua.QUERY.period
else
	applic = cgilua.POST.applic
	--d1     = cgilua.POST.date1
	--d2     = cgilua.POST.date2
	-- separador por default eh virgula. isto deverah ser configuacao geral do sistema
	--sep    = cgilua.POST.sep
	sep    = ','
	tipo   = cgilua.POST.tipo
	period = cgilua.POST.period
end

tipo = tipo or 'lista'

-- INPUT DATA
if applic == '_TODAS_' then 
	app = '' 
	app_name = 'TODAS'
else
	app = applic
	app_name = string.gsub(app, '_', ' ')
end

--[[ DEBUG
app = ''
app_name = 'TODAS'
d1 = '01/12/2008'
d2 = '11/12/2008'
sep = ','
tipo = 'resumo'
]]--

local s, d1, d2, t = {}

if period == nil then
	period = 'day'
	d1, d2 = last_day()
elseif period == 'day' then
	d1, d2 = last_day()
elseif period == 'week' then
	d1, d2 = last_week()
elseif period == 'month' then
	d1, d2 = last_month()
elseif period == 'year' then
	d1, d2 = last_year()
else
	period = 'day'
	d1, d2 = last_day()
end

print(html_header)
print(do_html_menui(u.name))
print(html_body)

local t = {}
local s = 0
local l = 0
local i = 0

if tipo == 'lista' then
	-- RETRIEVES LOG AS STRING AND TABLE
	-- [[ DEBUG ]] s, t = alert_report('', '01/10/2008', '01/12/2008', ',')
	s, t = alert_report_list(app, d1, d2, sep)

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
			--print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=applic_list.lp?app_name="..l[3]..">" .. l[3] .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=applic_list.lp?app_name="..a..">" .. l[3] .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. l[1] .. "</TD>")
			print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\""..color[cor].."\">"..l[4] .."</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. l[5] .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. l[6] .. "</TD>")
			print("\t\t\t</TR>")
	end
	
	print("\t\t</TABLE>")
	print("\t<br>")

else --if tipo == resumo then
	s, t = alert_report_resume_4(app, d1, d2)

	print(www_period('report_show.lp','applic=_TODAS_&tipo=resumo&sep=;',period))
	print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>disponibilidade</h1>")
	--print("<div id=\"links\"><a href=\"javascript:window.print()\">[ imprimir ]</a></div>")
	--print("Aplica&ccedil;&atilde;o: <b>"..app_name..  "</b> entre <b>"..d1.."</b> e <b>"..d2.."</b> ")
	--print("Aplica&ccedil;&atilde;o: <b>"..app_name..  "</b> - Data: de  <b>"..d1.."</b> &agrave; <b>"..d2.."</b> ")
	print("\t\t\t</div>")
	print("\t\t\t</div>")
	print("\t\t\t<p>")
	print("\t\t<TABLE width=800px;>")
	print("\t\t\t<TR>")
	print("\t\t\t\t<TH width=120px;>aplica&ccedil;&atilde;o</TH>")
	print("\t\t\t\t<TH width=120px;>uptime</TH>")
	print("\t\t\t\t<TH width=120px;>warntime</TH>")
	print("\t\t\t\t<TH width=120px;>downtime</TH>")
	print("\t\t\t\t<TH width=20px;>#warn</TH>")
	print("\t\t\t\t<TH width=20px;>#down</TH>")
	print("\t\t\t\t<TH width=100px;>totaltime</TH>")
	print("\t\t\t</TR>")

	local Tu = 0
	local Tw = 0
	local Td = 0
	local Nw = 0
	local Nd = 0
	local count = 0
	for i, l in ipairs(t) do
		count = count + 1
		name = string.gsub(l.name, " ", "%%20")

		--[[
		u = l.uptime * 100 / (l.totaltime-1); n = (u > 10) and 5 or 4
		Tu = Tu + u
		u = string.sub(tostring(u), 1, n)

		w = l.warntime * 100 / (l.totaltime-1); n = (w > 10) and 5 or 4
		Tw = Tw + w
		w = string.sub(tostring(w), 1, n)

		d = l.downtime * 100 / (l.totaltime-1); n = (d > 10) and 5 or 4
		Td = Td + d
		d = string.sub(tostring(d), 1, n)

		]]--
		n = (l.perc_uptime >= 100) and 3 or (l.perc_uptime >= 10) and 6 or 5
		u = string.sub(tostring(l.perc_uptime), 1, n)
		Tu = Tu + l.perc_uptime

		n = (l.perc_warntime >= 100) and 3 or (l.perc_warntime >= 10) and 6 or 5
		w = string.sub(tostring(l.perc_warntime), 1, n)
		Tw = Tw + l.perc_warntime

		n = (l.perc_downtime >= 100) and 3 or (l.perc_downtime >= 10) and 6 or 5
		d = string.sub(tostring(l.perc_downtime), 1, n)
		Td = Td + l.perc_downtime

		print("\t\t\t<TR>")
		--print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=report_show.lp?tipo=lista&applic="..name.."&date1="..cgilua.POST.date1.."&date2="..cgilua.POST.date2.."&sep="..cgilua.POST.sep..">"..l.name.."</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=report_show.lp?tipo=lista&applic="..name.."&date1="..d1.."&date2="..d2.."&sep="..sep..">"..l.name.."</TD>")


		-- The commented lines below include seconds
		D, H, M, S = os.splittime(l.uptime+1)
		--U = D..'D '..H..'h '..M..'m '..S..'s'
		U = D..'D '..H..'h '..M..'m '
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>" .. u .. "%</b> <br><small>("..U..")</small></TD>")

		D, H, M, S = os.splittime(l.warntime); 
		--W = D..'D '..H..'h '..M..'m '..S..'s'
		W = D..'D '..H..'h '..M..'m '
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>" .. w .. "%</b> <br><small>("..W..")</small></TD>")

		D, H, M, S = os.splittime(l.downtime); 
		--D = D..'D '..H..'h '..M..'m '..S..'s'
		D = D..'D '..H..'h '..M..'m '
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>" .. d .. "%</b> <br><small>("..D..")</small></TD>")

		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">" .. l.n_warn .. "</TD>")
		Nw = Nw + l.n_warn
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">" .. l.n_down .. "</TD>")
		Nd = Nd + l.n_down

		D, H, M, S = os.splittime(l.totaltime+1); 
		--T = D..'D '..H..'h '..M..'m '..S..'s'
		T = D..' Dias'
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">" ..T.. "</TD>")

		print("\t\t\t</TR>")
	end

	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>TOTAL</TD>")

	n = (Tu/count >= 100) and '%.0f' or '%.3f'
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>"..string.format(n,(Tu/count)).."%</b></TD>")
	n = (Tw/count >= 100) and '%.0f' or '%.3f'
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>"..string.format(n,(Tw/count)).."%</b></TD>")
	n = (Td/count >= 100) and '%.0f' or '%.3f'
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>"..string.format(n,(Td/count)).."%</b></TD>")

	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>" .. Nw .. "</b></TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>" .. Nd .. "</b></TD>")
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">" ..T.. "</TD>")
	
	print("\t\t</TABLE>")
	print('<div id="content">')
	print('<small><dir><dir>')
	print('<b>uptime</b> - tempo total em que aplica&ccedil;&atilde;o esteve funcionando - <i>(Formato = %, Dias, Horas, Minutos, Segundos)</i>;<br>')
	print('<b>warntime</b> - tempo total em que aplica&ccedil;&atilde;o esteve funcionando em estado de alerta - <i>(Formato = idem)</i>;<br>')
	print('<b>downtime</b> - tempo total em que aplica&ccedil;&atilde;o &ntilde;o steve funcionando - <i>(Formato = idem)</i>;<br>')
	print('<b># warn</b> - n&uacute;mero de alertas de warning (funcionamento prec&aacute;rio);<br>')
	print('<b># down</b> - n&uacute;mero de alertas de down (n&atilde;o funcionamento);<br>')
	print('<b>totaltime</b> - tempo total abrangido pelo relat&oacute;rio;')
	print('</dir></dir></small>')
	print('</div>')

end
	
print(html_footer)
?>
	


