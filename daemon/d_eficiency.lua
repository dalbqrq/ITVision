require 'm_io_util'			-- only used for 'showtable()' function
require 'c_eficiency'


function calculate_eficiency ()

	local old_efic = read_applications_eficiency()
	--[[ DEBUG 
	print('~OLD~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	showtable(old_efic[1])
	]]--

	local curr_efic = get_applications_eficiency()
	--[[ DEBUG 
	print('~CURR~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	showtable(curr_efic[1])
	]]--

	local new_efic = calc_applications_eficiency(old_efic, curr_efic)
	--[[ DEBUG 
	print('~NEW~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
	showtable(new_efic[1])
	]]--

	write_applications_eficiency(new_efic)

	return new_efic
end

new = calculate_eficiency()
--res = resume_eficiency()
--showtable(res)
