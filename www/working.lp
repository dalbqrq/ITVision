#!/usr/bin/env /usr/local/bin/cgilua.cgi

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
print("\n<h1><a name=\"intro\" id=\"intro\"></a>funcionalidade em desenvolvimento</h1></div>")
?>

<center>
<img src="images/logopurple_big.png" alt="ITVision" border=0 />
<h1>ITVision</h1>
<p><p>

<p>
<img src="images/verto_1.jpg" alt="Verto" height=34 border=0/>

<?lua
print("</div>")
print(html_footer)
?>
