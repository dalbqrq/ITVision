#!/usr/bin/env cgilua.cgi

<%
require 'v_monitor_inc'
require 'c_monitor'
require 'v_auth'

checkauth_redirect()

apps = select_applications()

print(html_header)
print(html_menui)
print(html_body)

-- REPORT
print('\n\t\t\t\t<h1><a name=\'intro\' id=\'intro\'></a>lista de eventos</h1>')
print('\t\t\t</div>')

-- FORM
--<form method='post' id='chooseDateForm' action='ts.lp'>
%>
<form method='post' id='chooseDateForm' action='event_list.lp'>
	<fieldset>

	aplica&ccedil;&atilde;o: <select name='applic'>
<%
	print(' <option value=_TODAS_>TODAS</option>')
	for i, v in ipairs(apps) do
		value = string.gsub(v.name, ' ', '_')
		print(' <option value='..value..'>'..v.name..'</option>')
	end
%>
	</select>

<!-- asume como default e unico valor possivel a lista de eventos como relatorio gerador por esta pagina.
    <p>
	tipo de relat&oacute;rio: <select name='tipo'>
	print(' <option value="lista">lista de eventos</option>')
	print(' <option value="resumo">resumo</option>')
	</select>
-->

<!-- VER DATEPICKER EM: http://www.kelvinluck.com/assets/jquery/datePicker/v2/demo/index.html -->

    <p>
	data in&iacute;cio: 
	<input name='date1' id='date1' class='date-pick' />
	<p>
	data fim: 
	<input name='date2' id='date2' class='date-pick' />

<!-- assume como default e unico valor possivel a virgula como separador de arquivo.
    <p>
	separador: <select name='sep'>
	print(' <option value=",">, (v&iacute;rgula)</option>')
	print(' <option value=";">; (ponto-e-v&iacute;rgula)</option>')
	print(' <option value="|">| (barra vertical)</option>')
	</select>
-->
	</fieldset>
<p>
    <input type='submit' value='gerar lista'>
    <input type='reset' value='re-iniciar'>
</form>

<%
print('</div>')
print(html_footer)
%>
