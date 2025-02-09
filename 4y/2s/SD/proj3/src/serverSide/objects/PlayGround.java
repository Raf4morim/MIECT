package serverSide.objects;

import java.rmi.RemoteException;
import java.util.*;
import interfaces.PlayGroundInterface;
import interfaces.GeneralReposInterface;
import clientSide.entities.*;
import serverSide.main.*;
import genclass.GenericIO;

/**
 * PlayGround.
 *
 * It is responsible for the synchronization of the coaches, contestants and
 * referee during the trial and it is implemented as an implicit monitor.
 * All public methods are executed in mutual exclusion.
 * There are six synchronization points: two blocking points for the referee,
 * where he waits for the last coach to inform him that the teams are ready before
 * starting a new trial and waits for the trial to end (all players have pulled the rope);
 * two blocking points for the coaches, where they wait for all the players to be ready
 * and wait for the referee to assert the trial decision;
 * and two blocking points for the contestants, where they wait for the referee to start
 * the trial and wait for the referee to assert the trial decision.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on Java RMI.
 */

public class PlayGround implements PlayGroundInterface {

    /**
     * Reference to the general repository.
     */

    private final GeneralReposInterface repos;

    /**
     * Reference to coaches threads.
     */

    private final Thread[] coaches;

    /**
     * Reference to contestants threads.
     */

    private final Thread[] contestants;

    /**
     * Strength of the contestants.
     */

    private int[] strengthContestants;

    /**
     * Boolean flag that indicates if all players have pulled the rope.
     */

    private boolean allPlayersPulled;

    /**
     * Boolean flag that indicates if all players are ready.
     */

    private boolean allPlayersReady;

    /**
     * Boolean flag that indicates if the referee has been informed.
     */

    private boolean refereeInformed;

    /**
     * Boolean flag that indicates if the trial decision has been asserted, to be checked by the contestants.
     */

    private boolean assertTrialDecisionContestants;

    /**
     * Boolean flag that indicates if the trial decision has been asserted, to be checked by the coaches.
     */

    private boolean assertTrialDecisionCoaches;

    /**
     * Boolean flag that indicates if the game has finished.
     */

    private boolean finishedGame;

    /**
     * Int flag for the last coach to inform the referee.
     */

    private int lastCoach;

    /**
     * Number of contestants that have finished playing.
     */

    private int donePlaying;

    /**
     * Number of players that are ready.
     */

    private int playersReady;

    /**
     * Number of players that are playing.
     */

    private int playersPlaying;

    /**
     * Number of players that have to go to the seat.
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
     * Number of trials played.
     */

    private int nTrials;

    /**
     * Number of entities that have terminated.
     */

    private List<Integer>[] teamMembers; 
    
    /**
     * Strength queues for both teams.
     */

    private PriorityQueue<Integer>[] strengthQueue;

    /**
     * Boolean flag that indicates if the players are playing locally.
     */

    private boolean[] isPlayingLocal;

    /**
     * Number of entities that have terminated.
     */

    private int nEntities = 0;

    /**
     * Get the number of trials played.
     * 
     * @return number of trials played
     */

    public int getnTrials() {
        return nTrials;
    }

    /**
     * Get if the game has finished.
     * 
     * @return game finished flag
     */

    public boolean getFinishedGame() {
        return finishedGame;
    }

    /**
     * Instantiation of the playground.
     * 
     * @param repos reference to the general repository
     */

    @SuppressWarnings("unchecked")
    public PlayGround(GeneralReposInterface repos) {
        this.repos = repos;

        contestants = new Thread[SimulPar.P];
        coaches = new Thread[SimulPar.C];
        strengthContestants = new int[SimulPar.P];
        teamMembers = new ArrayList[SimulPar.C];
        strengthQueue = new PriorityQueue[SimulPar.C];
        isPlayingLocal = new boolean[SimulPar.P];

        for (int i = 0; i < SimulPar.C; i++) {
            coaches[i] = null;
            teamMembers[i] = new ArrayList<>();
            strengthQueue[i] = new PriorityQueue<>((c1, c2) -> strengthContestants[c2] - strengthContestants[c1]);
        }
        for (int i = 0; i < SimulPar.P; i++) {
            contestants[i] = null;
            isPlayingLocal[i] = false;
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
     * @param strength strength of the contestant
     * @param contestantId contestant id
     * @return contestant state
     */

    public synchronized int getReady(int strength, int contestantId) throws RemoteException{
        strengthContestants[contestantId] = strength;

        playersReady++;
        if (playersReady == SimulPar.P_T) {
            notifyAll();
        }

        while (!allPlayersReady) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        
        
        playersPlaying++;
        if (playersPlaying == SimulPar.P_T) {
            playersPlaying = 0;
            allPlayersReady = false;
        }
        
        isPlayingLocal[contestantId] = true;
        int team_id = (contestantId < 5) ? 0 : 1;

        try {
            repos.setContestantStateAndStrength(contestantId, ContestantState.DO_YOUR_BEST, strengthContestants[contestantId], team_id);
        } catch (RemoteException e) {
            GenericIO.writelnString("Contestant " + contestantId + " remote exception on getReady - setRefereeState: " + e.getMessage());
            System.exit(1);
        }
        createStrengthQueue(team_id, contestantId);
        return ContestantState.DO_YOUR_BEST;
    }

    /**
     * Operation informReferee.
     * 
     * It is called by the coaches to inform the referee that the teams are ready to proceed.
     * @param coachId coach id
     * @return coach state
     */

    public synchronized int informReferee(int coachId) throws RemoteException{
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

        try {
            repos.setCoachState(coachId, CoachState.WATCH_TRIAL);
        } catch (RemoteException e) {
            GenericIO.writelnString("Coach " + coachId + " remote exception on informReferee - setCoachState: " + e.getMessage());
            System.exit(1);
        }
        return CoachState.WATCH_TRIAL;
    }

    /**
     * Operation startTrial.
     * 
     * It is called by the referee to start the trial.
     * 
     * @return referee state
     */

    public synchronized int startTrial() throws RemoteException{
        System.out.println("startTrial");
        
        while (!refereeInformed) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }

        refereeInformed = false;
        allPlayersReady = true;

        if (finishedGame) {
            finishedGame = false;
            nTrials = 1;
            posRope = 0;
            try {
                repos.setPosRope(posRope);
            } catch (RemoteException e) {
                GenericIO.writelnString("Referee remote exception on startTrial - setPosRope: " + e.getMessage());
                System.exit(1);
            }
        } else {
            nTrials++;
        }

        try {
            repos.setNTrials(nTrials);
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on startTrial - setNTrials: " + e.getMessage());
            System.exit(1);
        }

        try {
            repos.setRefereeState(RefereeState.WAIT_FOR_TRIAL_CONCLUSION);
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on startTrial - setRefereeState: " + e.getMessage());
            System.exit(1);
        }

        notifyAll();
        return RefereeState.WAIT_FOR_TRIAL_CONCLUSION;
    }

    /**
     * Operation amDone.
     * 
     * It is called by the contestants to signal that they have finished playing.
     * @param contestantId contestant id
     */

    public synchronized void amDone(int contestantId) throws RemoteException {
        System.out.println("amDone");

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

    public synchronized int assertTrialDecision() throws RemoteException {
        System.out.println("assertTrialDecision");

        int team0Strength = 0;
        int team1Strength = 0;

        while (!allPlayersPulled) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }

        allPlayersPulled = false;

        for (int i = 0; i < 5; i++) {
            if (isPlayingLocal[i]) {
                team0Strength += strengthContestants[i];
                isPlayingLocal[i] = false;
            }
        }
        for (int i = 5; i < SimulPar.P; i++) {
            if (isPlayingLocal[i]) {
                team1Strength += strengthContestants[i];
                isPlayingLocal[i] = false;
            }
        }

        posRope += team1Strength - team0Strength;

        if (posRope <= -4 || posRope >= 4 || nTrials == SimulPar.T) {
            finishedGame = true;
        }

        try {
            repos.setPosRope(posRope);
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on assertTrialDecision - setPosRope: " + e.getMessage());
            System.exit(1);
        }

        assertTrialDecisionContestants = true;
        assertTrialDecisionCoaches = true;
        notifyAll();

        return posRope;
    }

    /**
     * Operation reviewNotes.
     * 
     * It is called by the coaches to review the notes of the contestants and redo the contestant strength queue.
     * @param coachId coach id
     * @return coach state
     */

    public synchronized int reviewNotes(int coachId) throws RemoteException {
        System.out.println("reviewNotes");

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

        try {
            repos.setCoachState(coachId, CoachState.WAIT_FOR_REFEREE_COMMAND);
        } catch (RemoteException e) {
            GenericIO.writelnString("Coach " + coachId + " remote exception on reviewNotes - setCoachState: " + e.getMessage());
            System.exit(1);
        }

        return CoachState.WAIT_FOR_REFEREE_COMMAND;
    }

    /**
     * Create strength queue.
     * 
     * It creates a priority queue with the team members ordered by strength.
     * 
     * @param teamId team id
     * @param contestantId contestant id    
     * 
     * @see <a href="https://docs.oracle.com/javase/8/docs/api/java/util/PriorityQueue.html">PriorityQueue</a>
     */

    public void createStrengthQueue(int teamId, int contestantId) {
        teamMembers[teamId].add(contestantId);
        strengthQueue[teamId].clear();
        strengthQueue[teamId].addAll(teamMembers[teamId]);
    }

    /**
     *   Operation server shutdown.
     *
     *   New operation.
     */
    
    public synchronized void shutdown() throws RemoteException {
        nEntities++;
        if (nEntities == 3)
            ServerPlayGround.shutdown();
        notifyAll();
    }
}
