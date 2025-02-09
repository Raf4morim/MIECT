source config
echo "Transfering data to the general repository node."
sshpass -f password ssh $generalRepos_fname 'mkdir -p test/TheRopeGame'
sshpass -f password ssh $generalRepos_fname 'rm -rf test/TheRopeGame/*'
sshpass -f password scp dirGeneralRepos.zip $generalRepos_fname:test/TheRopeGame
echo "Decompressing data sent to the general repository node."
sshpass -f password ssh $generalRepos_fname 'cd test/TheRopeGame ; unzip -uq dirGeneralRepos.zip'
#sshpass -f password scp genclass.zip $generalRepos_fname:test/TheRopeGame/dirGeneralRepos
sshpass -f password ssh $generalRepos_fname 'cd test/TheRopeGame/dirGeneralRepos ; ' #unzip -uq genclass.zip'
echo "Executing program at the server general repository."
sshpass -f password ssh $generalRepos_fname "cd test/TheRopeGame/dirGeneralRepos ; java serverSide.main.ServerGeneralRepos $generalRepos_port"
echo "Server shutdown."
sshpass -f password ssh $generalRepos_fname 'cd test/TheRopeGame/dirGeneralRepos ; less logger'