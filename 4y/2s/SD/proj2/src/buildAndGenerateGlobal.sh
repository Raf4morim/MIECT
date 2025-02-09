javac -cp ".:./genclass.jar" */*.java */*/*.java
echo "Distributing intermediate code to the different execution environments."
echo "  General Repository of Information"

rm -rf dirGeneralRepos
mkdir -p dirGeneralRepos/serverSide dirGeneralRepos/serverSide/main dirGeneralRepos/serverSide/entities dirGeneralRepos/serverSide/sharedRegion \
         dirGeneralRepos/clientSide dirGeneralRepos/clientSide/entities dirGeneralRepos/commInfra
cp serverSide/main/SimulPar.class serverSide/main/ServerGeneralRepos.class dirGeneralRepos/serverSide/main
cp serverSide/entities/GeneralReposClientProxy.class dirGeneralRepos/serverSide/entities
cp serverSide/sharedRegion/GeneralReposInterface.class serverSide/sharedRegion/GeneralRepos.class dirGeneralRepos/serverSide/sharedRegion
cp clientSide/entities/ContestantState.class clientSide/entities/RefereeState.class clientSide/entities/CoachState.class dirGeneralRepos/clientSide/entities
cp commInfra/Message.class commInfra/MessageType.class commInfra/MessageException.class commInfra/ServerCom.class dirGeneralRepos/commInfra

echo "  Bench"
rm -rf dirBench
mkdir -p dirBench/serverSide dirBench/serverSide/main dirBench/serverSide/entities dirBench/serverSide/sharedRegion \
         dirBench/clientSide dirBench/clientSide/entities dirBench/clientSide/stubs dirBench/commInfra
cp serverSide/main/SimulPar.class serverSide/main/ServerBench.class dirBench/serverSide/main
cp serverSide/entities/BenchClientProxy.class dirBench/serverSide/entities
cp serverSide/sharedRegion/GeneralReposInterface.class serverSide/sharedRegion/BenchInterface.class serverSide/sharedRegion/Bench.class dirBench/serverSide/sharedRegion
cp clientSide/entities/ContestantState.class clientSide/entities/Contestant.class clientSide/entities/RefereeState.class clientSide/entities/CoachState.class clientSide/entities/ContestantCloning.class clientSide/entities/RefereeCloning.class clientSide/entities/CoachCloning.class \
   dirBench/clientSide/entities
cp clientSide/stubs/GeneralReposStub.class clientSide/stubs/BenchStub.class clientSide/stubs/RefereeSiteStub.class clientSide/stubs/PlayGroundStub.class dirBench/clientSide/stubs
cp commInfra/*.class dirBench/commInfra


echo "  PlayGround"
rm -rf dirPlayGround
mkdir -p dirPlayGround/serverSide dirPlayGround/serverSide/main dirPlayGround/serverSide/entities dirPlayGround/serverSide/sharedRegion \
         dirPlayGround/clientSide dirPlayGround/clientSide/entities dirPlayGround/clientSide/stubs dirPlayGround/commInfra
cp serverSide/main/SimulPar.class serverSide/main/ServerPlayGround.class dirPlayGround/serverSide/main
cp serverSide/entities/PlayGroundClientProxy.class dirPlayGround/serverSide/entities
cp serverSide/sharedRegion/GeneralReposInterface.class serverSide/sharedRegion/PlayGroundInterface.class serverSide/sharedRegion/PlayGround.class dirPlayGround/serverSide/sharedRegion
cp clientSide/entities/ContestantState.class clientSide/entities/RefereeState.class clientSide/entities/Coach.class clientSide/entities/CoachState.class clientSide/entities/ContestantCloning.class clientSide/entities/RefereeCloning.class clientSide/entities/CoachCloning.class \
   dirPlayGround/clientSide/entities
cp clientSide/stubs/GeneralReposStub.class clientSide/stubs/BenchStub.class clientSide/stubs/RefereeSiteStub.class clientSide/stubs/PlayGroundStub.class dirPlayGround/clientSide/stubs
cp commInfra/*.class dirPlayGround/commInfra

echo "  RefereeSite"
rm -rf dirRefereeSite
mkdir -p dirRefereeSite/serverSide dirRefereeSite/serverSide/main dirRefereeSite/serverSide/entities dirRefereeSite/serverSide/sharedRegion \
         dirRefereeSite/clientSide dirRefereeSite/clientSide/entities dirRefereeSite/clientSide/stubs dirRefereeSite/commInfra
cp serverSide/main/SimulPar.class serverSide/main/ServerRefereeSite.class dirRefereeSite/serverSide/main
cp serverSide/entities/RefereeSiteClientProxy.class dirRefereeSite/serverSide/entities
cp serverSide/sharedRegion/GeneralReposInterface.class serverSide/sharedRegion/RefereeSiteInterface.class serverSide/sharedRegion/RefereeSite.class dirRefereeSite/serverSide/sharedRegion
cp clientSide/entities/ContestantState.class clientSide/entities/RefereeState.class clientSide/entities/Coach.class clientSide/entities/CoachState.class clientSide/entities/ContestantCloning.class clientSide/entities/RefereeCloning.class clientSide/entities/CoachCloning.class \
   dirRefereeSite/clientSide/entities
cp clientSide/stubs/GeneralReposStub.class clientSide/stubs/BenchStub.class clientSide/stubs/RefereeSiteStub.class clientSide/stubs/PlayGroundStub.class dirRefereeSite/clientSide/stubs
cp commInfra/*.class dirRefereeSite/commInfra

echo "  Contestants"
rm -rf dirContestant
mkdir -p dirContestant/serverSide/main dirContestant/clientSide/main dirContestant/clientSide/entities \
         dirContestant/clientSide/stubs dirContestant/commInfra
cp serverSide/main/SimulPar.class dirContestant/serverSide/main
cp clientSide/main/ClientTheRopeGameContestant.class dirContestant/clientSide/main
cp clientSide/entities/Contestant.class clientSide/entities/ContestantState.class clientSide/entities/Coach.class clientSide/entities/Referee.class  dirContestant/clientSide/entities
cp clientSide/stubs/GeneralReposStub.class clientSide/stubs/BenchStub.class clientSide/stubs/RefereeSiteStub.class clientSide/stubs/PlayGroundStub.class dirContestant/clientSide/stubs
cp commInfra/Message.class commInfra/MessageType.class commInfra/MessageException.class commInfra/ClientCom.class dirContestant/commInfra

echo "  Referee"
rm -rf dirReferee
mkdir -p dirReferee/serverSide/main dirReferee/clientSide/main dirReferee/clientSide/entities \
         dirReferee/clientSide/stubs dirReferee/commInfra
cp serverSide/main/SimulPar.class dirReferee/serverSide/main
cp clientSide/main/ClientTheRopeGameReferee.class dirReferee/clientSide/main
cp clientSide/entities/Referee.class clientSide/entities/RefereeState.class  clientSide/entities/Coach.class clientSide/entities/Contestant.class dirReferee/clientSide/entities
cp clientSide/stubs/GeneralReposStub.class clientSide/stubs/BenchStub.class clientSide/stubs/RefereeSiteStub.class clientSide/stubs/PlayGroundStub.class dirReferee/clientSide/stubs
cp commInfra/Message.class commInfra/MessageType.class commInfra/MessageException.class commInfra/ClientCom.class dirReferee/commInfra

echo "  Coach"
rm -rf dirCoach
mkdir -p dirCoach/serverSide/main dirCoach/clientSide/main dirCoach/clientSide/entities \
         dirCoach/clientSide/stubs dirCoach/commInfra
cp serverSide/main/SimulPar.class dirCoach/serverSide/main
cp clientSide/main/ClientTheRopeGameCoach.class dirCoach/clientSide/main
cp clientSide/entities/Coach.class clientSide/entities/CoachState.class clientSide/entities/Referee.class clientSide/entities/Contestant.class dirCoach/clientSide/entities
cp clientSide/stubs/GeneralReposStub.class clientSide/stubs/BenchStub.class clientSide/stubs/RefereeSiteStub.class clientSide/stubs/PlayGroundStub.class dirCoach/clientSide/stubs
cp commInfra/Message.class commInfra/MessageType.class commInfra/MessageException.class commInfra/ClientCom.class dirCoach/commInfra

echo "Compressing execution environments."

echo "  General Repository of Information"
rm -f  dirGeneralRepos.zip
zip -rq dirGeneralRepos.zip dirGeneralRepos
echo "  Bench"
rm -f  dirBench.zip
zip -rq dirBench.zip dirBench
echo "  PlayGround"
rm -f  dirPlayGround.zip
zip -rq dirPlayGround.zip dirPlayGround
echo "  RefereeSite"
rm -f  dirRefereeSite.zip
zip -rq dirRefereeSite.zip dirRefereeSite
echo "  Contestant"
rm -f  dirContestant.zip
zip -rq dirContestant.zip dirContestant
echo "  Referee"
rm -f  dirReferee.zip
zip -rq dirReferee.zip dirReferee
echo "  Coach"
rm -f  dirCoach.zip
zip -rq dirCoach.zip dirCoach