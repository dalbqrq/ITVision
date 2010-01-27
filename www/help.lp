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
print("\n<h1><a name=\"intro\" id=\"intro\"></a>introdu&ccedil;&atilde;o</h1></div>")
?>
ITVision - [monitor] &eacute; um sistema de monitora&ccedil;&atilde;o e emiss&atilde;o de 
alertas para infra-estruturas computacionais compostas por equipamentos de rede, servidores 
e servi&ccedil;os. Sua monitora&ccedil;&atilde;o  &eacute; feita atrav&eacute;s de componentes
configurados especificamente para cada tipo de item (equipamento ou servi;ccdeil;o) e seus alertas 
s&atilde;o apresentados visualmente pela interface web ou enviados atrav&eacute;s de e-mail ou sms, 
conforme configura&ccedil;&atilde;o.

<p>
Sua implementa&ccedil;&atilde;o &eacute; orientada &agrave; aplica&ccedil;&atilde;o permitindo que
a monitora&ccedil;&atilde;o seja feita com base no funcionamento de um grupo de equipamentos e
servi&ccedil;os que comp&otilde;e



<?lua
print("<div id=\"mainbar\">")
print("\n<h1><a name=\"intro\" id=\"intro\"></a>documenta&ccedil;&atilde;o</h1></div>")
?>
Para ter acesso a documenta&ccedil;&atilde;o, baixe o arquivo pdf neste <a href="manual/Manual_ITVision_Geral.pdf">link</a>.
<br>
<br>

<?lua
--print("<div id=\"mainbar\">")
--print("\n<h1><a name=\"intro\" id=\"intro\"></a>navera&ccedil;&atilde;o</h1></div>")
?>
<!--
nonon non o no no non nonono nonnnoo non 
nonon non o no no non nonono nonnnoo non 
nonon non o no no non nonono nonnnoo non 
nonon non o no no non nonono nonnnoo non 
nonon non o no no non nonono nonnnoo non 
-->


<?lua
print("</div>")
print(html_footer)
?>
