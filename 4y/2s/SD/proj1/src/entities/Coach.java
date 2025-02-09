package entities;

import sharedRegions.*;
import java.util.PriorityQueue;

import main.SimulPar;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Coach thread.
 * 
 * It simulates the coach life cycle.
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
     * Strength queue.
     * 
     * It is used to order the team members by strength.
     */

    // private PriorityQueue<Contestant> strengthQueue;

    /**
     * Reference to the bench.
     */

    private final Bench bench;

    /**
     * Reference to the referee site.
     */

    private final RefereeSite refSite;

    /**
     * Reference to the playground.
     */

    private final PlayGround pGround;

    /**
     * Instantiation of a coach thread.
     * 
     * @param name thread name
     * @param teamId team/coach identification
     * @param fullTeamMembers team members
     * @param bench reference to the bench
     * @param refSite reference to the referee site
     * @param pGround reference to the playground
     */

    public Coach(String name, int teamId, List<Integer> fullTeamMembers, Bench bench, RefereeSite refSite, PlayGround pGround) {
        super(name);
        this.teamId = teamId;
        coachState = CoachState.WAIT_FOR_REFEREE_COMMAND;
        this.fullTeamMembers = fullTeamMembers;
        this.bench = bench;
        this.pGround = pGround;
        this.refSite = refSite;
        // createStrengthQueue();
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
        bench.callContestants();
        while (!refSite.getEndOfMatch()) {
            pGround.informReferee();
            pGround.reviewNotes();
            bench.callContestants();
        }
    }
}
