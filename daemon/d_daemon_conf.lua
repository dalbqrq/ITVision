
state_message = { --  to substitute the [STATE] string on "daemon_conf" notifications fields below
	'NORMALIZADO',
	'CRITICO',
	'ANORMAL',
	'PENDENTE DE VERIFICACAO'
}


daemon_conf = {
	notification_email = '[ITVision] - Notificacao Email Proderj\nAplicacao: APPLIC_NAME\nFuncionamento: STATE\nData: DATE\nCRITICAL_ICS\n',
	notification_sms   = '[ITVision] - Notificacao SMS Proderj\nAplicacao: APPLIC_NAME\nFuncionamento: STATE\nData: DATE\n',
	max_check_attempts    = 3,
	check_interval        = 1,  -- in minutes
	notification_interval = 30,  -- in minutes
	command_line          = '/bin/mail -s ',
}


---------------------------------------------------------

daemon_conf_old = {
	notification_email = '[ITVision - Monitor] - Notificacao [CLIENT]!\n\nAplicacao [APPLIC_NAME] encontra-se [STATE]\nData: DATE\n',
	notification_sms   = '[ITVision - Monitor] - Notificacao [CLIENT]!\n\nAplicacao [APPLIC_NAME] encontra-se [STATE]\nData: DATE\n',
	max_check_attempts    = 3,
	check_interval        = 1,  -- in minutes
	notification_interval = 30,  -- in minutes
	command_line          = '/bin/mail -s ',
}

