package clientSide.entities;

import clientSide.stubs.PlayGroundStub;
import clientSide.stubs.BenchStub;
import clientSide.stubs.RefereeSiteStub;

/**
 * Contestant thread.
 * 
 * It simulates the contestant life cycle.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public class Contestant extends Thread {

    /**
     * Contestant identification.
     */

    private int contestantId;

    /**
     * Contestant state.
     */

    private int contestantState;

    /**
     * Team identification.
     */

    private int teamId;

    /**
     * Boolean flag that indicates if the contestant is playing.
     */

    private boolean isPlaying;

    /**
     * Contestant strength.
     */

    private int strength;

    /**
     * Reference to the playground.
     */

    private final PlayGroundStub pGroundStub;

    /**
     * Reference to the bench.
     */

    private final BenchStub benchStub;

    /**
     * Reference to the referee site.
     */

    private final RefereeSiteStub refSiteStub;

    /**
     * Instantiation of a contestant thread.
     * 
     * @param name         thread name
     * @param contestantId contestant identification
     * @param teamId       team identification
     * @param strength     contestant strength
     * @param pGroundStub  reference to the playground stub
     * @param benchStub    reference to the bench stub
     * @param refSiteStub  reference to the referee site stub
     */

    public Contestant(String name, int contestantId, int teamId, int strength, PlayGroundStub pGroundStub,
            BenchStub benchStub, RefereeSiteStub refSiteStub) {
        super(name);
        this.contestantId = contestantId;
        this.teamId = teamId;
        this.strength = strength;
        this.pGroundStub = pGroundStub;
        this.benchStub = benchStub;
        this.refSiteStub = refSiteStub;
        contestantState = ContestantState.SEAT_AT_THE_BENCH;
        isPlaying = false;
    }

    /**
     * Set contestant id.
     * 
     * @param id contestant id
     */

    public void setContestantId(int id) {
        contestantId = id;
    }

    /**
     * Get contestant id.
     * 
     * @return contestant id
     */

    public int getContestantId() {
        return contestantId;
    }

    /**
     * Set contestant state.
     * 
     * @param state new contestant state
     */

    public void setContestantState(int state) {
        contestantState = state;
    }

    /**
     * Get contestant state.
     * 
     * @return contestant state
     */

    public int getContestantState() {
        return contestantState;
    }

    /**
     * Set contestant strength.
     * 
     * @param strength contestant strength
     */

    public void setStrength(int strength) {
        this.strength = strength;
    }

    /**
     * Get contestant strength.
     * 
     * @return contestant strength
     */

    public int getStrength() {
        return strength;
    }

    /**
     * Set if the contestant is playing.
     * 
     * @param isPlaying boolean flag that indicates if the contestant is playing
     */

    public void setIsPlaying(boolean isPlaying) {
        this.isPlaying = isPlaying;
    }

    /**
     * Get if the contestant is playing.
     * 
     * @return boolean flag that indicates if the contestant is playing
     */

    public boolean getIsPlaying() {
        return isPlaying;
    }

    /**
     * Get team id of the contestant.
     * 
     * @return team id
     */

    public int getTeamId() {
        return teamId;
    }

    /**
     * Contestant life cycle.
     */

    @Override
    public void run() {
        benchStub.seatDown();
        while (!refSiteStub.getEndOfMatch()) {
            benchStub.followCoachAdvice();
            pGroundStub.getReady();
            pullTheRope();
            pGroundStub.amDone();
            benchStub.seatDown();
        }
    }

    /**
     * Pull the rope.
     * 
     * Internal operation.
     */

    public void pullTheRope() {
        try {
            sleep((long) (1 + 100 * Math.random()));
        } catch (InterruptedException e) {
        }
    }
}