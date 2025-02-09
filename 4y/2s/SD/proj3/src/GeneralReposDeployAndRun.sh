source config
echo "Transfering data to the general repository node."
sshpass -f password ssh $generalRepos_fname 'mkdir -p test/TheRopeGame'
sshpass -f password ssh $generalRepos_fname 'rm -rf test/TheRopeGame/*'
sshpass -f password scp dirGeneralRepos.zip $generalRepos_fname:test/TheRopeGame
echo "Decompressing data sent to the general repository node."
sshpass -f password ssh $generalRepos_fname 'cd test/TheRopeGame ; unzip -uq dirGeneralRepos.zip'
sshpass -f password scp genclass.zip $generalRepos_fname:test/TheRopeGame/dirGeneralRepos
sshpass -f password ssh $generalRepos_fname 'cd test/TheRopeGame/dirGeneralRepos'
sshpass -f password scp config $generalRepos_fname:test/TheRopeGame/dirGeneralRepos
echo "Executing program at the server general repository."
sshpass -f password ssh $generalRepos_fname "cd test/TheRopeGame/dirGeneralRepos ; ./repos_com_d.sh sd201"
echo "Server shutdown."
sshpass -f password ssh $generalRepos_fname 'cd test/TheRopeGame/dirGeneralRepos ; less logger'