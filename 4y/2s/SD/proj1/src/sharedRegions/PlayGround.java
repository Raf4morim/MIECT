package sharedRegions;

import main.*;
import entities.*;

import java.util.*;

/**
 * PlayGround.
 *
 * It is responsible for the synchronization of the coaches, contestants and referee
 * during the trial and it is implemented as an implicit monitor.
 * All public methods are executed in mutual exclusion.
 * There are six synchronization points: two blocking points for the referee, where
 * he waits for the last coach to inform him that the teams are ready before starting a new trial and
 * waits for the trial to end (all players have pulled the rope); two blocking points for the coaches, 
 * where they wait for all the players to be ready and wait for the referee to assert the trial decision;
 * and two blocking points for the contestants, where they wait for the referee to start the trial and
 * wait for the referee to assert the trial decision.
 */

public class PlayGround {

    /**
     * Reference to the general repository.
     */

    private final GeneralRepos repos;

    /**
     * Reference to coach threads.
     */

    private final Coach[] coaches;

    /**
     * Reference to customer threads.
     */

    private final Contestant[] contestants;

    /**
     * Boolean flag to signal that all players have pulled the rope.
     */

    private boolean allPlayersPulled;

    /**
     * Boolean flag to signal that all players are ready to play.
     */

    private boolean allPlayersReady;

    /**
     * Boolean flag to signal that the referee has been informed.
     */

    private boolean refereeInformed;

    /**
     * Boolean flag to signal that the trial decision has been asserted by the referee.
     */

    private boolean assertTrialDecisionContestants;

    /**
     * Boolean flag to signal that the trial decision has been asserted by the referee.
     */

    private boolean assertTrialDecisionCoaches;

    /**
     * Boolean flag to signal that the game has finished.
     */

    private boolean finishedGame;

    /**
     * Integer flag to signal the last coach to inform the referee that the teams are ready.
     */

    private int lastCoach;

    /**
     * Number of players that have finished playing (already pulled the rope).
     */

    private int donePlaying;

    /**
     * Number of players that are ready to play.
     */

    private int playersReady;

    /**
     * Integer flag to signal the number of players that are playing.
     */

    private int playersPlaying;

    /**
     * Number of players that have already played and are going to seat.
     */

    private int goSeat;

    /**
     * Position of the rope.
     */

    private int posRope;

    /**
     * Number of coaches that have reviewed the notes.
     */

    private int reviewedNotes;

    /**
     * Number of trials.
     */
    
    private int nTrials;

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
     * Get if the game has finished.
     * 
     * @return boolean flag that indicates if the game has finished
     */
    public boolean getFinishedGame() {
        return finishedGame;
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
     * PlayGround instantiation.
     * 
     * @param repos reference to the general repository
     */

    @SuppressWarnings("unchecked")
    public PlayGround(GeneralRepos repos) {
        this.repos = repos;

        contestants = new Contestant[SimulPar.P];
        coaches = new Coach[SimulPar.C];


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
        allPlayersPulled = false;
        allPlayersReady = false;
        refereeInformed = false;
        finishedGame = false;
        lastCoach = 0;
        donePlaying = 0;
        playersReady = 0;
        playersPlaying = 0;
        goSeat = 0;
        posRope = 0;
        reviewedNotes = 0;
        nTrials = 0;
    }

    /**
     * Operation getReady.
     * 
     * It is called by the contestants to get ready to play and notify the coaches that they are ready.
     */
    public synchronized void getReady() {

        int contestantId = ((Contestant) Thread.currentThread()).getContestantId();
        contestants[contestantId] = (Contestant) Thread.currentThread();

        playersReady++;
        if (playersReady == SimulPar.P_T) {
            notifyAll();
        }

        while (!allPlayersReady) {
            try {
                wait();
            } catch (InterruptedException e) {}
        }

        playersPlaying++;
        if (playersPlaying == SimulPar.P_T) {
            playersPlaying = 0;
            allPlayersReady = false;
        }

        contestants[contestantId].setContestantState(ContestantState.DO_YOUR_BEST);
        repos.setContestantStateAndStrength(contestantId, ContestantState.DO_YOUR_BEST,
                contestants[contestantId].getStrength(), contestants[contestantId].getTeamId());
    }

    /**
     * Operation informReferee.
     * 
     * It is called by the coaches to inform the referee that the teams are ready to proceed.
     */

    public synchronized void informReferee() {

        int coachId = ((Coach) Thread.currentThread()).getCoachId();
        coaches[coachId] = (Coach) Thread.currentThread();

        while (playersReady < SimulPar.P_T) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }

        lastCoach++;

        if (lastCoach == SimulPar.C) {
            refereeInformed = true;
            playersReady = 0;
            lastCoach = 0;
            notifyAll();
        }

        ((Coach) Thread.currentThread()).setCoachState(CoachState.WATCH_TRIAL);
        repos.setCoachState(coachId, CoachState.WATCH_TRIAL);
    }
   
    /**
     * Operation startTrial.
     * 
     * It is called by the referee to start the trial.
     */

    public synchronized void startTrial() {

        while (!refereeInformed) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        System.out.println("\nTrial started n: "+nTrials);
        refereeInformed = false;
        allPlayersReady = true;

        if (finishedGame == true) {
            finishedGame = false;
            nTrials = 1;
            posRope = 0;
            repos.setPosRope(posRope);
        } else {
            nTrials++;
        }

        repos.setNTrials(nTrials);
        ((Referee) Thread.currentThread()).setRefereeState(RefereeState.WAIT_FOR_TRIAL_CONCLUSION);
        repos.setRefereeState(RefereeState.WAIT_FOR_TRIAL_CONCLUSION);

        notifyAll(); // contestants are waken up to play
    }
    
    /**
     * Operation amDone.
     * 
     * It is called by the contestants to signal that they have finished playing.
     */

    public synchronized void amDone() {

        int contestantId = ((Contestant) Thread.currentThread()).getContestantId();
        contestants[contestantId] = (Contestant) Thread.currentThread();

        donePlaying++;

        if (donePlaying == SimulPar.P_T) {
            allPlayersPulled = true;
            donePlaying = 0;
            notifyAll();
        }

        while (!assertTrialDecisionContestants) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }

        goSeat++;

        if (goSeat == SimulPar.P_T) {
            goSeat = 0;
            assertTrialDecisionContestants = false;
        }
    }

    /**
     * Operation assertTrialDecision.
     * 
     * It is called by the referee to assert the trial decision.
     * 
     * @return position of the rope
     */
    
    public synchronized int assertTrialDecision() {

        while (!allPlayersPulled) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        allPlayersPulled = false;

        int team1Strength = 0;
        int team0Strength = 0;

        List<Contestant> chosenTeam0 = new ArrayList<>();
        List<Contestant> chosenTeam1 = new ArrayList<>();

        Contestant contestant = null;
        // adicionar os membros das equipas aos arrays, se for menor que 5 guarda na team 0 se for maior guarda na team 1
        // no Referee que usar o getContestantID() para obter os ids dos membros das equipas
        for (int i = 0; i < SimulPar.P; i++) {
            contestant = getContestant(i);
            if (contestant != null && contestant.getIsPlaying()) {
                if (i >= 0 && i < 5) {
                    chosenTeam0.add(contestant);
                } else if (i >= 5 && i < 10) {
                    chosenTeam1.add(contestant);
                }
            }
        }
        

        System.out.println("TEEEEEAM 0: "+chosenTeam0);
        System.out.println("TEEEEEAM 1: "+chosenTeam1);
        System.out.println("Asserted trial decision\n");
        
        // // Initialize the team and the strength queue.
        for (int i = 0; i < SimulPar.C; i++) {
            strengthQueue[i] = new PriorityQueue<>((c1, c2) -> c2.getStrength() - c1.getStrength());
            strengthQueue[i].addAll(teamMembers[i]);
        }

        for (int i = 0; i < SimulPar.P_T / 2; i++) {
            team0Strength += chosenTeam0.get(i).getStrength();
        }
        for (int i = 0; i < SimulPar.P_T / 2; i++) {
            team1Strength += chosenTeam1.get(i).getStrength();
        }

        posRope += team1Strength - team0Strength;

        if (posRope < 0) {
            if (posRope <= -4) {
                finishedGame = true;
            }
        } else if (posRope > 0) {
            if (posRope >= 4) {
                finishedGame = true;
            }
        }
        if (nTrials == SimulPar.T)
            finishedGame = true;

        repos.setPosRope(posRope);

        // wake up both coaches and contestants
        assertTrialDecisionContestants = true;
        assertTrialDecisionCoaches = true;
        notifyAll();

        return posRope;
    }

    /**
     * Operation reviewNotes.
     * 
     * It is called by the coaches to review the notes of the contestants and redo the contestant strength queue.
     */

    public synchronized void reviewNotes() {

        int coachId;
        coachId = ((Coach) Thread.currentThread()).getCoachId();
        coaches[coachId] = (Coach) Thread.currentThread();
        
        while (!assertTrialDecisionCoaches) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        
        reviewedNotes++;

        if (reviewedNotes == SimulPar.C) {
            reviewedNotes = 0;
            assertTrialDecisionCoaches = false;
        }


        coaches[coachId].setCoachState(CoachState.WAIT_FOR_REFEREE_COMMAND);
        repos.setCoachState(coachId, coaches[coachId].getCoachState());

        // reorganize the strength queue
        createStrengthQueue(coachId);
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
        Iterator<Contestant> iterator = strengthQueue[teamId].iterator();
        while (iterator.hasNext() && selectTeamMembers.size() < SimulPar.P_T/2) {
            Contestant contestant = iterator.next();
            selectTeamMembers.add(contestant);
        }
    
        return selectTeamMembers;
    }
}