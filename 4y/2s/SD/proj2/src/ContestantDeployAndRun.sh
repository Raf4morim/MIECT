source config
echo "Transfering data to the Contestant node."
sshpass -f password ssh $contestant 'mkdir -p test/ClientTheRopeGameContestant'
sshpass -f password ssh $contestant 'rm -rf test/ClientTheRopeGameContestant/*'
sshpass -f password scp dirContestant.zip $contestant:test/ClientTheRopeGameContestant
echo "Decompressing data sent to the Contestant node."
sshpass -f password ssh $contestant 'cd test/ClientTheRopeGameContestant ; unzip -uq dirContestant.zip'
echo "Executing program at the Contestant node."
sshpass -f password ssh $contestant "cd test/ClientTheRopeGameContestant/dirContestant ; java clientSide.main.ClientTheRopeGameContestant $bench $bench_port $playground $playground_port $refereeSite $refereeSite_port $generalRepos $generalRepos_port"