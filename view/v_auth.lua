require "cgilua.cookies"

function setcookie(user)
	local user = user or 'guest'
	cgilua.cookies.set('itvision_auth', 'AUTH')
	cgilua.cookies.set('itvision_user', user)
end

function getcookie()
	local auth = cgilua.cookies.get ('itvision_auth')
	local user = cgilua.cookies.get ('itvision_user')
	return auth, user
end

function delcookie()
	cgilua.cookies.delete('itvision_auth')
	cgilua.cookies.delete('itvision_user')
end


function checkauth(username)
	local auth, user = getcookie()

	if auth ~= 'AUTH' then 
		return false, 'NOT', user
	elseif ( username ~= nil and username ~= user ) then 
		return false, 'NOTUSER', user
	else
		return true, 'OK', user
	end
end

function checkauth_redirect(username, url)
	local auth, mess, user = checkauth(username)

	if not auth then
		local url = url or '../login.lp?mess='..mess
		cgilua.redirect(url, nil)
	end
	return user
end

