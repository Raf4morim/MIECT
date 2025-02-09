package serverSide.entities;

import java.util.List;
import clientSide.entities.*;
import commInfra.Message;
import commInfra.ServerCom;
import commInfra.MessageException;
import genclass.GenericIO;
import serverSide.sharedRegion.BenchInterface;

/**
 * Service provider agent for access to the Bench.
 *
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public class BenchClientProxy extends Thread implements CoachCloning, ContestantCloning, RefereeCloning {

    /**
     * Coach and team identification.
     */

    private int teamId; 

    /**
     * Coach state.
     */

    private int coachState;

    /**
     * Contestant identification.
     */

    private int contestantId;

    /**
     * Contestant state.
     */

    private int contestantState;

    /**
     * Boolean flag that indicates if the contestant is playing.
     */

    private boolean isPlaying;

    /**
     * Contestant strength.
     */

    private int strength;

    /**
     *  Number of instantiated threads.
     */

    private static int nProxy = 0;

    /**
     *  Full team members identifications.
     */
    private List<Integer> fullTeamMembersIDs;

    /**
     *  Coaches identifications.
     */
    private List<Integer> coachIds;

    /**
     * Contestants identifications.
     */

    private List<Integer> contestantIds;

    /**
     * Referee state.
     */

    private int refereeState;

    /**
     *  Communication channel.
     */   

    private ServerCom sconi;

    /**
     *  Interface to the Bench.
     */    
    private BenchInterface benchInterface;

    /*-------------------------------*/
    /* On REFEREE CLONING */
    /*-------------------------------*/

    /**
     * Set referee state.
     * 
     * @param state new referee state
     */

    public void setRefereeState(int state) {
        refereeState = state;
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
     * Add a coach Id to the list of coaches Ids.
     * 
     * @param coach the coach to add
     */

    public void addCoach(int coachId) {
        coachIds.add(coachId);
    }

    /*
     * Add a contestant to the list of contestants ids.
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

    /*-------------------------------*/
    /* On COACH CLONING */
    /*-------------------------------*/

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

    public List<Integer> fullTeamIDs() {
        return fullTeamMembersIDs;
    }

    /*-------------------------------*/
    /* On CONTESTANT CLONING */
    /*-------------------------------*/

    /**
     * Set contestant id.
     * 
     * @param id contestant id
     */

    public void setContestantId(int id) {
        this.contestantId = id;
    }

    /**
     * Get contestant id.
     * 
     * @return contestant id
     */

    public int getContestantId() {
        return contestantId;
    }

    /**
     * Set contestant state.
     * 
     * @param state new contestant state
     */

    public void setContestantState(int state) {
        contestantState = state;
    }

    /**
     * Get contestant state.
     * 
     * @return contestant state
     */

    public int getContestantState() {
        return contestantState;
    }

    /**
     * Set contestant strength.
     * 
     * @param strength contestant strength
     */

    public void setStrength(int strength) {
        this.strength = strength;
    }

    /**
     * Get contestant strength.
     * 
     * @return contestant strength
     */

    public int getStrength() {
        return strength;
    }

    /**
     * Set if the contestant is playing.
     * 
     * @param isPlaying boolean flag that indicates if the contestant is playing
     */

    public void setIsPlaying(boolean isPlaying) {
        this.isPlaying = isPlaying;
    }

    /**
     * Get if the contestant is playing.
     * 
     * @return boolean flag that indicates if the contestant is playing
     */

    public boolean getIsPlaying() {
        return isPlaying;
    }

    /**
     * Get team id of the contestant.
     * 
     * @return team id
     */

    public int getTeamId() {
        return teamId;
    }

    /**
     *  Instantiation of a client proxy.
     *
     *     @param sconi communication channel
     *     @param benchInterface interface to the bench
     */

    public BenchClientProxy(ServerCom sconi, BenchInterface benchInterface) {
        super("BenchProxy" + BenchClientProxy.getProxyId());
        this.sconi = sconi;
        this.benchInterface = benchInterface;
    }

    /**
     *  Generation of the instantiation identifier.
     *
     *     @return instantiation identifier
     */

    private static int getProxyId() {
        Class<?> cl = null; // representation of the BenchClientProxy object in JVM
        int proxyId; // instantiation identifier

        try {
            cl = Class.forName("serverSide.entities.BenchClientProxy");
        } catch (ClassNotFoundException e) {
            GenericIO.writelnString("Data type BenchClientProxy was not found!");
            e.printStackTrace();
            System.exit(1);
        }
        synchronized (cl) {
            proxyId = nProxy;
            nProxy += 1;
        }
        return proxyId;
    }

    /**
     *  Life cycle of the service provider agent.
     */

    @Override
    public void run() {
        Message inMessage = null, // service request
                outMessage = null; // service reply

        /* service providing */

        inMessage = (Message) sconi.readObject(); // get service request
        try {
            outMessage = benchInterface.processAndReply(inMessage); // process it
        } catch (MessageException e) {
            GenericIO.writelnString("Thread " + getName() + ": " + e.getMessage() + "!");
            GenericIO.writelnString(e.getMessageVal().toString());
            System.exit(1);
        }
        sconi.writeObject(outMessage); // send service reply
        sconi.close(); // close the communication channel
    }
}
