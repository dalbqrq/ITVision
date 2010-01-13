
html_content_type = "Content-type: text/html\r\n\r\n"
text_content_type = "Content-type: text/plain\r\n\r\n"


html_header = [[
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>ITVision</title>
<link href="images/favicon.ico" rel="shortcut icon">
<link href="css/style.css" rel="stylesheet" type="text/css" />
<link href="css/tables.css" rel="stylesheet" type="text/css" />
<link href="css/menui.css" rel="stylesheet" type="text/css" />


<!-- ------------------------------------------------ -->
<!-- jQuery -->
<script type="text/javascript" src="js/jquery-1.2.1.min.js"></script>
<!-- required plugins -->
<script type="text/javascript" src="js/date.js"></script>
<!--[if IE]><script type="text/javascript" src="js/jquery.bgiframe.js"></script><![endif]-->
<!-- jquery.datePicker.js -->
<script type="text/javascript" src="js/jquery.datePicker.js"></script>
<!-- CSS is required for datepicker -->
<link href="css/datePicker.css" rel="stylesheet" type="text/css" />
<!-- ------------------------------------------------ -->

<script type="text/javascript">
    $(function() {
		$('.date-pick').datePicker('01/01/2008').val(new Date().asString()).trigger('change');
		$('.date-pick').datePicker({startDate:'01/01/1996'});
	});
</script>
</head>
]]

html_header_refresh = [[
<head>
<META http-equiv="refresh" content="15" target="main">
</head>
]]


html_menui = [[

<body>
<a name="top" id="top"></a>
<center>
		<div id="header">
			<!--
			<a href=http://www.proderj.rj.gov.br>
			<img src="images/logo_proderj2.jpg" alt="Proderj" border=0 class="logoverto" />
			</a>
			-->

			<img src="images/logopurple_only.png" alt="Realistic IT Vision" height=34 border=0 class="logo" />

			<a href=http://www.proderj.rj.gov.br>
			<img src="images/logo_proderj1.jpg" alt="Proderj" height=34 border=0 class="logoproderj" />
			</a>

			<a href=http://www.verto.com.br>
			<img src="images/verto_1.jpg" alt="Verto" height=34 border=0 class="logoverto" />
			</a>

			<h2>ITVision</h2>
		</div>
		
		<div id="menuh-container"> 
			<div id="menug">
			<div id="menuh">

			<!-- MENU ORIGINAL ------------------------------------------
			<ul>
				<li	><a href="system_resume.lp" >m&eacute;tricas</a>
			</ul>
			<ul>
				<li	><a href="applic_resume.lp" >aplica&ccedil;&otilde;es</a>
			</ul>
			<ul>
				<li	><a href="report_show.lp?applic=_TODAS_&date1=01/11/2008&date2=01/12/2008&tipo=resumo&sep=;" >atividade</a>

			</ul>
			<ul>
				<li	><a href="report.lp" >eventos</a>
			</ul>
			<ul>
				<li	><a href="admin_auth.lp" >admin</a>
			</ul>
			<ul>
				<li	><a href="help.lp" >ajuda</a>
			</ul>
			<ul>
				<li	><a href="login.lp?mess=LOGOUT" >logout</a>
			</ul>
			-->

			<!-- MENU COM SUB-MENUS
			<ul>
				<li	><a href="#" >relat&oacute;rios</a>
				<ul>
					<li><a href="#">eventos</a></li>
					<li><a href="#">uptime</a></li>
				</ul>
			</ul>
				<li	><a href="#">m&eacute;tricas</a>
			---------------------------------------------------- -->
		
			<ul>
				<li	><a href="applic_resume.lp?period=month" >monitora&ccedil;&atilde;o</a>
				<ul>
					<li	><a href="applic_resume.lp?period=month" >aplica&ccedil;&otilde;es</a>
					<li	><a href="hosts.lp" >hardwares</a>
					<li	><a href="services.lp" >softwares</a>
					<li	><a href="report.lp" >eventos</a>
			<!--		<li	><a href="#" >alertas</a> -->
				</ul>
			</ul>

			<ul>
				<li	><a href="system_resume.lp?period=month" >m&eacute;tricas</a>
				<ul>
					<li	><a href="system_resume.lp?period=month" >globais</a>
					<li	><a href="report_dispo.lp?applic=_TODAS_&period=month" >disponibilidade</a>
					<li	><a href="report_efici.lp?period=month" >efici&ecirc;ncia</a>
					<li	><a href="#" >escalabilidade</a>
					<li	><a href="#" >custo</a>
					<li	><a href="#" >capacidade</a>
					<li	><a href="#" >n&iacute;vel de servi&ccedil;o</a>
					<li	><a href="#" >seguran&ccedil;a</a>
					<li	><a href="#" >continuidade</a>
					<li	><a href="#" >integridade</a>
					<li	><a href="#" >gerenciabilidade</a>
				</ul>
			</ul>
		
			<ul>
				<li	><a href="#" >gerenciamento</a>
				<ul>
					<li	><a href="#" >service desk</a>
					<ul>
						<li	><a href="#" >incidentes</a>
						<li	><a href="#" >mudan&ccedil;a</a>
						<li	><a href="#" >problema</a>
					</ul>
					<li	><a href="#" >invent&aacute;rio/CMDB</a>
					<li	><a href="#" >seguran&ccedil;a</a>
					<li	><a href="#" >desempenho</a>
				</ul>
			</ul>

			<ul>
				<li	><a href="admin_auth.lp" >&uacute;til</a>
				<ul>
					<li	><a href="login.lp?mess=LOGOUT" >logout</a>
					<li	><a href="admin_auth.lp" >manuten&ccedil;&atilde;o</a>
					<li	><a href="help.lp" >ajuda</a>
					<li	><a href="about.lp" >sobre</a>
				</ul>
			</ul>
			<ul>
				<li	><a href="login.lp?mess=LOGOUT" >LOGINOUT</a>
			</ul>
		
			</div> 
			</div>
		</div>
]]

html_body = [[
		<div id="content">
			<div id="mainbar"> 
]]

html_footer = [[
	<div id="footer">
		Sponsored by <a href="http://www.verto.com.br">Verto</a> <!-- &AMP; <A HREF="http://www.atmax.com.br">Atmax</a> --> - version 0.2.6
			
	</div>
</center>
</body>
</html>
]]

html_confirm_window = [[
<script type="text/javascript"> 
	<!--
	function confirmation(question, url) { 
		var answer = confirm(question) 
		if (answer){ 
			//alert("The answer is OK!"); 
			window.location = url;
		} else { 
			//alert("The answer is CANCEL!") 
		} 
	} 
	-->
</script> 
]]
