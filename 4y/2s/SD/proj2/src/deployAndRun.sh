source config

xterm  -T "General Repository" -hold -e "source config & ./GeneralReposDeployAndRun.sh" &
xterm  -T "Referee Site" -hold -e "source config & ./RefereeSiteDeployAndRun.sh" &
xterm  -T "Bench" -hold -e "source config & ./BenchDeployAndRun.sh" &
xterm  -T "PlayGround" -hold -e "source config & ./PlayGroundDeployAndRun.sh" &
sleep 10
xterm  -T "Contestant" -hold -e "source config & ./ContestantDeployAndRun.sh" &
sleep 10
xterm  -T "Coach" -hold -e "source config & ./CoachDeployAndRun.sh" &
sleep 10
xterm  -T "Referee" -hold -e "source config & ./RefereeDeployAndRun.sh" &