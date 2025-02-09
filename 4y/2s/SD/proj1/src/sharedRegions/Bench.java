package sharedRegions;

import main.*;
import entities.*;

import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Iterator;

/**
 * Bench.
 * 
 * It is responsible for the synchronization of the coaches, contestants and referee
 * during the calling process and it is implemented as an implicit monitor.
 * All public methods are executed in mutual exclusion.
 * There are four synchronization points: two blocking points for the referee, where
 * he waits for all contestants to be seated before starting a new trial and waits for
 * all contestants to seat down before ending the match; 
 * one blocking point for the coaches, where they wait for the referee to call a new trial;
 * and one blocking point for the contestants, where they wait for the coach to select 
 * them to play.
 */

public class Bench {
    /**
     * Reference to coach threads.
     */

    private final Coach[] coaches;

    /**
     * Reference to contestant threads.
     */

    private final Contestant[] contestants;

    /**
     * Reference to the general repository.
     */

    private final GeneralRepos repos;

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
     * Team members.
     */

    private List<Contestant>[] teamMembers;

    /**
     * Strength queue.
     * 
     * It is used to order the team members by strength.
     */

    private PriorityQueue<Contestant>[] strengthQueue;
    

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
    public Contestant getContestant(int id) {

        Contestant contestant = null;
        for (Contestant c : contestants) {
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
    public Bench(GeneralRepos repos) {
        coaches = new Coach[SimulPar.C];
        contestants = new Contestant[SimulPar.P];

        // Each coach has a team and a strength queue.
        teamMembers = new ArrayList[SimulPar.C];
        strengthQueue = new PriorityQueue[SimulPar.C];
        
        for (int i = 0; i < SimulPar.C; i++) {
            coaches[i] = null;
            teamMembers[i] = new ArrayList<Contestant>();
            strengthQueue[i] = new PriorityQueue<>();
        }
        for (int i = 0; i < SimulPar.P; i++) {
            contestants[i] = null;
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

        ((Referee) Thread.currentThread()).setRefereeState(RefereeState.TEAMS_READY);
        repos.setRefereeState(RefereeState.TEAMS_READY);

        notifyAll(); // wake up the coaches to select their team
    }
    
    /**
     * Operation callContestants.
     * 
     * It is called by the coaches to select the next team and wake up the selected contestants to play.
     * Increments the strength of the players that were not selected to play.
     * 
     */
    public synchronized void callContestants() {
        int coachId;
        coachId = ((Coach) Thread.currentThread()).getCoachId();
        coaches[coachId] = (Coach) Thread.currentThread();

        while (!callTrial) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }

        List<Integer> fullTeamMembers = coaches[coachId].fullTeam();

        teamMembers[coachId].clear();
        strengthQueue[coachId].clear();

        // System.out.println("Full Team Members " + coachId + ": " + fullTeamMembers);
        for(int i: fullTeamMembers){
            Contestant contestant = getContestant(i);
            if (contestant.getTeamId() == coachId) {

                teamMembers[coachId].add(contestant);
            }
        }

        createStrengthQueue(coachId);
        printContestantStrengths();

        List<Contestant> chosenTeam = getNextTeam(coachId);

        if (!matchEnded){ 
            coaches[coachId].setCoachState(CoachState.ASSEMBLE_TEAM);
            repos.setCoachState(coachId, coaches[coachId].getCoachState());
        }

        for (Contestant contestant : chosenTeam) {
            contestant.setIsPlaying(true);
        }
        
        System.out.println("Call Contestant chosenteam " + coachId + ": " + chosenTeam);
        for (Contestant contestant : teamMembers[coachId]) { // players seated increment strength
            if (contestant.getIsPlaying()==false) {
              incrementStrength(contestant, contestant.getContestantId());
              repos.setContestantStateAndStrength(contestant.getContestantId(), contestant.getContestantState(),contestant.getStrength(),contestant.getTeamId());
            }
        }

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
     * It is called by a contestant to follow the coach advice and stand in position.
     *
     */

    public synchronized void followCoachAdvice() {
        int contestantId;
        contestantId = ((Contestant) Thread.currentThread()).getContestantId();
        contestants[contestantId] = (Contestant) Thread.currentThread();

        playersSeated--;

        contestants[contestantId].setContestantState(ContestantState.STAND_IN_POSITION);
        repos.setContestantStateAndStrength(contestantId, ContestantState.STAND_IN_POSITION,contestants[contestantId].getStrength(), contestants[contestantId].getTeamId());
    }

    /**
     * Operation seatDown.
     * 
     * It is called by a contestant to seat down and wait until he is selected by the coach to play.
     * 
     */

    public synchronized void seatDown() {

        int contestantId;
        contestantId = ((Contestant) Thread.currentThread()).getContestantId();
        contestants[contestantId] = (Contestant) Thread.currentThread();

        playersSeated++;
        if (playersSeated == SimulPar.P) {
            notifyAll(); // Notify Referee that all contestants are seated, so he can call a new trial
        }

        if (firstTrialCalled) { // Ignore first Seat at bench for decrementing strength and set state
            decrementStrength(contestants[contestantId], contestantId);

            contestants[contestantId].setContestantState(ContestantState.SEAT_AT_THE_BENCH);
            repos.setContestantStateAndStrength(contestantId, contestants[contestantId].getContestantState(),contestants[contestantId].getStrength(), contestants[contestantId].getTeamId());
        }

        contestants[contestantId].setIsPlaying(false);

        // only the players that are selected by the coach will stand in position
        while (!contestants[contestantId].getIsPlaying()) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
    }

    /**
     * Operation canEndTheGame.
     * 
     * It is called by the Referee to wait for all players to seat down and wake both contestants and coaches to finish the match.
     * 
     * @param endOfMatch boolean flag that indicates if the match has ended
     */

    public synchronized void canEndTheGame(boolean endOfMatch) {
        
        while (playersSeated < SimulPar.P ) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }

        if (endOfMatch) {
            // wake up contestants to finish the game
            List<Contestant> fullTeam = null;// new ArrayList<>();
            for (int i = 0; i < SimulPar.C; i++) {
                List<Integer> fullTeamIds = coaches[i].fullTeam();

                // System.out.println("CAN END GAME: Full Team Ids: " + fullTeamIds);
                
                for (int j: fullTeamIds) {
                    Contestant contestant = getContestant(j);
                    if (contestant.getTeamId() == i) {
                        if (fullTeam == null) {
                            fullTeam = new ArrayList<>();
                        }
                        fullTeam.add(contestant);
                    }
                }
                // System.out.println("CAN END GAME: Full Team Contestant type: " + fullTeam);

                for (Contestant contestant : fullTeam) {
                    contestant.setIsPlaying(true);
                }
            }
            // wake up coaches to finish the game
            callTrial = true;
            matchEnded = true;
            notifyAll();    
        }

        ((Referee) Thread.currentThread()).setRefereeState(RefereeState.END_OF_A_GAME);
        repos.setRefereeState(RefereeState.END_OF_A_GAME);
    }

    /**
     * Create strength queue.
     * 
     * It creates a priority queue with the team members ordered by strength.
     * 
     * @see <a href="https://docs.oracle.com/javase/8/docs/api/java/util/PriorityQueue.html">PriorityQueue</a>
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

    public List<Contestant> getNextTeam(int teamId) {
        List<Contestant> selectTeamMembers = new ArrayList<>();
        PriorityQueue<Contestant> sortedQueue = new PriorityQueue<>(strengthQueue[teamId]); // Criando uma cópia ordenada da fila de prioridade
    
        while (!sortedQueue.isEmpty() && selectTeamMembers.size() < SimulPar.P_T/2) {
            Contestant contestant = sortedQueue.poll(); // Remove e retorna o próximo jogador mais forte
            selectTeamMembers.add(contestant);
        }
    
        return selectTeamMembers;
    }
    

    /**
     * Increment strength.
     * 
     * It increments the strength of the contestant by one unit.
     * The maximum strength value is 10.
     */

    public void incrementStrength(Contestant contestant , int contestantId) {
         contestant.setStrength(contestant.getStrength() + 1);
         if (contestant.getStrength() > 10)
             contestant.setStrength(10);
        // strength++;
        // if (strength > 10)
        //     strength = 10;
    }

    /**
     * Decrement strength.
     * 
     * It decrements the strength of the contestant by one unit.
     * The minimum strength value is 6.
     */

    public void decrementStrength(Contestant contestant, int contestantId) {
        contestant.setStrength(contestant.getStrength() - 1);
        if (contestant.getStrength() < 6)
            contestant.setStrength(6);
        // strength--;
        // if (strength < 6)
        //     strength = 6;
    }

    /**
     * Print strength of each contestant and who has it.
     */
    public void printContestantStrengths() {
        System.out.println("Contestant Strengths:");
        for (Contestant c : contestants) {
            System.out.println("Contestant " + c.getContestantId() + " - Strength: " + c.getStrength() + ", Team: " + c.getTeamId());
        }
    }
}