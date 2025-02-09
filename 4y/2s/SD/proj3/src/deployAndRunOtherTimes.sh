gnome-terminal -- bash -c "source config && ./GeneralReposDeployAndRun.sh; exec bash" --title="General Repository" &
sleep 4
gnome-terminal -- bash -c "source config && ./BenchDeployAndRun.sh; exec bash" --title="Bench" &
sleep 4
gnome-terminal -- bash -c "source config && ./PlayGroundDeployAndRun.sh; exec bash" --title="PlayGround" &
sleep 4
gnome-terminal -- bash -c "source config && ./RefereeSiteDeployAndRun.sh; exec bash" --title="RefereeSite" &
sleep 4
gnome-terminal -- bash -c "source config && ./RefereeDeployAndRun.sh; exec bash" --title="Referee" &
sleep 4
gnome-terminal -- bash -c "source config && ./CoachDeployAndRun.sh; exec bash" --title="Coach" &
sleep 4
gnome-terminal -- bash -c "source config && ./ContestantDeployAndRun.sh; exec bash" --title="Contestant" &