package entities;

import java.util.List;
import java.util.ArrayList;
import main.SimulPar;

import sharedRegions.*;

/**
 * Referee thread.
 * 
 * It simulates the referee life cycle.
 */

public class Referee extends Thread {

    /**
     * Referee state.
     */

    private int refereeState;

    /**
     * Reference to the playground.
     */

    private final PlayGround pGround;

    /**
     * Reference to the referee site.
     */

    private final RefereeSite refSite;

    /**
     * Reference to the bench.
     */

    private final Bench bench;

    /**
     * List of coachIds.
     * 
     * It is used to access team strengths.
     */

    private List<Integer> coachIds;

    /*
     * List of contestantIds.
     * 
     * It is used to access full team in assertTrialDecision.
     */

    private List<Integer> contestantIds;

    /**
     * Instantiation of a referee thread.
     * 
     * @param name thread name
     * @param pGround reference to the playground
     * @param refSite reference to the referee site
     * @param bench reference to the bench
     */

    public Referee(String name, PlayGround pGround, RefereeSite refSite, Bench bench) {
        super(name);
        this.pGround = pGround;
        this.refSite = refSite;
        this.bench = bench;
        refereeState = RefereeState.START_OF_THE_MATCH;
        coachIds = new ArrayList<>();
        contestantIds = new ArrayList<>();
        // coaches = new ArrayList<>();
    }

    /**
     * Set referee state.
     * 
     * @param state new referee state
     */

    public void setRefereeState(int state) {
        this.refereeState = state;
    }

    /**
     * Get referee state.
     * 
     * @return referee state
     */

    public int getRefereeState() {
        return refereeState;
    }

    /**
     * Add a coach to the list of coaches.
     * 
     * @param coach the coach to add
     */

    // public void addCoach(Coach coach) {
    //     coaches.add(coach);
    // }
    public void addCoach(int coachId) {
        coachIds.add(coachId);
    }

    /**
     * Get coach of a specific team.
     * 
     * @param teamId id of the team
     * @return coach of the specified team
     */

    public int getCoach(int teamId) {
        return coachIds.get(teamId);
    }

    /*
     * Add a contestant to the list of contestants.
     * 
     */

    public void addContestant(int id) {
        contestantIds.add(id);
    }

    /**
     * Get contestant ids.
     * Used on assertTrialDecision to Referee get full team.
     * 
     * @param teamID id of the team
     * @return list of contestant ids
     */

    public List<Integer> getContestantID(int teamID) {
        if (teamID == 0)
            return contestantIds.subList(0, 5);
        else
            return contestantIds.subList(5, 10);
    }

    /**
     * Referee life cycle.
     */

    @Override
    public void run() {
        int posRope;
        boolean endOfMatch;
        do {
            refSite.announceNewGame();
            do {
                bench.callTrial();
                pGround.startTrial();
                posRope = pGround.assertTrialDecision();
            } while (!pGround.getFinishedGame());
            endOfMatch = refSite.declareGameWinner(posRope);
            bench.canEndTheGame(endOfMatch);
        } while (!refSite.getEndOfMatch()); 
        refSite.declareMatchWinner();
    }
}
