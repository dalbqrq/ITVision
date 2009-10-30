#!/usr/bin/env cgilua.cgi

<?lua
require "m_read_log"
require "v_auth"

checkauth_redirect()

cgilua.contentheader('application','octet-stream\nContent-Disposition: attachment; filename=relatorio.txt;')
s = alert_report_list(cgilua.QUERY.applic, cgilua.QUERY.date1, cgilua.QUERY.date2, cgilua.QUERY.sep)
cgilua.put(s)
?>
