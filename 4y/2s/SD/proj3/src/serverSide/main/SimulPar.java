package serverSide.main;

/**
 * Definition of the simulation parameters.
 */
public class SimulPar {

    private SimulPar() {
    }

    /**
     * Number of total players
     */

    public static final int P = 10;

    /**
     * Number of players playing in each Trial
     */

    public static final int P_T = 6;

    /**
     * Number of coaches
     */

    public static final int C = 2;

    /**
     * Number of referees
     */

    public static final int R = 1;

    /**
     * Number of games
     */

    public static final int G = 3;

    /**
     * Number of trials
     */

    public static final int T = 6;

    /**
     * Number of entities requesting Bench shutdown.
     */

    public static final int EB = 2;

    /**
     * Number of entities requesting Playground shutdown.
     */

    public static final int EP = 2;

    /**
     * Number of entities requesting RefereeSite shutdown.
     */

    public static final int ER = 3;

    /**
     * Number of entities requesting general repos shutdown.
     */

    public static final int EG = 3;

}
