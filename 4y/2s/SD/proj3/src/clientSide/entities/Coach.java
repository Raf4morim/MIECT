package clientSide.entities;

import interfaces.*;
import java.rmi.*;
import java.util.List;
import genclass.GenericIO;

/**
 * Coach thread.
 * 
 * It simulates the coach life cycle.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on remote calls under Java RMI.
 */

public class Coach extends Thread {

    /**
     * Coach state.
     */

    private int coachState;

    /**
     * Coach and team identification.
     */

    private int teamId;

    /**
     * Reference to the bench.
     */

    private final BenchInterface benchStub;

    /**
     * Reference to the referee site.
     */

    private final RefereeSiteInterface refSiteStub;

    /**
     * Reference to the playground.
     */

    private final PlayGroundInterface pGroundStub;

    /**
     * Instantiation of a coach thread.
     * 
     * @param name            thread name
     * @param teamId          team/coach identification
     * @param benchStub       reference to the bench stub
     * @param refSiteStub     reference to the referee site stub
     * @param pGroundStub     reference to the playground stub
     */

    public Coach(String name, int teamId, BenchInterface benchStub,
            RefereeSiteInterface refSiteStub, PlayGroundInterface pGroundStub) {
        super(name);
        this.teamId = teamId;
        coachState = CoachState.WAIT_FOR_REFEREE_COMMAND;
        this.benchStub = benchStub;
        this.pGroundStub = pGroundStub;
        this.refSiteStub = refSiteStub;
    }

    /**
     * Set coach id.
     * 
     * @param id coach id
     */

    public void setCoachId(int id) {
        teamId = id;
    }

    /**
     * Get coach id.
     * 
     * @return coach id
     */

    public int getCoachId() {
        return teamId;
    }

    /**
     * Set coach state.
     * 
     * @param state new coach state
     */

    public void setCoachState(int state) {
        coachState = state;
    }

    /**
     * Get coach state.
     * 
     * @return coach state
     */

    public int getCoachState() {
        return coachState;
    }

    /**
     * Coach life cycle.
     */

    @Override
    public void run() {
        callContestants();
        while (!getEndOfMatch()) {
            informReferee();
            reviewNotes();
            callContestants();
        }
    }

    // -------------------------------------------------

    private void callContestants() {
        int ret = -1;
        try {
            ret = benchStub.callContestants(teamId);
        } catch (RemoteException e) {
            GenericIO.writelnString("Coach " + teamId + "  remote exception on callContestants: " + e.getMessage());
            System.exit(1);
        }
        coachState = ret;
    }

    private boolean getEndOfMatch() {
        boolean ret=false;

        try {
            ret= refSiteStub.getEndOfMatch();
        } catch (RemoteException e) {
            GenericIO.writelnString("Coach " + teamId + "  remote exception on getEndOfMatch: " + e.getMessage());
            System.exit(1);
        }
        return ret;
    }

    private void informReferee() {
        int ret = -1;
        try {
            ret = pGroundStub.informReferee(teamId);
        } catch (RemoteException e) {
            GenericIO.writelnString("Coach " + teamId + "  remote exception on informReferee: " + e.getMessage());
            System.exit(1);
        }
        coachState = ret;
    }

    private void reviewNotes() {
        int ret = -1;
        try {
            ret = pGroundStub.reviewNotes(teamId);
        } catch (RemoteException e) {
            GenericIO.writelnString("Coach " + teamId + "  remote exception on reviewNotes: " + e.getMessage());
            System.exit(1);
        }
        coachState = ret;
    }
}
