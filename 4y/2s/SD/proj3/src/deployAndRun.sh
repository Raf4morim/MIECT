source config

gnome-terminal -- bash -c "source config; ./GeneralReposDeployAndRun.sh; exec bash" --title="General Repository" &
gnome-terminal -- bash -c "source config; ./RefereeSiteDeployAndRun.sh; exec bash" --title="Referee Site" &
gnome-terminal -- bash -c "source config; ./BenchDeployAndRun.sh; exec bash" --title="Bench" &
gnome-terminal -- bash -c "source config; ./PlayGroundDeployAndRun.sh; exec bash" --title="PlayGround" &
sleep 5
gnome-terminal -- bash -c "source config; ./ContestantDeployAndRun.sh; exec bash" --title="Contestant" &
sleep 5
gnome-terminal -- bash -c "source config; ./CoachDeployAndRun.sh; exec bash" --title="Coach" &
sleep 5
gnome-terminal -- bash -c "source config; ./RefereeDeployAndRun.sh; exec bash" --title="Referee" &
