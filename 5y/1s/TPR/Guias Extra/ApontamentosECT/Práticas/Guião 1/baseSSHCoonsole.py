import paramiko

def main():
	ssh = paramiko.SSHClient()
	ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	ssh.connect('10.0.1.1', username='labcom', password='labcom')
	ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('sh ip ro')
	
	for line in ssh_stdout:
		print(line)

if __name__ == "__main__":
	main()
