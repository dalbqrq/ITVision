
require 'm_io_util'

function get_label(field_key, key, return_field)
	dofile('db/db_ics.lua')

	for _,v in ipairs(ics) do
		if v[field_key] == key then
			return v[return_field]
		end
	end

end


print(get_label(1, 'SWVSR001', 3))

