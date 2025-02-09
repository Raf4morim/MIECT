source config
echo "Transfering data to the RefereeSite node."
sshpass -f password ssh $refereeSite_fname 'mkdir -p test/TheRopeGame'
sshpass -f password ssh $refereeSite_fname 'rm -rf test/TheRopeGame/*'
sshpass -f password scp dirRefereeSite.zip $refereeSite_fname:test/TheRopeGame
echo "Decompressing data sent to the RefereeSite node."
sshpass -f password ssh $refereeSite_fname 'cd test/TheRopeGame ; unzip -uq dirRefereeSite.zip'
echo "Executing program at the RefereeSite node."
sshpass -f password ssh $refereeSite_fname "cd test/TheRopeGame/dirRefereeSite ; java serverSide.main.ServerRefereeSite $refereeSite_port $generalRepos $generalRepos_port"