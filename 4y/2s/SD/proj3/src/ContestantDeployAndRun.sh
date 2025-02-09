source config
echo "Transfering data to the Contestant node."
sshpass -f password ssh $contestant 'mkdir -p test/ClientTheRopeGameContestant'
sshpass -f password ssh $contestant 'rm -rf test/ClientTheRopeGameContestant/*'
sshpass -f password scp dirContestant.zip $contestant:test/ClientTheRopeGameContestant
echo "Decompressing data sent to the Contestant node."
sshpass -f password ssh $contestant 'cd test/ClientTheRopeGameContestant ; unzip -uq dirContestant.zip'
sshpass -f password ssh $contestant 'cd test/ClientTheRopeGameContestant/dirContestant'
sshpass -f password scp config $contestant:test/ClientTheRopeGameContestant/dirContestant
echo "Executing program at the Contestant node."
sshpass -f password ssh $contestant "cd test/ClientTheRopeGameContestant/dirContestant ; ./contestant_com_d.sh"