require 'm_users'
require 'm_io_util'

--t_users = select_users(nil)
--showtable(t_users)
--print(' ---------------------------------------- ')

--show_users()
--print(' ---------------------------------------- ')

u = get_user('daniel')
print (u.name..' :: '..u.password)
print(' ---------------------------------------- ')

if auth_user('daniel', 'mttp0c0s') then
	print('AUTH')
else
	print('NOT AUTH')
end
