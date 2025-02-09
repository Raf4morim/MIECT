package clientSide.entities;

import java.util.*;
import interfaces.*;
import java.rmi.*;
import genclass.GenericIO;

/**
 * Referee thread.
 * 
 * It simulates the referee life cycle.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on remote calls under Java RMI.
 */

public class Referee extends Thread {

    /**
     * Referee state.
     */

    private int refereeState;

    /**
     * Reference to the playground.
     */

    private final PlayGroundInterface pGroundStub;

    /**
     * Reference to the referee site.
     */

    private final RefereeSiteInterface refSiteStub;

    /**
     * Reference to the bench.
     */

    private final BenchInterface benchStub;

    /**
     * List of coach Ids.
     * 
     * It is used to access team strengths.
     */

    private List<Integer> coachIds;

    /*
     * List of contestantIds.
     * 
     * It is used to access full team in assertTrialDecision.
     */

    private List<Integer> contestantIds;

    /**
     * Instantiation of a referee thread.
     * 
     * @param name    thread name
     * @param pGroundStub reference to the playground stub
     * @param refSiteStub reference to the referee site stub
     * @param benchStub   reference to the bench stub
     */

    public Referee(String name, PlayGroundInterface pGroundStub, RefereeSiteInterface refSiteStub, BenchInterface benchStub) {
        super(name);
        this.pGroundStub = pGroundStub;
        this.refSiteStub = refSiteStub;
        this.benchStub = benchStub;
        refereeState = RefereeState.START_OF_THE_MATCH;
        coachIds = new ArrayList<>();
        contestantIds = new ArrayList<>();
    }

    /**
     * Set referee state.
     * 
     * @param state new referee state
     */

    public void setRefereeState(int state) {
        this.refereeState = state;
    }

    /**
     * Get referee state.
     * 
     * @return referee state
     */

    public int getRefereeState() {
        return refereeState;
    }

    /**
     * Add a coach Id to the list of coaches Ids.
     * 
     * @param coach the coach id to add
     */

    public void addCoach(int coachId) {
        coachIds.add(coachId);
    }

    /*
     * Add a contestant to the list of contestants.
     * 
     */

    public void addContestant(int id) {
        contestantIds.add(id);
    }

    /**
     * Get contestant ids.
     * Used on assertTrialDecision to Referee get full team.
     * 
     * @param teamID id of the team
     * @return list of contestant ids
     */

    public List<Integer> getContestantID(int teamID) {
        if (teamID == 0)
            return contestantIds.subList(0, 5);
        else
            return contestantIds.subList(5, 10);
    }

    /**
     * Referee life cycle.
     */

    @Override
    public void run() {
        int posRope;
        boolean endOfMatch;
        do {
            announceNewGame();
            do {
                callTrial();
                startTrial();
                posRope = assertTrialDecision();
            } while (!getFinishedGame());
            endOfMatch = declareGameWinner(posRope);
            canEndTheGame(endOfMatch);
        } while (!getEndOfMatch());
        declareMatchWinner();
    }

    private void declareMatchWinner() {
        int ret = -1;
        try {
            ret = refSiteStub.declareMatchWinner();
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on declareMatchWinner: " + e.getMessage());
            System.exit(1);
        }
        refereeState = ret;
    }

    private boolean getEndOfMatch() {
        boolean ret=false;
        try {
            ret= refSiteStub.getEndOfMatch();
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on getEndOfMatch: " + e.getMessage());
            System.exit(1);
        }
        return ret;
    }

    private void canEndTheGame(boolean endOfMatch) {
        int ret = -1;
        try {
            ret = benchStub.canEndTheGame(endOfMatch);
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on canEndTheGame: " + e.getMessage());
            System.exit(1);
        }
        refereeState = ret;
    }

    private boolean declareGameWinner(int posRope) {
        ReturnBoolean ret = null;
        try {
            ret = refSiteStub.declareGameWinner(posRope);
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on declareGameWinner: " + e.getMessage());
            System.exit(1);
        }
        refereeState = ret.getIntStateVal(); 
        return ret.getBooleanVal();
    }

    private boolean getFinishedGame() {
        boolean ret=false;

        try {
            ret= pGroundStub.getFinishedGame();
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on getFinishedGame: " + e.getMessage());
            System.exit(1);
        }
        return ret;
    }

    private int assertTrialDecision() {
        int posRope = 0;
        try {
            posRope = pGroundStub.assertTrialDecision();
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on assertTrialDecision: " + e.getMessage());
            System.exit(1);
        }
        return posRope;
    }

    private void startTrial() {
        int ret = -1;
        try {
            ret = pGroundStub.startTrial();
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on startTrial: " + e.getMessage());
            System.exit(1);
        }
        refereeState = ret;
    }

    private void callTrial() {
        int ret = -1;
        try {
            ret = benchStub.callTrial();
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on callTrial: " + e.getMessage());
            System.exit(1);
        }
        refereeState = ret;
    }

    private void announceNewGame() {
        int ret = -1;
        try {
            ret = refSiteStub.announceNewGame();
        } catch (RemoteException e) {
            GenericIO.writelnString("Referee remote exception on announceNewGame: " + e.getMessage());
            System.exit(1);
        }
        refereeState = ret;
    }
}
