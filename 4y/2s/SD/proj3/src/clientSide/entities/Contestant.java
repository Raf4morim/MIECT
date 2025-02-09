package clientSide.entities;

import interfaces.*;
import java.rmi.*;
import genclass.GenericIO;

/**
 * Contestant thread.
 * 
 * It simulates the contestant life cycle.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on remote calls under Java RMI.
 */

public class Contestant extends Thread {

    /**
     * Contestant identification.
     */

    private int contestantId;

    /**
     * Contestant state.
     */

    private int contestantState;

    /**
     * Contestant strength.
     */

    private int strength;

    /**
     * Reference to the playground.
     */

    private final PlayGroundInterface pGroundStub;

    /**
     * Reference to the bench.
     */

    private final BenchInterface benchStub;

    /**
     * Reference to the referee site.
     */

    private final RefereeSiteInterface refSiteStub;

    /**
     * Instantiation of a contestant thread.
     * 
     * @param name         thread name
     * @param contestantId contestant identification
     * @param teamId       team identification
     * @param strength     contestant strength
     * @param pGroundStub  reference to the playground stub
     * @param benchStub    reference to the bench stub
     * @param refSiteStub  reference to the referee site stub
     */

    public Contestant(String name, int contestantId, int strength, PlayGroundInterface pGroundStub,
            BenchInterface benchStub, RefereeSiteInterface refSiteStub) {
        super(name);
        this.contestantId = contestantId;
        this.strength = strength;
        this.pGroundStub = pGroundStub;
        this.benchStub = benchStub;
        this.refSiteStub = refSiteStub;
        contestantState = ContestantState.SEAT_AT_THE_BENCH;
    }

    /**
     * Set contestant id.
     * 
     * @param id contestant id
     */

    public void setContestantId(int id) {
        contestantId = id;
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
     * Contestant life cycle.
     */

    @Override
    public void run() {
        seatDown();
        while (!getEndOfMatch()) {
            followCoachAdvice();
            System.out.println("1");

            getReady();
            System.out.println("2");

            pullTheRope();
            System.out.println("3");

            amDone();
            System.out.println("4");

            seatDown();
            System.out.println("5");
            System.out.println("getEndOfMatch: "+ getEndOfMatch());
        }
    }

    /**
     * Pull the rope.
     * 
     * Internal operation.
     */

    public void pullTheRope() {
        try {
            sleep((long) (1 + 100 * Math.random()));
        } catch (InterruptedException e) {
        }
    }

    private void seatDown(){
        ReturnInt ret = null;

        try{
			// System.out.println("seatDown:  strengthPerContestant[i]" + strength+" id: " + contestantId);
            ret = benchStub.seatDown(strength, contestantId);
        }catch(RemoteException e){
            GenericIO.writelnString("Contestant "+contestantId+" remote exception on seatDown: "+e.getMessage());
            System.exit(1);
        }
        contestantState = ret.getIntStateVal();
        strength = ret.getIntVal();
    }

    private boolean getEndOfMatch(){
        boolean ret=false;

        try{
            ret= refSiteStub.getEndOfMatch();
        }catch(RemoteException e){
            GenericIO.writelnString("Contestant "+contestantId+" remote exception on getEndOfMatch: "+e.getMessage());
            System.exit(1);
        }
        return ret;
    }

    private void followCoachAdvice(){
        ReturnInt ret = null; 
        try {
            ret = benchStub.followCoachAdvice(strength, contestantId);
        } catch (RemoteException e) {
            GenericIO.writelnString("Contestant "+contestantId+" remote exception on followCoachAdvice: "+e.getMessage());
            System.exit(1);
        }
        contestantState = ret.getIntStateVal();
        strength = ret.getIntVal();
    }

    private void getReady(){
        int ret = -1; 
        try {
            ret = pGroundStub.getReady(strength, contestantId);
        } catch (RemoteException e) {
            GenericIO.writelnString("Contestant "+contestantId+" remote exception on getReady: "+e.getMessage());
            System.exit(1);
        }
        contestantState = ret;
    }

    private void amDone(){
        try {
            pGroundStub.amDone(contestantId);
        } catch (RemoteException e) {
            GenericIO.writelnString("Contestant "+contestantId+" remote exception on amDone: "+e.getMessage());
            System.exit(1);
        }
    }
}