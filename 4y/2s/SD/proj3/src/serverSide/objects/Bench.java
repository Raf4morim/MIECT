package serverSide.objects;

import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;
import java.util.PriorityQueue;

import clientSide.entities.CoachState;
import clientSide.entities.ContestantState;
import clientSide.entities.RefereeState;
import interfaces.BenchInterface;
import interfaces.GeneralReposInterface;
import interfaces.ReturnInt;
import genclass.GenericIO;
import serverSide.main.ServerBench;
import serverSide.main.SimulPar;

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
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on Java RMI.
 */

public class Bench implements BenchInterface {
    /**
     * Reference to coaches threads.
     */

    private final Thread[] coaches;

    /**
     * Reference to contestants threads.
     */

    private final Thread[] contestants;

    /**
     * Reference to the general repository.
     */

    private final GeneralReposInterface repos;

    /**
     * Boolean flag that indicates the call of a trial.
     */

    private boolean callTrial;

    /**
     * Boolean flag that indicates the end of the match.
     */

    private boolean matchEnded;

    /**
     * Number of times both coaches were called.
     */

    private int bothCoachesCalled;

    /**
     * Number of players seated.
     */

    private int playersSeated;

    /**
     * Number of trials played.
     */

    private int nTrials;

    /**
     * Boolean flag that indicates the first trial was called.
     */

    private boolean firstTrialCalled;

    /**
     * Local boolean array that indicates if a contestant is playing.
     */

    private boolean[] isPlayingLocal;

    /**
     * Integer array that indicates the strength of a contestant.
     */

    private int[] contestantStrength;

    /**
     * List of team members IDs.
     */

    private ArrayList<Integer>[] teamMembers;

    /**
     * Priority queue of team members.
     */

    private PriorityQueue<Integer>[] strengthQueue;

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
     * Instantiate of the bench.
     * 
     * @param repos general repository
     */

    @SuppressWarnings("unchecked")
    public Bench(GeneralReposInterface repos) {
        coaches = new Thread[SimulPar.C];
        contestants = new Thread[SimulPar.P];
        teamMembers = new ArrayList[SimulPar.C];
        strengthQueue = new PriorityQueue[SimulPar.C];
        isPlayingLocal = new boolean[SimulPar.P];
        contestantStrength = new int[SimulPar.P];

        for (int i = 0; i < SimulPar.C; i++) {
            coaches[i] = null;
            teamMembers[i] = new ArrayList<>();
            strengthQueue[i] = new PriorityQueue<>((c1, c2) -> contestantStrength[c2] - contestantStrength[c1]);
        }
        for (int i = 0; i < SimulPar.P; i++) {
            contestants[i] = null;
            isPlayingLocal[i] = false;
            contestantStrength[i] = 0;
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

    public synchronized int callTrial() throws RemoteException {
        System.out.println("callTrial");

        while (playersSeated < SimulPar.P) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        callTrial = true;
        firstTrialCalled = true;

        try {
            repos.setRefereeState(RefereeState.TEAMS_READY);
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on callTrial - setRefereeState: " + e.getMessage());
            System.exit(1);
        }

        notifyAll();
        return RefereeState.TEAMS_READY;
    }

    /**
     * Operation callContestants.
     * 
     * It is called by the coaches to select the next team and wake up the selected contestants to play.
     * Increments the strength of the players that were not selected to play.
     * 
     */

    public synchronized int callContestants(int coachId) throws RemoteException {
        System.out.println("callContestants");

        List<Integer> fullTeamMembersIDs = new ArrayList<>();
        if (coachId == 0) {
            for (int i = 0; i < 5; i++) {
                fullTeamMembersIDs.add(i);
            }
        } else {
            for (int i = 5; i < 10; i++) {
                fullTeamMembersIDs.add(i);
            }
        }

        int cState = CoachState.WAIT_FOR_REFEREE_COMMAND; 

        PriorityQueue<Integer> strengthQueue = new PriorityQueue<>((c1, c2) -> contestantStrength[c2] - contestantStrength[c1]);
        strengthQueue.addAll(fullTeamMembersIDs);

        while (!callTrial) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        if (!matchEnded) {
            try {
                repos.setCoachState(coachId, CoachState.ASSEMBLE_TEAM);
                cState = CoachState.ASSEMBLE_TEAM;
            } catch (RemoteException e) {
                GenericIO.writelnString("Coach " + coachId + " remote exception on callContestants - setCoachState: " + e.getMessage());
                System.exit(1);
            }
        }

        List<Integer> chosenTeam = getNextTeam(coachId, strengthQueue);
        for (int contestantId : fullTeamMembersIDs) {
            int team_id = (Math.abs(contestantId) < 5) ? 0 : 1;

            if (chosenTeam.contains(contestantId)) {
                isPlayingLocal[contestantId] = true;
            }

            if (!isPlayingLocal[contestantId]) {
                contestantStrength[contestantId] = incrementStrength(contestantId); // return  contestantStrength[contestantId] 
                try {
                    repos.setContestantStateAndStrength(contestantId, ContestantState.SEAT_AT_THE_BENCH, contestantStrength[contestantId], team_id);
                } catch (RemoteException e) {
                    GenericIO.writelnString("Contestant " + contestantId + " remote exception on followCoachAdvice - setContestantStateAndStrength: " + e.getMessage());
                    System.exit(1);
                }
            }
            // System.out.println("call contestant "+contestantId+" isPlayingLocal[contestantId]: "+ isPlayingLocal[contestantId]);
        }    
        

        notifyAll();

        bothCoachesCalled++;
        if (bothCoachesCalled == SimulPar.C) {
            bothCoachesCalled = 0;
            callTrial = false;
        }

        return cState;
    }

    /**
     * Operation followCoachAdvice.
     * 
     * It is called by a contestant to follow the coach advice and stand in position.
     *
     */

    public synchronized ReturnInt followCoachAdvice(int strength, int contestantId) throws RemoteException {
        System.out.println("followCoachAdvice");

        playersSeated--;

        int team_id = (Math.abs(contestantId) < 5) ? 0 : 1;

        contestantStrength[contestantId] = strength;
        
        try {
            repos.setContestantStateAndStrength(contestantId, ContestantState.STAND_IN_POSITION, contestantStrength[contestantId], team_id);
        } catch (RemoteException e) {
            GenericIO.writelnString("Contestant " + contestantId + " remote exception on followCoachAdvice - setContestantStateAndStrength: " + e.getMessage());
            System.exit(1);
        }

        
        return new ReturnInt(contestantStrength[contestantId], ContestantState.STAND_IN_POSITION);
    }

    /**
     * Operation seatDown.
     * 
     * It is called by a contestant to seat down and wait until he is selected by the coach to play.
     * 
     */

    public synchronized ReturnInt seatDown(int strength, int contestantId) throws RemoteException {
        System.out.println("seatDown");

        contestantStrength[contestantId] = strength;
        
        if (firstTrialCalled && isPlayingLocal[contestantId]) {
            strength = decrementStrength(contestantId); // return  contestantStrength[contestantId]
        } 
        
        int team_id = (Math.abs(contestantId) < 5) ? 0 : 1;
        playersSeated++;

        try {
            repos.setContestantStateAndStrength(contestantId, ContestantState.SEAT_AT_THE_BENCH, contestantStrength[contestantId], team_id);
        } catch (RemoteException e) {
            GenericIO.writelnString("Contestant " + contestantId + " remote exception on seatDown - setContestantStateAndStrength: " + e.getMessage());
            System.exit(1);
        }

        if (playersSeated == SimulPar.P) {
            notifyAll();
        }

        // System.out.println("seat down id "+ contestantId+" isPlaying = "+ isPlayingLocal[contestantId]);
        isPlayingLocal[contestantId] = false;


        while (!isPlayingLocal[contestantId]) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }


        return new ReturnInt(contestantStrength[contestantId], ContestantState.SEAT_AT_THE_BENCH);
    }

    /**
     * Operation canEndTheGame.
     * 
     * It is called by the Referee to wait for all players to seat down and wake both contestants and coaches to finish the match.
     * 
     * @param endOfMatch boolean flag that indicates if the match has ended
     */

    public synchronized int canEndTheGame(boolean endOfMatch) throws RemoteException {
        System.out.println("canEndTheGame");

        System.out.println("players seated: "+ playersSeated);
        while (playersSeated < SimulPar.P) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        }
        System.out.println("endTheMatch: "+ endOfMatch);
        if (endOfMatch) {
            for (int j = 0; j < SimulPar.P; j++) {
                isPlayingLocal[j] = true;
                System.out.println("id "+j+" is playing = "+ isPlayingLocal[j]);
                
            }
            callTrial = true;
            matchEnded = true;
            
        }
        notifyAll();
        try {
            repos.setRefereeState(RefereeState.END_OF_A_GAME);
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on canEndTheGame - setRefereeState: " + e.getMessage());
            System.exit(1);
        }
        return RefereeState.END_OF_A_GAME;
    }

    /**
     * Get next team. 
     * 
     * It gets the three strongest team members.
     * 
     * @param teamId team ID
     * @param strengthQueue priority queue of team members
     * @return three strongest team members
     */

    public List<Integer> getNextTeam(int teamId, PriorityQueue<Integer> strengthQueue) {
        List<Integer> selectTeamMembers = new ArrayList<>();
        while (!strengthQueue.isEmpty() && selectTeamMembers.size() < SimulPar.P_T / 2) {
            selectTeamMembers.add(strengthQueue.poll());
        }

        return selectTeamMembers;
    }

    /**
     * Increment strength.
     * 
     * It increments the strength of a contestant.
     * 
     * @param contestantId contestant ID
     * @return contestant strength
     */

    public int incrementStrength(int contestantId) {
        if (contestantStrength[contestantId] < 10) {
            contestantStrength[contestantId]++;
        }
        return contestantStrength[contestantId];
    }

    /**
     * Decrement strength.
     * 
     * It decrements the strength of a contestant.
     * 
     * @param contestantId contestant ID
     * @return contestant strength
     */

    public int decrementStrength(int contestantId) {
        if (contestantStrength[contestantId] > 6) {
            contestantStrength[contestantId]--;
        }
        return contestantStrength[contestantId];
    }

    /**
     *   Operation server shutdown.
     *
     *   New operation.
     *
     *      @throws RemoteException if either the invocation of the remote method, or the communication with the registry
     *                              service fails
     */

    public synchronized void shutdown() throws RemoteException {
        nEntities++;
        if(nEntities == 3){
            ServerBench.shutdown();
        }
        
        notifyAll();
    }
}
