#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_monitor"
require "v_gviz"
require "c_monitor"
require "m_dbs"
require "db_ics_profile"
require "v_monitor_html"
require "v_auth"
require "m_users"
require "m_disableds"
require "m_import_csv"


local auth = checkauth_redirect()
local u = get_user(auth)

ickey = cgilua.QUERY.ickey
enable = cgilua.QUERY.enable

local x = "ihh"
local x = enable
local x = ickey

if enable ~= nil then
	-- TODO: change_active_checks_enabled of ickey

	if enable == "0" then
		insert_disableds(ickey)
x = "hi"..enable..ickey
	elseif enable == "1" then
		delete_disableds(ickey)
x = "ho"..enable..ickey
	end

	make_cfg_file()
	s = os.capture("sudo -u root /etc/init.d/nagios restart")
	s = os.capture("sleep 3")
	local url = '../ics.lp'
	local args = { ickey = ickey }
--	cgilua.redirect(url, args)

end

local found
local ic = ic_get_table(1, ickey)
local t_hosts, t_servs, h_alert, s_alert, status
local state_color, state_name, state_plugin
local t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()
	
-- procura a chave em hosts
for i, s in ipairs(status.hoststatus) do
	if s.host_name == ic[1] then
		found = true
		state_color  = color[h_alert[s.current_state+1].color]
		state_name   = h_alert[s.current_state+1].name
		state_cmd    = s.check_command
		state_plugin = s.plugin_output
		state_enable = s.active_checks_enabled
	end
end

-- se nao achou, procura a chave em services
if not found then
	for i, s in ipairs(status.servicestatus) do
		if s.service_description == ic[1] then
			state_color  = color[s_alert[s.current_state+1].color]
			state_name   = s_alert[s.current_state+1].name
			state_cmd    = s.check_command
			state_plugin = s.plugin_output
			state_enable = s.active_checks_enabled
		end
	end
end

if state_enable == 0 then
	state_color = "purple"
end

print(html_header)
print(do_html_menui(u.name))
print(html_confirm_window)
print(html_body)


if enable ~= nil then
print(x)
end
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>".. ic[3] .."</h1>")
print("\t\t\t</div>")
print("\t\t\t<div id=\"content\">")
-- -------------------------------------------------
	print("\t\t\t<p>")
	print("\t\t<TABLE width=800;>")
	print("\t\t\t<TR>")
	print("\t\t\t\t<TH width=150px>ATRIBUTO</TH>")
	print("\t\t\t\t<TH width=150px>VALOR</TH>")
	print("\t\t\t\t<TH width=150px>ATRIBUTO</TH>")
	print("\t\t\t\t<TH width=350px>VALOR</TH>")
	print("\t\t\t</TR>")

		-- Exemplos de link e celula colorida
		--print("\t\t\t&nbsp &nbsp &nbsp &nbsp &nbsp <b>"..ic_profile[i].." : </b> &nbsp&nbsp "..v.."<br>")
		--print("\t\t\t<TR>")
		--print("\t<TD BGCOLOR=\"#f2f2f2\"><a href=applic_list.lp?app_name="..l[3]..">" .. l[3] .. "</TD>")
		--print("\t<TD ALIGN=\"CENTER\" BGCOLOR=\""..color[cor].."\">"..l[4] .."</TD>")
		--print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 4 -- hostname
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</b></TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		-- status
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b> Status</TD>")
		--print("\t<TD ALIGN=\"CENTER\" BGCOLOR=\""..color[cor].."\">"..l[4] .."</TD>")
		--print("\t<TD BGCOLOR=\"lightgreen\">UP</TD>")
		print("\t<TD BGCOLOR=\""..state_color.."\">"..state_name .."</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>");
		i = 6 -- ip
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</b></TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		-- plugin_output
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b> Check output</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. state_plugin .. "</TD>")
		-- plugin command
		--print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b> Check output</TD>")
		--print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. state_cmd .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 15 -- localiza
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 5 --macaddr
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b><b>" .. ic_profile[i] .. "</b></TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 12 --familia
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 18 -- fornecedor
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 13 --classe
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 8 --fabricante
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 1 -- chave
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 9 -- cod fabricante
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 3 -- label
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 10 -- mod fabricante
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 2 -- sn
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 16 -- usuario reponsavel
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 7 --patrimonio
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 17 -- inicio reposabilidade
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

	print("\t\t</TABLE>")

	print(www_enable_ic(ickey, state_enable))
--	print("\t<br>")
-- -------------------------------------------------


-- -------------------------------------------------
print("\t\t\t</div>")
print("<div id=\"content\">")
print("<div id=\"mainbar\">")
print("\n\t<h2><a name=\"intro\" id=\"intro\"></a>informa&ccedil;&otilde;es extras</h2>")

	print("\t\t\t<p>")
	print("\t\t<TABLE width=760;>")
	print("\t\t\t<TR>")
	print("\t\t\t\t<TH width=150px>ATRIBUTO</TH>")
	print("\t\t\t\t<TH width=230px>VALOR</TH>")
	print("\t\t\t\t<TH width=150px>ATRIBUTO</TH>")
	print("\t\t\t\t<TH width=230px>VALOR</TH>")
	print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 24 -- custo
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 14 -- termo garantia
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>");
		i = 20 -- data compra
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b><b>" .. ic_profile[i] .. "</b></TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 21 -- data entrada
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 22 -- status corrente
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 23 -- status agendado
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 19 -- licenca
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b><b>" .. ic_profile[i] .. "</b></TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 11 --versoes
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

--[[
		print("\t\t\t<TR>"); 
		i = 25 --  extra1
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 26 -- extra2
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 27 -- extra3
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 28 -- extra4
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")

		print("\t\t\t<TR>"); 
		i = 29 -- extra5
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		i = 30 -- extra6
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
		print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. ic[i] .. "</TD>")
		print("\t\t\t</TR>")
]]--


	print("\t\t</TABLE>")
	print("\t<br>")
-- -------------------------------------------------

--[[  APRESENTACAO SIMPLES DOS ATRUBITOS DE UM IC
for i,v in ipairs(ic) do
	if i < 100 then
		print("\t\t\t&nbsp &nbsp &nbsp &nbsp &nbsp <b>"..ic_profile[i].." : </b> &nbsp&nbsp "..v.."<br>")
	end
end
]]--

--[[ MOSTRA TODOS OS ATRIBUTOS DE UM IC EM UMA TABELA
	print("\t\t\t<p>")
	print("\t\t<TABLE width=800;>")
	print("\t\t\t<TR>")
	print("\t\t\t\t<TH>NUM</TH>")
	print("\t\t\t\t<TH>ATRIBUTO</TH>")
	print("\t\t\t\t<TH>VALOR</TH>")
	print("\t\t\t</TR>")

	for i,v in ipairs(ic) do
		if i < 100 then
			print("\t\t\t<TR>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. i .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\"><b>" .. ic_profile[i] .. "</TD>")
			print("\t\t\t\t<TD BGCOLOR=\"#f2f2f2\">" .. v .. "</TD>")
			print("\t\t\t</TR>")
		end
	end

	print("\t\t</TABLE>")
	print("\t<br>")
]]--

print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t\t\t</div>")


print(html_footer)
?>
