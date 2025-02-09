package entities;

/**
 * Definition of the internal states of the contestant during his life cycle.
 */

public final class ContestantState {
    /**
     * The contestant is sitting at the bench waiting for the coach to call him.
     */

    public static final int SEAT_AT_THE_BENCH = 0;

    /**
     * The contestant is standing in position waiting for the referee to start the trial.
     */

    public static final int STAND_IN_POSITION = 1;

    /**
     * The contestant is doing his best in the trial.
     */

    public static final int DO_YOUR_BEST = 2;

    /**
     * It can not be instantiated.
     */
    
    private ContestantState() {
    }
}
