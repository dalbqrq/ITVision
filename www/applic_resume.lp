#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor"
require "v_monitor_inc"
require "v_monitor_html"
require "v_auth"
require "m_users"
require "m_read_log"
require "c_monitor"
require "c_date"

-- REMOVE - para teste somente - REMOVER - local auth = checkauth_redirect()
local auth = checkauth_redirect("admin", "")
local u = get_user(auth)


if ( cgilua.QUERY.period ~= nil ) then
	period = cgilua.QUERY.period
else
	period = cgilua.POST.period
end

local res, n_res
local s, d1, d2, t = {}
local lcolor, t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()

res = get_applications_resume(u.apps)
n_res = table.getn(res)

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

s, t = alert_report_resume_4('', d1, d2)

n_cols = 6
n_rows = math.ceil(n_res/n_cols)
if n_rows < 2 then n_rows = 2 end

print(html_header)
print(html_header_refresh)
local u = get_user(auth)
print(do_html_menui(u.name))
print(html_body)

if n_res > 0 then
	-- APPLICATIONS
	--print(www_period('applic_resume.lp','', period))
	print("\n\t<h1><a name=\"intro\" id=\"intro\"></a>aplica&ccedil;&otilde;es</h1>")
	print("\t\t<div id=\"allalerts\">")
	for i = 1,(n_cols*n_rows) do
		if i == n_cols+1 or i == (n_cols*2)+1 or i == (n_cols*3)+1 or i == (n_cols*4)+1 then
			print("\n\t\t<h1><a name=\"css\" id=\"css\"></a></h1>")
			print("\t\t<div id=\"allalerts\">")
		end

		if i <= n_res then
			n = res[i].status + 1
			if i > 0 then lcolor = applic_alert[n].color else lcolor = "gray" end
			name = string.gsub(res[i].name, " ", "_")
			app = string.gsub(res[i].name, " ", "%%20")

		for _, p in pairs(t) do
			if res[i].name == p.name then
				dec = (p.perc_uptime >= 100) and 3 or (p.perc_uptime >= 10) and 6 or 5
				up = string.sub(tostring(p.perc_uptime), 1, dec)
			end
		end

			print("\t\t\t<div id=\"alert\"> <div id=\"" .. lcolor .. "\">")
			print("\t\t\t<a href=applic_graph.lp?app_name="..app..">".. res[i].name .. 
				"</a>")
			--print("\t\t\t</div>" .. applic_alert[n].name .. "</div>")
-- REMOVE UPTIME	print("\t\t\t</div><div id=perc>( " .. up .. "% )</div></div>")
			print("\t\t\t</div></div>")

		else
			print("\t\t\t<div id=\"alert\"> <div id=\"gray\"></div></div>")
		end

		if i == n_cols or i == n_cols*2 or i == n_cols*3 or i == n_cols*4 then
			print("\t\t</div>")
		end

	end

	-- CLOSE
	print("\n\t\t</div>\n\t</div>\n</div>")
else
	print("IT Vision - [monitor] malfunction. Please contact system administrator.")
end

print(html_footer)


?>


