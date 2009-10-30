require 'm_metrics'
require 'm_io_util'


function calc_factor(val)
	local a, b
	local fac = { 0, 0, 0, 0, 0,  0, 0, 0, 0, 0 }

	mets, names = select_metrics()
	-- [[ DEBUG ]] showtable(mets) 

	for j, w in ipairs(val) do
		m = mets[names[j][1]]
		--[[ DEBUG
		print('---------------------------------------------')
		print(names[j][1]..' -> '..j..' = '..w..' order is '..names[j][2])
		showtable(m) 
		]]--

		-- if names[j][2] are negative, better values are the smaller ones
		-- See: db_metrics.lua file

		if names[j][2] < 0 then  
			a = 6; b = -1 -- makes m entries decrease
		else
			a = 0; b = 1  -- makes m entries increase
		end

		if w == -1 then
			fac[j] = -1
		elseif w < m[a + b*1] then
			fac[j] = 0
		elseif w >= m[a + b*1] and w < m[a + b*2] then
			fac[j] = 1
		elseif w >= m[a + b*2] and w < m[a + b*3] then
			fac[j] = 2
		elseif w >= m[a + b*3] and w < m[a + b*4] then
			fac[j] = 3
		elseif w >= m[a + b*4] and w < m[a + b*5] then
			fac[j] = 4
		elseif w >= m[a + b*5] then
			fac[j] = 5
		end
		--print('factor is '.. fac[j])
	end

	return fac
end

--f = calc_factor({20, 300, 0, 40, 42, 32, 21, 11, 39.999, -1 })
--showtable(f)
