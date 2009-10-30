
require 'm_io_util'
require 'm_metrics'

metrics, names = select_metrics(nil)

showtable(metrics)
showtable(names)


for i, v in ipairs(names) do
	print('-----'..v..'----------')
	showtable(metrics[v])
end

