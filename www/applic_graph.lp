#!/usr/bin/env /usr/local/bin/cgilua.cgi

<?lua
require "v_gviz"
require "v_monitor_inc"
require "v_monitor_html"
require "v_auth"
require "m_users"
require "m_io_util"

local auth = checkauth_redirect()
local u = get_user(auth)

app_name = cgilua.QUERY.app_name
app_file_name = string.gsub(app_name, " ", "_")

print(html_header)
print(html_header_refresh)
print(do_html_menui(u.name))
print(html_body)
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>"..app_name.."</h1>")
print("\t\t\t</div>")
print("\t\t\t</div>")

app = string.gsub(app_name, " ", "%%20")

if (app_name == "REDE PRODERJ") then

	-- GERAR GRAFICO DA REDE DO PRODERJ AUTOMATICAMENTE COLOCANDO AS CORES CONFORME O ESTADO
	--make_proderj_network()
	print(text_file_reader('../www/figs/proderj_network.map'))
	print("\n<img src=\"figs/proderj_network.png\" alt=\"Realistic IT Vision\" \
		border=0 class=\"figs\" USEMAP=\"#proderj_network\" />")
else
	make_graphviz_img(app_name)
	print(text_file_reader('../www/figs/'..app_file_name..'.map'))
	print("\n<img src=\"figs/"..app_file_name..".png\" alt=\"Realistic IT Vision\" \
		border=0 class=\"figs\" USEMAP=\"#"..app_name.."\" />")
end

--[[
print("::")
print(im)
print("::")
]]--

print("<p>")
print("\n<a href=applic_list.lp?app_name="..app..">Mudar para modo de Lista</a>")

print(html_footer)

?>
