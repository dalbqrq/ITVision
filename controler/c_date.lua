
function get_d_m_y()
	local d = tonumber(os.date('%d'))
	local m = tonumber(os.date('%m'))
	local y = tonumber(os.date('%Y'))

	return d, m, y
end


function last_date(last)
	local d, m, y, t1, t2, d1, d2
	d, m, y = get_d_m_y()

	t1 = os.time{year=y, month=m, day=d, hour=0} - last
	t2 = os.time{year=y, month=m, day=d+1, hour=0} 
	d1 = os.date('%d-%m-%Y', t1)
	d2 = os.date('%d-%m-%Y', t2)

	return d1, d2
end


function last_day()
	return last_date(60*60*24)
end


function last_week()
	return last_date(60*60*24*7)
end


function last_month()
	return last_date(60*60*24*30)
end


function last_semester()
	return last_date(60*60*24*30*6)
end


function last_year()
	return last_date(60*60*24*365)
end


