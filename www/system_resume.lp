#!/usr/bin/env cgilua.cgi

<?lua
require 'v_auth'
require 'v_monitor_inc'
require 'v_monitor'
require 'v_spider_graph'
require 'c_monitor'
require 'c_metrics'
require 'c_eficiency'
require 'c_disponibility'
checkauth_redirect()

if ( cgilua.QUERY.period ~= nil ) then
	period = cgilua.QUERY.period
else
	period = cgilua.POST.period
end

local d1, d2, t = {}

if period == nil then
	period = 'day'
	d1, d2 = last_day()
	p = 'max_day'
elseif period == 'day' then
	d1, d2 = last_day()
	p = 'max_day'
elseif period == 'week' then
	d1, d2 = last_week()
	p = 'max_week'
elseif period == 'month' then
	d1, d2 = last_month()
	p = 'max_month'
elseif period == 'year' then
	d1, d2 = last_year()
	p = 'max_year'
else
	period = 'day'
	d1, d2 = last_day()
	p = 'max_day'
end

apps = select_applications()

local filename = 'figs/spider'

dis = resume_disponibility('', d1, d2)
efi = resume_eficiency()
--sca = resume_scalability()
--cos = resume_cost()
--cap = resume_capacity()
--lev = resume_service_level()
--sec = resume_security()
--int = resume_integrity()
--gen = resume_gerenciability()
--con = resume_continuity()
--local values = { dis[p], efi[p], sca[p], cos[p], cap[p], lev[p], sac[p], int[p], gen[p], con[p] }


local values = { dis, efi[p], -1, -1, -1, -1, -1, -1, -1, -1 }
local factor = { 0, 0, 0, 0, 0,  0, 0, 0, 0, 0 }

factor = calc_factor(values)
mk_spider_graph(factor, filename)

print(html_header)
print(html_menui)
print(html_body)
print(www_period('system_resume.lp','',period))
print('\n\t\t\t\t<h1><a name=\'intro\' id=\'intro\'></a>m&eacute;tricas globais</h1>')
print('\t\t\t</div>')
print(text_file_reader(filename..'.map'))
print('<center><img src="'..filename..'.png"  /></center>')
print( [[
<p>
<span style="color:black">
<small>
<small>
<center>
<p>
<b>( N&Iacute;VEL DE MATURIDADE )</b>
<br>
<b><span style="background-color:#C2BFBF"> (-1) N&Atilde;O MEDIDO </span></b>
<b><span style="background-color:red"> (0) INEXISTENTE </span></b>
<b><span style="background-color:orange"> (1) INFORMAL </span></b>
<b><span style="background-color:yellow"> (2) ORGANIZADO </span></b>
<b><span style="background-color:#33CC00"> (3) - ESTRUTURADO </span></b>
<b><span style="background-color:lightblue"> (4) - GERENCIADO </span></b>
<b><span style="background-color:#CC66FF"> (5) - OTIMIZADO </span></b>
</center>
</small>
</small>
</P>

]])

print('</div>')
print(html_footer)

?>
