package clientSide.entities;

/**
 * Definition of the internal states of the coach during his life cycle.
 */

public final class CoachState {
    /**
     * The coach is waiting for the referee command to call a new trial.
     */

    public static final int WAIT_FOR_REFEREE_COMMAND = 0;

    /**
     * The coach is assembling his team.
     */

    public static final int ASSEMBLE_TEAM = 1;

    /**
     * The coach is watching the trial.
     */

    public static final int WATCH_TRIAL = 2;

    /**
     * It can not be instantiated.
     */

    private CoachState() {
    }
}