#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_gviz"
require "v_auth"
require "m_io_util"

checkauth_redirect()

app_name = cgilua.QUERY.app_name
app_file_name = string.gsub(app_name, " ", "_")

print(html_header)
print(html_header_refresh)
print(html_menui)
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
