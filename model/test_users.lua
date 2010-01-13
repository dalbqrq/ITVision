require 'm_users'
require 'm_io_util'

show_users()
--print(' ---------------------------------------- ')

u = get_user('admin')
print (u.name..' :: '..u.password)
print (u.apps[1])
print(' ---------------------------------------- ')


if auth_user(u.name, u.password) then
	print('AUTH')
else
	print('NOT AUTH')
end
