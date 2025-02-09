package serverSide.sharedRegion;

import clientSide.entities.*;
import clientSide.stubs.GeneralReposStub;
import genclass.GenericIO;
import serverSide.entities.BenchClientProxy;
import serverSide.main.*;

import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;

/**
 * Bench.
 * 
 * It is responsible for the synchronization of the coaches, contestants and
 * referee
 * during the calling process and it is implemented as an implicit monitor.
 * All public methods are executed in mutual exclusion.
 * There are four synchronization points: two blocking points for the referee,
 * where
 * he waits for all contestants to be seated before starting a new trial and
 * waits for
 * all contestants to seat down before ending the match;
 * one blocking point for the coaches, where they wait for the referee to call a
 * new trial;
 * and one blocking point for the contestants, where they wait for the coach to
 * select
 * them to play.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public class Bench {
    /**
     * Reference to coach threads.
     */

    private final BenchClientProxy[] coaches;

    /**
     * Reference to contestant threads.
     */

    private final BenchClientProxy[] contestants;

    /**
     * Reference to the general repository.
     */

    private final GeneralReposStub repos;

    /**
     * Boolean flag that indicates if the trial has been called.
     */

    private boolean callTrial;

    /**
     * Boolean flag that indicates match has ended.
     */

    private boolean matchEnded;

    /**
     * Integer flag that indicates if both coaches have called their contestants.
     * 
     * It is used to reset the callTrial flag.
     */

    private int bothCoachesCalled;

    /**
     * Number of players seated.
     */

    private int playersSeated;

    /**
     * Number of trials.
     */

    private int nTrials;

    /**
     * Boolean flag that indicates if the first trial has been called.
     */
    private boolean firstTrialCalled;

    /**
     * Boolean flag that indicates if the contestant is playing.
    */
    private boolean[] isPlayingLocal;

    /**
     * Team members for each coach.
     */

    private ArrayList<BenchClientProxy>[] teamMembers;

    /**
     * Strength queue
     * 
     * It is used to order the team members by strength.
     */

    private PriorityQueue<BenchClientProxy>[] strengthQueue;


    /**
     * Get the number of trials.
     * 
     * @return number of trials
     */

    public int getnTrials() {
        return nTrials;
    }

    /**
     * Get the number of players seated.
     * 
     * @return number of players seated
     */

    public int getPlayersSeated() {
        return playersSeated;
    }

    /**
     * Other entity needs to get a contestant.
     * Use this method to get a contestant.
     * Instead of using the getContestantId() method.
     * 
     * @param int id
     * @return contestant
     * 
     */
    private BenchClientProxy getContestant(int id) {

        BenchClientProxy contestant = null;
        for (BenchClientProxy c : contestants) {
            if (c != null && c.getContestantId() == id) {
                contestant = c;
                break;
            }
        }
        return contestant;
    }

    /**
     * Bench instantiation.
     * 
     * @param repos reference to the general repository
     */

    @SuppressWarnings("unchecked")
    public Bench(GeneralReposStub repos) {
        coaches = new BenchClientProxy[SimulPar.C];
        contestants = new BenchClientProxy[SimulPar.P];

        // Each coach has a team and a strength queue.
        teamMembers = new ArrayList[SimulPar.C];
        strengthQueue = new PriorityQueue[SimulPar.C];
        isPlayingLocal = new boolean[SimulPar.P];

        for (int i = 0; i < SimulPar.C; i++) {
            coaches[i] = null;
            teamMembers[i] = new ArrayList<BenchClientProxy>();
            strengthQueue[i] = new PriorityQueue<>();
        }
        for (int i = 0; i < SimulPar.P; i++) {
            contestants[i] = null;
            isPlayingLocal[i] = false;
        }

        this.repos = repos;

        callTrial = false;
        bothCoachesCalled = 0;
        playersSeated = 0;
        firstTrialCalled = false;
        matchEnded = false;
    }

    /**
     * Operation callTrial.
     * 
     * It is called by the referee to wake up the coaches to select the next team.
     */

    public synchronized void callTrial() {
        while (playersSeated < SimulPar.P) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        callTrial = true;
        firstTrialCalled = true;

        ((BenchClientProxy) Thread.currentThread()).setRefereeState(RefereeState.TEAMS_READY);
        repos.setRefereeState(RefereeState.TEAMS_READY);

        notifyAll(); // wake up the coaches to select their team
    }

    /**
     * Operation callContestants.
     * 
     * It is called by the coaches to select the next team and wake up the selected
     * contestants to play.
     * Increments the strength of the players that were not selected to play.
     * 
     */
    public synchronized void callContestants() {
        int coachId;
        coachId = ((BenchClientProxy) Thread.currentThread()).getCoachId();
        coaches[coachId] = (BenchClientProxy) Thread.currentThread();

        List<BenchClientProxy> teamMembers = new ArrayList<>();
        PriorityQueue<BenchClientProxy> strengthQueue = new PriorityQueue<>((c1, c2) -> c2.getStrength() - c1.getStrength());
        List<Integer> fullTeamMembersIDs = new ArrayList<>();

        if(coachId==0){
            for (int i = 0; i < 5; i++) {
                fullTeamMembersIDs.add(i);
            }
        }else{
            for (int i = 5; i < 10; i++) {
                fullTeamMembersIDs.add(i);
            }
        }
            
        int team_id = -1;
        for (int contestantId : fullTeamMembersIDs) {
            team_id = (Math.abs(contestantId) < 5) ? 0 : 1;
            BenchClientProxy contestant = getContestant(contestantId);
            if (contestant != null) {
                teamMembers.add(contestant);
                strengthQueue.add(contestant);
            }
        }


        while (!callTrial) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }

        List<BenchClientProxy> chosenTeam = getNextTeam(coachId, strengthQueue);

        
        if (!matchEnded) {
            coaches[coachId].setCoachState(CoachState.ASSEMBLE_TEAM);
            repos.setCoachState(coachId, coaches[coachId].getCoachState());
        }

        for (BenchClientProxy contestant : teamMembers) {

            if (chosenTeam.contains(contestant)) {
                contestants[contestant.getContestantId()].setIsPlaying(true);
                isPlayingLocal[contestant.getContestantId()] = true;
            }
                //GenericIO.writelnString("Chosen to play: "+ contestant.getContestantId());
                
            if (!isPlayingLocal[contestant.getContestantId()]) {
                incrementStrength(contestant);
                repos.setContestantStateAndStrength(contestant.getContestantId(), ContestantState.SEAT_AT_THE_BENCH, contestant.getStrength(), team_id);
            }
        }

        // for (BenchClientProxy contestant : teamMembers) { // players seated increment strength
        //     System.out.println("c: "+contestant.getContestantId()+" flag "+contestants[contestant.getContestantId()].getIsPlaying());
        //     if (!isPlayingLocal[contestant.getContestantId()]){ 
        //         incrementStrength(contestant);
        //         repos.setContestantStateAndStrength(contestant.getContestantId(), ContestantState.SEAT_AT_THE_BENCH, contestant.getStrength(), team_id);// contestant.getTeamId());
        //     }
        // }

        notifyAll(); // each coach wakes up his selected contestants

        bothCoachesCalled++;

        if (bothCoachesCalled == SimulPar.C) {
            bothCoachesCalled = 0;
            callTrial = false;
        }
    }

    /**
     * Operation followCoachAdvice.
     * 
     * It is called by a contestant to follow the coach advice and stand in
     * position.
     *
     */

    public synchronized void followCoachAdvice() {
        int contestantId;
        contestantId = ((BenchClientProxy) Thread.currentThread()).getContestantId();
        contestants[contestantId] = (BenchClientProxy) Thread.currentThread();
        
        // Define o ID da equipe com base no ID do concorrente
        int team_id = (Math.abs(contestantId) < 5) ? 0 : 1;
        playersSeated--;
        //GenericIO.writelnString("Contestant "+contestantId+" is following Coach advice");

        contestants[contestantId].setContestantState(ContestantState.STAND_IN_POSITION);
        repos.setContestantStateAndStrength(contestantId, ContestantState.STAND_IN_POSITION,
                contestants[contestantId].getStrength(), team_id);//contestants[contestantId].getTeamId());
    }

    /**
     * Operation seatDown.
     * 
     * It is called by a contestant to seat down and wait until he is selected by
     * the coach to play.
     * 
     */

    public synchronized void seatDown() {

        int contestantId;
        contestantId = ((BenchClientProxy) Thread.currentThread()).getContestantId();
        contestants[contestantId] = (BenchClientProxy) Thread.currentThread();
        
        
        if (firstTrialCalled && isPlayingLocal[contestantId]) { // Ignore first Seat at bench for decrementing strength and set state
            decrementStrength(contestants[contestantId], contestantId);
        }
        
        // Define o ID da equipe com base no ID do concorrente
        int team_id = (Math.abs(contestantId) < 5) ? 0 : 1;
        playersSeated++;
        // GenericIO.writelnString("Contestant " + contestantId + " seated, players seated: " + playersSeated);
        if (playersSeated == SimulPar.P) {
            notifyAll(); // Notify Referee that all contestants are seated, so he can call a new trial
        }
        
        
        
        repos.setContestantStateAndStrength(contestantId, ContestantState.SEAT_AT_THE_BENCH, contestants[contestantId].getStrength(), team_id);// contestants[contestantId].getTeamId());
        contestants[contestantId].setContestantState(ContestantState.SEAT_AT_THE_BENCH);
        
        contestants[contestantId].setIsPlaying(false);
        isPlayingLocal[contestantId] = false;
        
        
        // only the players that are selected by the coach will stand in position
        while (!contestants[contestantId].getIsPlaying()) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        //GenericIO.writelnString("Contestant " + contestantId + " is playing");
    }

    /**
     * Operation canEndTheGame.
     * 
     * It is called by the Referee to wait for all players to seat down and wake
     * both contestants and coaches to finish the match.
     * 
     * @param endOfMatch boolean flag that indicates if the match has ended
     */

    public synchronized void canEndTheGame(boolean endOfMatch) {

        while (playersSeated < SimulPar.P) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }

        if (endOfMatch) {
            // wake up contestants to finish the game
            List<Integer> fullTeamMembersIDs = new ArrayList<>();

            for (int j = 0; j < SimulPar.P; j++) {
                fullTeamMembersIDs.add(j);
            }

            for (int j : fullTeamMembersIDs) {
                contestants[j].setIsPlaying(true);
                isPlayingLocal[j] = true;
            }

            // wake up coaches to finish the game
            callTrial = true;
            matchEnded = true;
            notifyAll();
        }

        ((BenchClientProxy) Thread.currentThread()).setRefereeState(RefereeState.END_OF_A_GAME);
        repos.setRefereeState(RefereeState.END_OF_A_GAME);
    }

    /**
     * Create strength queue.
     * 
     * It creates a priority queue with the team members ordered by strength.
     * 
     * @see <a href=
     *      "https://docs.oracle.com/javase/8/docs/api/java/util/PriorityQueue.html">PriorityQueue</a>
     */

    public void createStrengthQueue(int teamId) {
        strengthQueue[teamId] = new PriorityQueue<>((c1, c2) -> c2.getStrength() - c1.getStrength());
        strengthQueue[teamId].addAll(teamMembers[teamId]);
    }

    /**
     * Get next team.
     * 
     * It gets the three strongest team members.
     * 
     * @return three strongest team members
     */

    public List<BenchClientProxy> getNextTeam(int teamId, PriorityQueue<BenchClientProxy> strengthQueue) {
        List<BenchClientProxy> selectTeamMembers = new ArrayList<>();
        while (!strengthQueue.isEmpty() && selectTeamMembers.size() < SimulPar.P_T / 2) {
            selectTeamMembers.add(strengthQueue.poll());
        }

        return selectTeamMembers;
    }

    /**
     * Increment strength.
     * 
     * It increments the strength of the contestant by one unit.
     * The maximum strength value is 10.
     */

    public void incrementStrength(BenchClientProxy contestant) {
        contestant.setStrength(contestant.getStrength() + 1);
        if (contestant.getStrength() > 10)
            contestant.setStrength(10);
    }

    /**
     * Decrement strength.
     * 
     * It decrements the strength of the contestant by one unit.
     * The minimum strength value is 6.
     */

    public void decrementStrength(BenchClientProxy contestants2, int contestantId) {
        if (contestants2.getStrength() < 6)
            contestants2.setStrength(6);
        else
            contestants2.setStrength(contestants2.getStrength() - 1);
    }

    /**
     *   Operation server shutdown.
     *
     *   New operation.
     */

    public synchronized void shutdown() {
        ServerBench.waitConnection = false;
        notifyAll();
    }
}