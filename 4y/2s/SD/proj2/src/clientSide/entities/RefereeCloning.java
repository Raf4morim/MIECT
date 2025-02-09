package clientSide.entities;

import java.util.*;

/**
 * Referee cloning.
 * 
 * It specifies his own attributes.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public interface RefereeCloning {

    /**
     * Set referee state.
     * 
     * @param state new referee state
     */

    public void setRefereeState(int state);

    /**
     * Get referee state.
     * 
     * @return referee state
     */

    public int getRefereeState();

    /**
     * Add a coach Id to the list of coaches Ids.
     * 
     * @param coach the coach to add
     */

    public void addCoach(int coachId);

    /*
     * Add a contestant to the list of contestants ids.
     * 
     */

    public void addContestant(int id);

    /**
     * Get contestant ids.
     * Used on assertTrialDecision to Referee get full team.
     * 
     * @param teamID id of the team
     * @return list of contestant ids
     */
    public List<Integer> getContestantID(int teamID);
}
