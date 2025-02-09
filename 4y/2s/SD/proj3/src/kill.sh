source config

echo "Killing stations."
sshpass -f password ssh $bench_fname 'killall -9 -u sd201 java'
sshpass -f password ssh $playground_fname 'killall -9 -u sd201 java'
sshpass -f password ssh $refereeSite_fname 'killall -9 -u sd201 java'
sshpass -f password ssh $generalRepos_fname 'killall -9 -u sd201 java'
sshpass -f password ssh $rmi_fname 'killall -9 -u sd201 java'
sshpass -f password ssh $coach 'killall -9 -u sd201 java'
sshpass -f password ssh $referee 'killall -9 -u sd201 java'
sshpass -f password ssh $contestant 'killall -9 -u sd201 java'

echo "Forcing to kill process even the ports."
# Novas linhas adicionadas com obtenção automática do PID
sshpass -f password ssh $rmi_fname 'lsof -i :22209 | awk '\''NR>1 {print $2}'\'' | xargs -r kill -9'
sshpass -f password ssh $generalRepos_fname 'lsof -i :22202 | awk '\''NR>1 {print $2}'\'' | xargs -r kill -9'
sshpass -f password ssh $refereeSite_fname 'lsof -i :22203 | awk '\''NR>1 {print $2}'\'' | xargs -r kill -9'
sshpass -f password ssh $playground_fname 'lsof -i :22207 | awk '\''NR>1 {print $2}'\'' | xargs -r kill -9'
sshpass -f password ssh $bench_fname 'lsof -i :22200 | awk '\''NR>1 {print $2}'\'' | xargs -r kill -9'