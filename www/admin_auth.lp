#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor_inc"
require "v_monitor_html"
require "v_auth"
require "m_users"

local auth = checkauth_redirect()
local u = get_user(auth)



print(html_header)
print(do_html_menui(u.name))
print(html_confirm_window)
print(html_body)
print("\n\t\t\t\t<h1><a name=\"intro\" id=\"intro\"></a>administra&ccedil;&atilde;o</h1>")
print("\t\t\t</div>")

if not checkauth('admin') then
?>
Para utilizar as funcionalidades de manuten&ccedil;&atilde;o do sistema voc&ecirc; precisa estar logado como administrador.
<form method="post" action="login.lp?mess=LOGOUT">
<br>
<input type="submit" value="Desejo me logar como administrador">
</form>

<form method="post" action="applic_resume.lp">
<br>
<input type="submit" value="N&atilde;o, desejo continuar a usar o sistema com o usu&aacute;rio atual">
</form>

<?lua
else
	cgilua.redirect('../admin.lp')
end

print("\t\t\t</div>")
print("\t<br>")

print(html_footer)
?>


