
require 'm_applications'
require 'c_monitor'

function get_app(app_list)

        local apps = { "DB", "DBServer" }
        local applic = select_applications(apps)

	print('--------------------')
	for i, v in ipairs(applic) do
		print(v.name)
	end
	print('--------------------')

end

--get_app()
get_applications_resume()
