package clientSide.stubs;

import clientSide.entities.*;
import commInfra.*;
import genclass.GenericIO;

/**
 *  Stub to the playground.
 *
 *    It instantiates a remote reference to the playground.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class PlayGroundStub {
    private String serverHostName = null;
    private int serverPortNumb;

    public PlayGroundStub(String hostName, int port) {
        this.serverHostName = hostName;
        this.serverPortNumb = port;
    }

    /**
     * Operation getReady.
     * 
     * It is called by the contestants to get ready to play and notify the coaches
     * that they are ready.
     */
    public void getReady() {
        ClientCom com; // communication channel
        Message outMessage, // outgoing message
                inMessage; // incoming message

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) // waits for a connection to be established
        {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        // form 4 - int int int int
        outMessage = new Message(
                MessageType.REQGETREADY,
                ((Contestant) Thread.currentThread()).getContestantId(),
                ((Contestant) Thread.currentThread()).getContestantState(),
                ((Contestant) Thread.currentThread()).getStrength());
        // GenericIO.writelnString("GetReady > Server");

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > GetReady");
        // else
        //     GenericIO.writelnString("Server > GetReady");

        if (inMessage.getMsgType() != MessageType.GETREADYDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid Type in getReady()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getContestantId() != ((Contestant) Thread.currentThread()).getContestantId()) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid contestant id in getReady()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getContestantState() != ContestantState.DO_YOUR_BEST) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid contestant state in getReady()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        //GenericIO.writelnString("Contestant " + ((Contestant) Thread.currentThread()).getContestantId() + " are ready in stub!");
        com.close();
        ((Contestant) Thread.currentThread()).setContestantState(inMessage.getContestantState());
    }

    /**
     * Operation informReferee.
     * 
     * It is called by the coaches to inform the referee that the teams are ready to
     * proceed.
     */

    public void informReferee() {
        ClientCom com; // communication channel
        Message outMessage, // outgoing message
                inMessage; // incoming message

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) // waits for a connection to be established
        {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }
        // form 3 - int int int
        outMessage = new Message(
                MessageType.REQINFORMREFEREE,
                ((Coach) Thread.currentThread()).getCoachId(),
                ((Coach) Thread.currentThread()).getCoachState());

        //GenericIO.writelnString("InformReferee > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > InformReferee");
        // else
        //     GenericIO.writelnString("Server >  InformReferee");

        if (inMessage.getMsgType() != MessageType.INFORMREFEREEDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid Type in informReferee()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getCoachId() != ((Coach) Thread.currentThread()).getCoachId()) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid coach id in informReferee()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getCoachState() != CoachState.WATCH_TRIAL) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid coach state in informReferee()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        //GenericIO.writelnString("Coach "+((Coach) Thread.currentThread()).getCoachId()+" informed Referee in stub!");
        com.close();
        ((Coach) Thread.currentThread()).setCoachState(inMessage.getCoachState());
    }

    /**
     * Operation startTrial.
     * 
     * It is called by the referee to start the trial.
     */

    public void startTrial() {
        ClientCom com; // communication channel
        Message outMessage, // outgoing message
                inMessage; // incoming message

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) // waits for a connection to be established
        {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        // form 2 - int int
        outMessage = new Message(
                MessageType.REQSTARTTRIAL,
                ((Referee) Thread.currentThread()).getRefereeState());

        //GenericIO.writelnString("StartTrial > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > StartTrial");
        // else
        //     GenericIO.writelnString("Server > StartTrial");

        if (inMessage.getMsgType() != MessageType.STARTTRIALDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid Type in startTrial()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getRefereeState() != RefereeState.WAIT_FOR_TRIAL_CONCLUSION) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid referee state in startTrial()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        //GenericIO.writelnString("Referee started the trial in stub!");
        com.close();
        ((Referee) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
    }

    /**
     * Operation amDone.
     * 
     * It is called by the contestants to signal that they have finished playing.
     */

    public void amDone() {
        ClientCom com; // communication channel
        Message outMessage, // outgoing message
                inMessage; // incoming message

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) // waits for a connection to be established
        {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }
        // form 3 - int int int
        outMessage = new Message(
                MessageType.REQAMDONE,
                ((Contestant) Thread.currentThread()).getContestantId(),
                ((Contestant) Thread.currentThread()).getContestantState());
        //GenericIO.writelnString("amDone > Server");

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > amDone");
        // else
        //     GenericIO.writelnString("Server > amDone");

        if (inMessage.getMsgType() != MessageType.AMDONEDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid Type in amDone()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getContestantId() != ((Contestant) Thread.currentThread()).getContestantId()) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid contestant id in amDone()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (Math.abs(inMessage.getContestantState()) > ContestantState.DO_YOUR_BEST) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid contestant state in amDone()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        // GenericIO.writelnString("Contestant " + ((Contestant) Thread.currentThread()).getContestantId() + " is done in stub!");
        com.close();
    }

    /**
     * Operation assertTrialDecision.
     * 
     * It is called by the referee to assert the trial decision.
     * 
     * @return position of the rope
     */

    public int assertTrialDecision() {
        ClientCom com; // communication channel
        Message outMessage, // outgoing message
                inMessage; // incoming message

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) // waits for a connection to be established
        {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }
        // form 2 - int int
        outMessage = new Message(
                MessageType.REQASSERTTRIALDECISION,
                ((Referee) Thread.currentThread()).getRefereeState());

        // GenericIO.writelnString("assertTrialDecision > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > assertTrialDecision");
        // else
        //     GenericIO.writelnString("Server > assertTrialDecision");

        if (inMessage.getMsgType() != MessageType.ASSERTTRIALDECISIONDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid Type in assertTrialDecision()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getRefereeState() != RefereeState.WAIT_FOR_TRIAL_CONCLUSION) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid referee state in assertTrialDecision()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        // GenericIO.writelnString("Referee asserted the trial decision in Stub!");
        com.close();

        return inMessage.getPosRope();
    }

    /**
     * Operation reviewNotes.
     * 
     * It is called by the coaches to review the notes of the contestants and redo
     * the contestant strength queue.
     */

    public void reviewNotes() {
        ClientCom com; // communication channel
        Message outMessage, // outgoing message
                inMessage; // incoming message

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) // waits for a connection to be established
        {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }
        // form 3 - int int int
        outMessage = new Message(
                MessageType.REQREVIEWNOTES,
                ((Coach) Thread.currentThread()).getCoachId(),
                ((Coach) Thread.currentThread()).getCoachState());

        // GenericIO.writelnString("reviewNotes > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > reviewNotes");
        // else
        //     GenericIO.writelnString("Server > reviewNotes");

        if (inMessage.getMsgType() != MessageType.REVIEWNOTESDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid Type in reviewNotes()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getCoachId() != ((Coach) Thread.currentThread()).getCoachId()) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid coach id in reviewNotes()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getCoachState() != CoachState.WAIT_FOR_REFEREE_COMMAND) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid coach state in reviewNotes()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        // GenericIO.writelnString("Coach " + ((Coach) Thread.currentThread()).getCoachId() + " reviewed the notes in stub!");
        com.close();
        ((Coach) Thread.currentThread()).setCoachState(inMessage.getCoachState());
    }

    /**
     * Operation getFinishedGame.
     * 
     * It is called by the referee to check if the game has finished.
     * 
     * @return true if the game has finished, false otherwise
     */

    public boolean getFinishedGame() {
        ClientCom com; // communication channel
        Message outMessage, // outgoing message
                inMessage; // incoming message

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) // waits for a connection to be established
        {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        // form 2 - int int
        outMessage = new Message(
                MessageType.REQGETFINISHEDGAME,
                ((Referee) Thread.currentThread()).getRefereeState());

        //GenericIO.writelnString("getFinishedGame > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > getFinishedGame");
        // else
        //     GenericIO.writelnString("Server > getFinishedGame");

        if (inMessage.getMsgType() != MessageType.GETFINISHEDGAMEDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid Type in getFinishedGame()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        //GenericIO.writelnString("Referee finished the game in stub!");
        com.close();
        ((Referee) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());

        return inMessage.getFinishedGame();
    }

    /**
     * Operation shutdown of the simulation.
     * 
     * New operation.
     */

    public void shutdown() {
        ClientCom com; // communication channel
        Message outMessage, // outgoing message
                inMessage; // incoming message

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.sleep((long) (1000));
            } catch (InterruptedException e) {
            }
        }
        outMessage = new Message(MessageType.SHUT);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SHUTDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": no shutdown!");
            System.exit(1);
        }

        com.close();
    }
}