#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "c_monitor"

print(html_header)
print(html_menui)
print(html_body)
print("\n<h1><a name=\"intro\" id=\"intro\"></a>sobre</h1></div>")
?>

<center>
<img src="images/logopurple_big.png" alt="ITVision" border=0 />
<h1>ITVision</h1>
<h3>version 0.2.6</h3>
<p><p>

<b>ITVision</b> &eacute; um sistema de monitora&ccedil;&atilde;o, gerenciamento 
<br>
e gest&atilde;o para infra-estruturas computacionais desenvolvido pela
<br>
<b>Verto Technologies</b>.

<p>
<img src="images/verto_1.jpg" alt="Verto" height=34 border=0/>

<?lua
print("</div>")
print(html_footer)
?>
