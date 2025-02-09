package clientSide.entities;

/**
 * Contestant cloning.
 * 
 * It specifies his own attributes.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public interface ContestantCloning {

    /**
     * Set contestant id.
     * 
     * @param id contestant id
     */

    public void setContestantId(int id);

    /**
     * Get contestant id.
     * 
     * @return contestant id
     */

    public int getContestantId();

    /**
     * Set contestant state.
     * 
     * @param state new contestant state
     */

    public void setContestantState(int state);

    /**
     * Get contestant state.
     * 
     * @return contestant state
     */

    public int getContestantState();

    /**
     * Set contestant strength.
     * 
     * @param strength contestant strength
     */

    public void setStrength(int strength);

    /**
     * Get contestant strength.
     * 
     * @return contestant strength
     */

    public int getStrength();

    /**
     * Set if the contestant is playing.
     * 
     * @param isPlaying boolean flag that indicates if the contestant is playing
     */

    public void setIsPlaying(boolean isPlaying);

    /**
     * Get if the contestant is playing.
     * 
     * @return boolean flag that indicates if the contestant is playing
     */

    public boolean getIsPlaying();

    /**
     * Get team id of the contestant.
     * 
     * @return team id
     */

    public int getTeamId();

}