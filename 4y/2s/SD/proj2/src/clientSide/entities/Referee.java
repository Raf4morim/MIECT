package clientSide.entities;

import java.util.*;
import clientSide.stubs.PlayGroundStub;
import clientSide.stubs.BenchStub;
import clientSide.stubs.RefereeSiteStub;

/**
 * Referee thread.
 * 
 * It simulates the referee life cycle.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public class Referee extends Thread {

    /**
     * Referee state.
     */

    private int refereeState;

    /**
     * Reference to the playground.
     */

    private final PlayGroundStub pGroundStub;

    /**
     * Reference to the referee site.
     */

    private final RefereeSiteStub refSiteStub;

    /**
     * Reference to the bench.
     */

    private final BenchStub benchStub;

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

    public Referee(String name, PlayGroundStub pGroundStub, RefereeSiteStub refSiteStub, BenchStub benchStub) {
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
            refSiteStub.announceNewGame();
            do {
                benchStub.callTrial();
                pGroundStub.startTrial();
                posRope = pGroundStub.assertTrialDecision();
            } while (!pGroundStub.getFinishedGame());
            endOfMatch = refSiteStub.declareGameWinner(posRope);
            benchStub.canEndTheGame(endOfMatch);
        } while (!refSiteStub.getEndOfMatch());
        refSiteStub.declareMatchWinner();
    }
}
