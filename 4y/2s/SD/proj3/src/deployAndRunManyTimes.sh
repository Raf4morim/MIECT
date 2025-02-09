for i in $(seq 1 100)
do 
    xterm  -T "General Repository" -hold -e "./GeneralReposDeployAndRun.sh" &
    pid1=$!  # Armazena o PID do último processo em background
    sleep 1

    xterm  -T "RefereeSite" -hold -e "./RefereeSiteDeployAndRun.sh" &
    pid2=$!
    sleep 1

    xterm  -T "Playground" -hold -e "./PlayGroundDeployAndRun.sh" &
    pid3=$!
    sleep 1

    xterm  -T "Bench" -hold -e "./BenchDeployAndRun.sh" &
    pid4=$!

    sleep 5

    xterm  -T "Contestant" -hold -e "./ContestantDeployAndRun.sh" &
    pid5=$!
    sleep 1

    xterm  -T "Coach" -hold -e "./CoachDeployAndRun.sh" &
    pid6=$!
    sleep 1

    xterm  -T "Referee" -hold -e "./RefereeDeployAndRun.sh" &
    pid7=$!

    sleep 60

    kill $pid1 $pid2 $pid3 $pid4 $pid5 $pid6 $pid7
done
