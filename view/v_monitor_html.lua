require 'v_monitor_inc'

function do_html_header()

end


function do_html_header_refresh()

end


function do_html_menui(user)

	if user then
		return(string.gsub(html_menui,'LOGINOUT',user..' : logout'))
	else
		return(string.gsub(html_menui,'LOGINOUT','login'))
	end
end


function do_html_body()

end


function do_html_footer()

end


function do_html_confirm_window()

end


