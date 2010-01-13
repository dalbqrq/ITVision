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
print("\n<h1><a name=\"intro\" id=\"intro\"></a>alertas</h1></div>")
?>
Os alertas visuais s&atilde;o apresentados em diversas telas da interface web do sistema. Em todas
elas, as cores possuem o mesmo segnificado, conforme descrito a seguir:
<br>
<br>
<!--<div id="alert"> <div id="semialert"></div></div>-->
<div id="semialert"></div>
<!--<div id="alert"> <div id="green">aplica&ccedil;&atilde;o </div>ok</div>-->
<div id="alert"> <div id="green">nome aplic</div>ok</div>
<div id="alert"> <div id="red">nome aplic</div>down</div>
<div id="alert"> <div id="yellow">nome aplic</div>warning</div>
<div id="alert"> <div id="blue">nome aplic</div>pending</div>

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
A cor VERDE indica funcionamento correto da aplica&ccedil;&atilde;o ou de um item de configura&ccedil;&atilde;o.
<br>
A cor VERMELHA indica mal funcionamento da aplica&ccedil;&atilde;o ou de um item de configura&ccedil;&atilde;o.
<br>
A cor AMARELA indica que determinada aplica&ccedil;&atilde;o ou item de configura&ccedil;&atilde;o funcionam precariamente.
<br>
A cor AZUL indica que algum item de configura&ccedil;&atilde;o de determinada aplica&ccedil;&atilde;o ainda
n&atilde;o foi testado pelo sistema
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
