source config
echo "Transfering data to the Coach node."
sshpass -f password ssh $coach 'mkdir -p test/ClientTheRopeGameCoach'
sshpass -f password ssh $coach 'rm -rf test/ClientTheRopeGameCoach/*'
sshpass -f password scp dirCoach.zip $coach:test/ClientTheRopeGameCoach
echo "Decompressing data sent to the Coach node."
sshpass -f password ssh $coach 'cd test/ClientTheRopeGameCoach ; unzip -uq dirCoach.zip'
echo "Executing program at the Coach node."
sshpass -f password ssh $coach "cd test/ClientTheRopeGameCoach/dirCoach ; java clientSide.main.ClientTheRopeGameCoach $bench $bench_port $playground $playground_port $refereeSite $refereeSite_port $generalRepos $generalRepos_port"