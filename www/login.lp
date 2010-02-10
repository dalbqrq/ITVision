#!/bin/env /usr/local/bin/cgilua.cgi

<%
require "v_monitor_inc"
require "v_monitor_html"
require "v_auth"
require "m_users"

--local auth = checkauth_redirect()
--local u = get_user(auth)

auth, user = getcookie()

if auth == 'AUTH' then 
    cgilua.redirect('../applic_resume.lp')
end

mess = cgilua.QUERY.mess
if mess == 'LOGOUT' then
	delcookie()
    cgilua.redirect('../login.lp')
end

print(html_header)
print(do_html_menui())
print(html_body)

print("<h1><a name=\"intro\" id=\"intro\"></a>login</h1>")
print("</div>")
%>

<form method="post" action="auth.lp">
	<fieldset>
    <label>User name: </label><input name="user" maxlength="20" size="20">
    <label>Password: </label><input name="pass" type="password" maxlength="20" size="20">
	</fieldset>
<%
if mess == 'ERROR' then
	print('<p>Nome e/ou senha inv&aacute;lidos. Tente novamente.</p>')
elseif mess == 'NOT' then
	print('<p>Usu&aacute;rio n&atilde;o autenticado.</p>')
elseif mess == 'NOTADMIN' then
	print('<p>Usu&aacute;rio n&atilde;o possui permiss&atilde;o.</p>')
end
%>
<br>
    <input type="submit" value="login">
    <input type="reset" value="re-iniciar">
</form>
</div>

<%
print(html_footer)
%>
