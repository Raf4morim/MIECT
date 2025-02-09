package entities;

/**
 * Definition of the internal states of the referee during his life cycle.
 */

public final class RefereeState {
    /**
     * The referee starts a new match.
     */

    public static final int START_OF_THE_MATCH = 0;

    /**
     * The referee starts a new game.
     */

    public static final int START_OF_A_GAME = 1;

    /**
     * The referee is waiting for all teams to be ready.
     */

    public static final int TEAMS_READY = 2;

    /**
     * The referee is waiting for all the players finish playing.
     */

    public static final int WAIT_FOR_TRIAL_CONCLUSION = 3;

    /**
     * The referee is waiting for all players to be seated.
     */

    public static final int WAIT_UNTIL_ALL_SEATED = 6;

    /**
     * The referee ends a game.
     */

    public static final int END_OF_A_GAME = 4;

    /**
     * The referee ends the match.
     */

    public static final int END_OF_THE_MATCH = 5;

    /**
     * It can not be instantiated.
     */

    private RefereeState() {
    }
}