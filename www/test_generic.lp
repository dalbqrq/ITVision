#!/usr/bin/env cgilua.cgi

<?lua
require "v_monitor"
require "v_monitor_inc"
require "v_auth"
require "m_users"
require "m_read_log"
require "c_monitor"
require "c_date"

--[[
local auth = checkauth_redirect()
local u = get_user(auth)


if ( cgilua.QUERY.period ~= nil ) then
	period = cgilua.QUERY.period
else
	period = cgilua.POST.period
end
]]--

local res, n_res
local s, d1, d2, t = {}
local lcolor, t_hosts, t_servs, h_alert, s_alert, status = get_status_resume()

res = get_applications_resume()
n_res = table.getn(res)

?>
