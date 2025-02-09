package entities;

import sharedRegions.*;

/**
 * Contestant thread.
 * 
 * It simulates the contestant life cycle.
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

    private final PlayGround pGround;

    /**
     * Reference to the bench.
     */

    private final Bench bench;

    /**
     * Reference to the referee site.
     */

    private final RefereeSite refSite;

    /**
     * Instantiation of a contestant thread.
     * 
     * @param name thread name
     * @param contestantId contestant identification
     * @param teamId team identification
     * @param strength contestant strength
     * @param pGround reference to the playground
     * @param bench reference to the bench
     * @param refSite reference to the referee site
     */

    public Contestant(String name, int contestantId, int teamId, int strength, PlayGround pGround, Bench bench,
            RefereeSite refSite) {
        super(name);
        this.contestantId = contestantId;
        this.teamId = teamId;
        this.strength = strength;
        this.pGround = pGround;
        this.bench = bench;
        this.refSite = refSite;
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
        bench.seatDown();
        while (!refSite.getEndOfMatch()) {
            bench.followCoachAdvice();
            pGround.getReady();
            pullTheRope();
            pGround.amDone();
            bench.seatDown();
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