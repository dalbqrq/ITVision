#!/usr/bin/env /usr/local/bin/cgilua.cgi

<?lua
require "m_io_util"
require "v_auth"

if not checkauth('admin') then
	cgilua.redirect('../login.lp?mess=LOGOUT')
end

local s=''
io.input('/tmp/itvision_bkp.tar')
s = io.read("*all")

--Content-Type: application/octet-stream
dispo = [[
Content-Type: application/force-download
Content-Type: application/download
Content-Disposition: attachment; filename=itvision_bkp.tar;
Content-Transfer-Encoding: binary
]]

--cgilua.contentheader('application','octet-stream\nContent-Disposition: attachment; filename=itvision_bkp.tar;')
cgilua.contentheader('application',dispo)
cgilua.put(s)
?>
