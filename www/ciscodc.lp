#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "c_monitor"
require "v_monitor_html"
require "v_auth"
require "m_users"

local auth = checkauth_redirect()
local u = get_user(auth)


print(html_header)
print(do_html_menui(u.name))
print(html_body)
print("\n<h1><a name=\"intro\" id=\"intro\"></a>CISCO CATALIST 6509 D1/D2</h1></div>")
?>

<center>
<h1>PAGINA DO NEDI COM INFORMACOES COMPLETAS SOBRE O CISCO 6509/D1 & 6509/D2</h1>
<p><p>
<br>
<p><p>



<?lua
print("</div>")
print(html_footer)
?>
