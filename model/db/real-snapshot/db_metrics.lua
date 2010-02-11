
--	eficiency      = { 0.5, 0.4, 0.3, 0.2, 0.1 },

metric {
	disponibility  = { 95, 99.0, 99.5, 99.9, 99.999 },
	eficiency      = { 500, 400, 300, 200, 100 },
	scalability    = { 12, 20, 30, 40, 50 },
	cost           = { 13, 20, 30, 40, 50 },
	capacity       = { 14, 20, 30, 40, 50 },
	service_level  = { 15, 20, 30, 40, 50 },
	security       = { 16, 20, 30, 40, 50 },
	integrity      = { 17, 20, 30, 40, 50 },
	gerenciability = { 18, 20, 30, 40, 50 },
	continuity     = { 19, 20, 30, 40, 50 }
}

--[[  metric-list is ordered! The second entry of each metric 
      indicates the "better" values. If positive, bigger values are better
	  if negative, smaller values are better ]]--
metric_list { 
	{ 'disponibility',  1 }, -- percentage
	{ 'eficiency',     -1 }, -- miliseconds
	{ 'scalability',    1 }, -- ?
	{ 'cost',          -1 }, -- currency ($)
	{ 'capacity',       1 }, -- ?
	{ 'service_level',  1 }, -- ?
	{ 'security',       1 }, -- ?
	{ 'integrity',      1 }, -- ?
	{ 'gerenciability', 1 }, -- ?
	{ 'continuity',     1 }  -- ?
}

