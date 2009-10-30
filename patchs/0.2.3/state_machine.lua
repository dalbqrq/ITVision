--require 'c_monitor_inc.lua'
APPLIC_UP                   = 0
APPLIC_DOWN                 = 1
APPLIC_WARNING              = 2
APPLIC_PENDING              = 3

--[[ DATA DICT (Example)
application_state {
	name =  "DNS Externo",
	date =  "Thu Jan 22 08:08:10 2009",
	time = 1232618890,
	services_down = { 
		{ "HHWSER006", "CRITICAL - Plugin timed out while executing system call", },
		{ "HHWSER007", "SSWVSR007", "CRITICAL - Plugin timed out while executing system call", },  
	},
	hosts_down = { 
		{ "HWSWI001", "(Host Check Timed Out)", },
		{ "HWSWI004", "(Host Check Timed Out)", },
	},
	status = 1,
	alert_sent = 1,
	has_changed = 0,
	d_attempts = 0,  -- down attempts
	w_attempts = 0,  -- warning attempts
	u_attempts = 0,  -- up attempts
} 
]]--

states = {
	up = APPLIC_UP,
	down = APPLIC_DOWN,
	warning = APPLIC_WARNING,
	pending = APPLIC_PENDING
}


local STATE = states.none

function next_state(OLD_STATE,NEW_STATE) 

	for i,n in ipairs(new_state) do	
	for j,o  in ipairs(old_state) do
		if n.name == o.name then -- if application found on old_state table...
			
			y = 0

		end
	end
	end

	return new_STATE
end


STATE = next_state(STATE)

