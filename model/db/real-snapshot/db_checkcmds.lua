checkcmds = {
 {
  "Local Disk",
  "check_local_disk!20%!10%!/      ",
 },
 {
  "Local Users",
  "check_local_users!20!50         ",
 },
 {
  "Total Procs",
  "check_local_procs!250!400!RSZDT ",
 },
 {
  "Current Load",
  "check_local_load!5.0,4.0,3.0!10.0,6.0,4.0",
 },
 {
  "Swap",
  "check_local_swap!20!10          ",
 },
 {
  "DNS",
  "check_dns!www.google.com",
 },
 {
  "SMTP",
  "check_smtp",
 },
 {
  "IMAP",
  "check_imap",
 },
 {
  "LDAP",
  "check_ldap",
 },
 {
  "PING",
  "check_ping!500.0,30%!900.0,60%",
 },
 {
  "PING_L",
  "check_ping!1000.0,50%!2000.0,90%",
 },
 {
  "HTTP",
  "check_http",
 },
 {
  "HTTPS",
  "check_http!-S",
 },
 {
  "HTTP_clip",
  "check_http!-u /mclippingserver/DatabaseConnectionTest -e 'HTTP/1.1 200'",
 },
 {
  "PROXY_HTTP",
  "check_proxy",
 },
 {
  "WEB",
  "check_web",
 },
 {
  "SSH",
  "check_ssh",
 },
 {
  "UNIX_PROCS",
  "check_procs",
 },
 {
  "SNMP",
  "check_snmp",
 },
 {
  "POP3S",
  "check_pop!-S -p 995",
 },
 {
  "IMAPS",
  "check_imap!-S -p 993",
 },
}
