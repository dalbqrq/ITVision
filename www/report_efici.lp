#!/usr/bin/env /usr/local/bin/cgilua.cgi

<?lua
require 'v_auth'
require 'v_monitor_inc'
require "v_monitor_html"
require 'v_monitor'
require 'm_read_log'
require 'c_monitor'
require 'c_eficiency'
require 'c_util'
require 'c_date'
require "m_users"

local auth = checkauth_redirect()
local u = get_user(auth)


if ( cgilua.QUERY.period ~= nil ) then
	period = cgilua.QUERY.period
else
	period = cgilua.POST.period
end

local l, i, d1, d2, e = {}

if period == nil then
	period = 'day'
	d1, d2 = last_day()
	n = 3
elseif period == 'day' then
	d1, d2 = last_day()
	n = 3
elseif period == 'week' then
	d1, d2 = last_week()
	n = 4
elseif period == 'month' then
	d1, d2 = last_month()
	n = 5
elseif period == 'year' then
	d1, d2 = last_year()
	n = 6
else
	period = 'day'
	d1, d2 = last_day()
	n = 3
end


	print(html_header)
	print(do_html_menui(u.name))
	print(html_body)

	print(www_period('report_efici.lp','',period))
	print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>efici&ecirc;ncia</h1>")

	print("\t\t\t</div>")
	print("\t\t\t</div>")
	print("\t\t\t<p>")
	print("\t\t<TABLE width=800px;>")
	print("\t\t\t<TR>")
	print("\t\t\t\t<TH width=120px;>aplica&ccedil;&atilde;o</TH>")
	print("\t\t\t\t<TH width=120px;>m&aacute;ximo</TH>")
	print("\t\t\t\t<TH width=120px;>m&eacute;dia</TH>")
	print("\t\t\t\t<TH width=120px;>contador</TH>")
	print("\t\t\t</TR>")

	e = read_applications_eficiency()

	for i, l in ipairs(e) do
		name = string.gsub(l[1], " ", "%%20")

		print("\t\t\t<TR>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><a href=event_list.lp?tipo=lista&applic="..name.."&date1="..d1.."&date2="..d2.."&sep=,>"..l[1].."</TD>")

		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">"..string.format('%.3f',l[n])  .." ms </TD>")
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">"..string.format('%.3f',l[n+5]).." ms </TD>")
		print("\t\t\t\t<TD ALIGN=\"CENTER\" BGCOLOR=\"#f2f2f2\">"..l[n+9].." </TD>")

		print("\t\t\t</TR>")
	end

	print("\t\t</TABLE>")
	print(html_footer)
?>
	


