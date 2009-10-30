require "cgilua.cookies"

function setcookie(user)
	user = user or 'guest'
	cgilua.cookies.set('itvision_auth', 'AUTH')
	cgilua.cookies.set('itvision_user', user)
end

function getcookie()
	auth = cgilua.cookies.get ('itvision_auth')
	user = cgilua.cookies.get ('itvision_user')
	return auth, user
end

function delcookie()
	cgilua.cookies.delete('itvision_auth')
	cgilua.cookies.delete('itvision_user')
end


function checkauth(username)
	auth, user = getcookie()

	if auth ~= 'AUTH' then 
		return false, 'NOT'
	elseif ( username ~= nil and username ~= user ) then 
		return false, 'NOTUSER'
	else
		return true, 'OK'
	end
end

function checkauth_redirect(username, url)
	auth, mess = checkauth(username)

	if not auth then
		url = url or '../login.lp?mess='..mess
		cgilua.redirect(url, nil)
	end
end

