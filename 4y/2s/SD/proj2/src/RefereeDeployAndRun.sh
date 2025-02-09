source config
echo "Transfering data to the Referee node."
sshpass -f password ssh $referee 'mkdir -p test/ClientTheRopeGameReferee'
sshpass -f password ssh $referee 'rm -rf test/ClientTheRopeGameReferee/*'
sshpass -f password scp dirReferee.zip $referee:test/ClientTheRopeGameReferee
echo "Decompressing data sent to the Referee node."
sshpass -f password ssh $referee 'cd test/ClientTheRopeGameReferee ; unzip -uq dirReferee.zip'
echo "Executing program at the Referee node."
sshpass -f password ssh $referee "cd test/ClientTheRopeGameReferee/dirReferee ; java clientSide.main.ClientTheRopeGameReferee $bench $bench_port $playground $playground_port $refereeSite $refereeSite_port $generalRepos $generalRepos_port"