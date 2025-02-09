source config
echo "Transfering data to the PlayGround node."
sshpass -f password ssh $playground_fname 'mkdir -p test/TheRopeGame'
sshpass -f password ssh $playground_fname 'rm -rf test/TheRopeGame/*'
sshpass -f password scp dirPlayGround.zip $playground_fname:test/TheRopeGame
echo "Decompressing data sent to the PlayGround node."
sshpass -f password ssh $playground_fname 'cd test/TheRopeGame ; unzip -uq dirPlayGround.zip'
echo "Executing program at the PlayGround node."
sshpass -f password ssh $playground_fname "cd test/TheRopeGame/dirPlayGround ; java serverSide.main.ServerPlayGround $playground_port $generalRepos $generalRepos_port"