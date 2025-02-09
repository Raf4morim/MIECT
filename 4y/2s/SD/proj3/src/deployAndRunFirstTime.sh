source config
gnome-terminal -- bash -c "source config && ./RMIRegistryDeployAndRun.sh; exec bash" --title="RMI registry" &
sleep 10
gnome-terminal -- bash -c "source config && ./RegistryDeployAndRun.sh; exec bash" --title="Registry" &
sleep 4
gnome-terminal -- bash -c "source config && ./GeneralReposDeployAndRun.sh; exec bash" --title="General Repository" &
sleep 2
gnome-terminal -- bash -c "source config && ./PlayGroundDeployAndRun.sh; exec bash" --title="PlayGround" &
sleep 2
gnome-terminal -- bash -c "source config && ./RefereeSiteDeployAndRun.sh; exec bash" --title="RefereeSite" &
sleep 2
gnome-terminal -- bash -c "source config && ./BenchDeployAndRun.sh; exec bash" --title="Bench" &
sleep 5
gnome-terminal -- bash -c "source config && ./ContestantDeployAndRun.sh; exec bash" --title="Contestant" &
gnome-terminal -- bash -c "source config && ./CoachDeployAndRun.sh; exec bash" --title="Coach" &
gnome-terminal -- bash -c "source config && ./RefereeDeployAndRun.sh; exec bash" --title="Referee" &
