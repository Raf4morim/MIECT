source config
echo "Transfering data to the Bench node."
sshpass -f password ssh $bench_fname 'mkdir -p test/TheRopeGame'
sshpass -f password ssh $bench_fname 'rm -rf test/TheRopeGame/*'
sshpass -f password scp dirBench.zip $bench_fname:test/TheRopeGame
echo "Decompressing data sent to the Bench node."
sshpass -f password ssh $bench_fname 'cd test/TheRopeGame ; unzip -uq dirBench.zip'
sshpass -f password ssh $bench_fname 'cd test/TheRopeGame/dirBench'
sshpass -f password scp config $bench_fname:test/TheRopeGame/dirBench
echo "Executing program at the Bench node."
sshpass -f password ssh $bench_fname "cd test/TheRopeGame/dirBench ; ./bench_com_d.sh sd201"