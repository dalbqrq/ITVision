#!/usr/bin/env cgilua.cgi

<?lua
require 'v_auth'
require 'v_monitor_inc'
require 'v_monitor'
require 'm_read_log'
require 'c_monitor'
require 'c_util'
require 'c_date'
checkauth_redirect()

if ( cgilua.QUERY.applic ~= nil ) then
	applic = cgilua.QUERY.applic
	period = cgilua.QUERY.period
else
	applic = cgilua.POST.applic
	period = cgilua.POST.period
end

-- INPUT DATA
if applic == '_TODAS_' then 
	app = '' 
	app_name = 'TODAS'
else
	app = applic
	app_name = string.gsub(app, '_', ' ')
end

local l, i, s, d1, d2, t = {}

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

s, t = alert_report_resume_4(app, d1, d2)

	print(html_header)
	print(html_menui)
	print(html_body)

	print(www_period('report_dispo.lp','applic=_TODAS_',period))
	print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>disponibilidade</h1>")
	-- print("<div id=\"links\"><a href=\"javascript:window.print()\">[ imprimir ]</a></div>")
	-- print("<br>")
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
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=event_list.lp?tipo=lista&applic="..name.."&date1="..d1.."&date2="..d2.."&sep=,>"..l.name.."</TD>")


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
		T = D..'D '..H..'h '..M..'m '
		--T = D..' Dias'
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">" ..T.. "</TD>")

		print("\t\t\t</TR>")
	end

	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>TOTAL</TD>")

	Tu_c = Tu/count
	n = (Tu_c >= 100 or Tu_c == 0) and '%.0f' or '%.3f'
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>"..string.format(n,(Tu_c)).."%</b></TD>")
	Tw_c = Tw/count
	n = (Tw_c >= 100 or Tw_c == 0) and '%.0f' or '%.3f'
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>"..string.format(n,(Tw_c)).."%</b></TD>")
	Td_c = Td/count
	n = (Td_c >= 100 or Td_c == 0) and '%.0f' or '%.3f'
	print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\"><b>"..string.format(n,(Td_c)).."%</b></TD>")

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

	print(html_footer)
?>
	


