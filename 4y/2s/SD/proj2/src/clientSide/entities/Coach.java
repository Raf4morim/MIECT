package clientSide.entities;

import clientSide.stubs.BenchStub;
import clientSide.stubs.RefereeSiteStub;
import clientSide.stubs.PlayGroundStub;
import java.util.List;

/**
 * Coach thread.
 * 
 * It simulates the coach life cycle.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public class Coach extends Thread {

    /**
     * Coach state.
     */

    private int coachState;

    /**
     * Coach and team identification.
     */

    private int teamId;

    /**
     * Team members.
     */

    private List<Integer> fullTeamMembers;

    /**
     * Reference to the bench.
     */

    private final BenchStub benchStub;

    /**
     * Reference to the referee site.
     */

    private final RefereeSiteStub refSiteStub;

    /**
     * Reference to the playground.
     */

    private final PlayGroundStub pGroundStub;

    /**
     * Instantiation of a coach thread.
     * 
     * @param name            thread name
     * @param teamId          team/coach identification
     * @param fullTeamMembers team members
     * @param benchStub       reference to the bench stub
     * @param refSiteStub     reference to the referee site stub
     * @param pGroundStub     reference to the playground stub
     */

    public Coach(String name, int teamId, List<Integer> fullTeamMembers, BenchStub benchStub,
            RefereeSiteStub refSiteStub, PlayGroundStub pGroundStub) {
        super(name);
        this.teamId = teamId;
        coachState = CoachState.WAIT_FOR_REFEREE_COMMAND;
        this.fullTeamMembers = fullTeamMembers;
        this.benchStub = benchStub;
        this.pGroundStub = pGroundStub;
        this.refSiteStub = refSiteStub;
    }

    /**
     * Set coach id.
     * 
     * @param id coach id
     */

    public void setCoachId(int id) {
        teamId = id;
    }

    /**
     * Get coach id.
     * 
     * @return coach id
     */

    public int getCoachId() {
        return teamId;
    }

    /**
     * Set coach state.
     * 
     * @param state new coach state
     */

    public void setCoachState(int state) {
        coachState = state;
    }

    /**
     * Get coach state.
     * 
     * @return coach state
     */

    public int getCoachState() {
        return coachState;
    }

    /**
     * Get full team.
     * 
     * It returns all the team members.
     * 
     * @return team members
     */

    public List<Integer> fullTeam() {
        return fullTeamMembers;
    }

    /**
     * Coach life cycle.
     */

    @Override
    public void run() {
        benchStub.callContestants();
        while (!refSiteStub.getEndOfMatch()) {
            pGroundStub.informReferee();
            pGroundStub.reviewNotes();
            benchStub.callContestants();
        }
    }
}