source config
echo "Transfering data to the Coach node."
sshpass -f password ssh $coach 'mkdir -p test/ClientTheRopeGameCoach'
sshpass -f password ssh $coach 'rm -rf test/ClientTheRopeGameCoach/*'
sshpass -f password scp dirCoach.zip $coach:test/ClientTheRopeGameCoach
echo "Decompressing data sent to the Coach node."
sshpass -f password ssh $coach 'cd test/ClientTheRopeGameCoach ; unzip -uq dirCoach.zip'
sshpass -f password ssh $coach 'cd test/ClientTheRopeGameCoach/dirCoach'
sshpass -f password scp config $coach:test/ClientTheRopeGameCoach/dirCoach
echo "Executing program at the Coach node."
sshpass -f password ssh $coach "cd test/ClientTheRopeGameCoach/dirCoach ; ./coach_com_d.sh"