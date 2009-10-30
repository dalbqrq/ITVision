#!/usr/bin/env cgilua.cgi

<%
require "v_monitor_inc"
require "v_auth"
require "m_users"
require "cgilua.cookies"

print(html_header)
print(html_menui)
print(html_body)

print("<h1><a name=\"intro\" id=\"intro\"></a>login</h1>")
print("</div>")

if auth_user(cgilua.POST.user, cgilua.POST.pass) then
	setcookie(cgilua.POST.user)
	cgilua.redirect('../applic_resume.lp', nil)
else
	cgilua.redirect('../login.lp?mess=ERROR', nil)
end

print('</div>')
print(html_footer)
%>
