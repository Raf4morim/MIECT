source config
echo "Transfering data to the registry node."
sshpass -f password ssh $rmi_fname 'mkdir -p test/TheRopeGame'
sshpass -f password scp dirRegistry.zip $rmi_fname:test/TheRopeGame
echo "Decompressing data sent to the registry node."
sshpass -f password ssh $rmi_fname 'cd test/TheRopeGame ; unzip -uq dirRegistry.zip'
sshpass -f password scp config $rmi_fname:test/TheRopeGame/dirRegistry/config
echo "Executing program at the registry node."
sshpass -f password ssh $rmi_fname 'cd test/TheRopeGame/dirRegistry ; ./registry_com_d.sh sd201'
