package clientSide.entities;

import java.util.List;

/**
 * Coach cloning.
 * 
 * It specifies his own attributes.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public interface CoachCloning {

    /**
     * Set coach id.
     * 
     * @param id coach id
     */

    public void setCoachId(int id);

    /**
     * Get coach id.
     * 
     * @return coach id
     */

    public int getCoachId();

    /**
     * Set coach state.
     * 
     * @param state new coach state
     */

    public void setCoachState(int state);

    /**
     * Get coach state.
     * 
     * @return coach state
     */

    public int getCoachState();

    /**
     * Get full team.
     * 
     * It returns all the team members.
     * 
     * @return team members
     */

    public List<Integer> fullTeamIDs();
}