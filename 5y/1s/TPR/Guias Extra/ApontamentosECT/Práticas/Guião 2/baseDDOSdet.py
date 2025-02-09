import psutil
import re
import os

## Local network connection parser
allConns=psutil.net_connections()
for c in allConns:
	status=getattr(c,'status')
	pid=getattr(c,'pid')
	processname=psutil.Process(pid).name()
	if status==psutil.CONN_ESTABLISHED or status==psutil.CONN_SYN_RECV:
		print(getattr(c,'family'),getattr(c,'raddr'),status,processname)


## Apache2 access.log parser (requires root permissions)
log_path='/var/log/'
log_file='apache2/access.log'
regex = '([0-9a-f\.:]+) - (.+) \[(.+)\] "(.+)" ([0-9]+) ([0-9]+) .'
f = open(log_path+log_file, 'r')
for line in f:
	print(line,end='')
	log=re.match(regex, line).groups()
	client_addr, user, date, req, resp, size=log
	action, obj, httpver=req.split(' ')
	print('\t',client_addr, user, date, action, obj, httpver, resp, size)


# Apply iptables blocking rule to server/firewall
ip_address="100.0.0.1"
rule="iptables -I INPUT -s "+ip_address+" -p tcp -j REJECT --reject-with tcp-reset"
#os.system(rule)
