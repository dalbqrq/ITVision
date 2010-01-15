#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_monitor_html"
require "v_auth"
require "m_users"

local auth = checkauth_redirect('admin')
local u = get_user(auth)


print(html_header)
print(do_html_menui(u.name))
print(html_confirm_window)
print(html_body)
--print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>administra&ccedil;&atilde;o</h1>")
--print("\t\t\t</div>")
--print("\t\t\t</div>")

-- BACKUP -----------------------------------
print("<div id=\"content\">")
print("<div id=\"mainbar\">")
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>backup</h1>")
print("\t\t\t</div>")
print("Para realizar o backup do sistema, clique no bot&atilde;o abaixo. Ap&oacute;s a confirma&ccedil;&atilde;o, salve o arquivo de backup em seu disco local.")

question = "Deseja gerar arquivo de backup do sistema?"
url = "osexecute.lp?cmd=backup"
label = "backup"
print("<form>")
print("<input type=\"button\" onclick=\"confirmation('"..question.."','"..url.."')\" value=\""..label.."\">")
print("</form>")

print("\t\t\t</div>")

-- REINIT -----------------------------------
print("<div id=\"content\">")
print("<div id=\"mainbar\">")
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>reinicia subsistema monitor</h1>")
print("\t\t\t</div>")
print("Para re-inicializar o subsistema de monitora&ccedil;&atilde;o, clique no bot&atilde;o abaixo. Ap&oacute;s a confirma&ccedil;&atilde;o, o sistema ir&aacute; levar em torno de 1 minuto (ou mais dependendo a quantidade de verifica&ccedil;&otilde;es que s&atilde;o realizadas) para retomar a sua opera&ccedil;&atilde; normal.")

question = "Confirma a re-inicializa&ccedil;&atilde;o da monitora&ccedil;&atilde;o?"
url = "osexecute.lp?cmd=reinit"
label = "reinicia monitor"
print("<form>")
print("<input type=\"button\" onclick=\"confirmation('"..question.."','"..url.."')\" value=\""..label.."\">")
print("</form>")

print("\t\t\t</div>")


-- REBOOT -----------------------------------
print("<div id=\"content\">")
print("<div id=\"mainbar\">")
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>reboot</h1>")
print("\t\t\t</div>")
print("Para re-inicializar o sistema, clique no bot&atilde;o abaixo. Ap&oacute;s a confirma&ccedil;&atilde;o, o sistema ir&aacute; levar de 1 a 3 minutos para entrar totalmente em opera&ccedil;&atilde;o dependendo do hardware em que ele se encontra instalado.")

question = "Confirma a re-inicializa&ccedil;&atilde;o do sistema?"
url = "osexecute.lp?cmd=reboot"
label = "reboot"
print("<form>")
print("<input type=\"button\" onclick=\"confirmation('"..question.."','"..url.."')\" value=\""..label.."\">")
print("</form>")

print("\t\t\t</div>")

-- SHUTDOWN -----------------------------------
print("<div id=\"content\">")
print("<div id=\"mainbar\">")
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>shutdown</h1>")
print("\t\t\t</div>")
print("Para desligar o sistema, clique no bot&atilde;o abaixo. Ap&oacute;s a confirma&ccedil;&atilde;o, o sistema ir&aacute; se desativar automaticamente.")
	
question = "Confirma o desligamento do sistema?"
url = "osexecute.lp?cmd=shutdown"
label = "shutdown"
--print("<form method=\"post\" action=\"auth_admin.lp\">")
print("<form>")
--print("<label>Password: </label><input name=\"pass\" type=\"password\" maxlength=\"20\" size=\"20\">")
print("<input type=\"button\" onclick=\"confirmation('"..question.."','"..url.."')\" value=\""..label.."\">")
print("</form>")


print("\t\t\t</div>")
print("\t\t\t</div>")
print("\t\t\t</div>")

-----------------------------------

print(html_footer)
?>


