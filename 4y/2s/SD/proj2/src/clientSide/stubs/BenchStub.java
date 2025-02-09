package clientSide.stubs;

import clientSide.entities.*;
import commInfra.*;
import genclass.GenericIO;

/**
 *  Stub to the bench.
 *
 *    It instantiates a remote reference to the bench.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class BenchStub {
    /**
     * Name of the platform where is located the bench server.
     */

    private String serverHostName;

    /**
     * Port number for listening to service requests.
     */

    private int serverPortNumb;

    /**
     * Instantiation of a stub to the bench.
     *
     * @param serverHostName name of the platform where is located the bench server
     * @param serverPortNumb port number for listening to service requests
     */

    public BenchStub(String serverHostName, int serverPortNumb) {
        this.serverHostName = serverHostName;
        this.serverPortNumb = serverPortNumb;
    }

    /**
     * Operation callTrial.
     * 
     * It is called by the referee to wake up the coaches to select the next team.
     */

    public void callTrial() {
        ClientCom com;      // communication channel
        Message outMessage, // outgoing message
                inMessage;  // incoming message

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
                MessageType.REQCALLTRIAL,
                ((Referee) Thread.currentThread()).getRefereeState()
        );
        //GenericIO.writelnString("Call Trial > Server");

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null) {
        //     GenericIO.writelnString("Server (null) > CallTrial");
        // } else {
        //     GenericIO.writelnString("Server > CallTrial");
        // }

        if (inMessage.getMsgType() != MessageType.CALLTRIALDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid message type in callContestants()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getRefereeState() != RefereeState.TEAMS_READY) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid referee state in callContestants()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        // GenericIO.writelnString("Referee called trial");
        com.close();
        ((Referee) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
    }

    /**
     * Operation callContestants.
     * 
     * It is called by the coaches to select the next team and wake up the selected
     * contestants to play.
     * Increments the strength of the players that were not selected to play.
     * 
     */

    public void callContestants() {
        ClientCom com;      // communication channel
        Message outMessage, // outgoing message
                inMessage;  // incoming message

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
                MessageType.REQCALLCONTESTANTS,
                ((Coach) Thread.currentThread()).getCoachId(),
                ((Coach) Thread.currentThread()).getCoachState() 
        );
        //GenericIO.writelnString("CallContestants > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // if (inMessage == null) {
        //     GenericIO.writelnString("Server (null) > CallContestants");
        // } else {
        //     GenericIO.writelnString("Server > CallContestants");
        // }

        if (inMessage.getMsgType() != MessageType.CALLCONTESTANTSDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid message type in callContestants()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getCoachState() > CoachState.ASSEMBLE_TEAM){
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid coach state in callContestants()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getCoachId() < 0 || inMessage.getCoachId() > 1) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid coach id in callContestants()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        //GenericIO.writelnString("Coach " + ((Coach) Thread.currentThread()).getCoachId() + "Called");
        com.close();
        ((Coach) Thread.currentThread()).setCoachState(inMessage.getCoachState());
    }

    /**
     * Operation followCoachAdvice.
     * 
     * It is called by a contestant to follow the coach advice and stand in
     * position.
     *
     */

    public void followCoachAdvice() {
        ClientCom com;      // communication channel
        Message outMessage, // outgoing message
                inMessage;  // incoming message

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
                MessageType.REQFOLLOWCOACHADVICE,
                ((Contestant) Thread.currentThread()).getContestantId(),
                ((Contestant) Thread.currentThread()).getContestantState(),
                ((Contestant) Thread.currentThread()).getStrength()
        );

        // GenericIO.writelnString("FollowCoachAdvice > Server: ");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // if (inMessage == null) {
        //     GenericIO.writelnString("Server (null) > FollowCoachAdvice");
        // } else {
        //     GenericIO.writelnString("Server > FollowCoachAdvice");
        // }

        if (inMessage.getMsgType() != MessageType.FOLLOWCOACHADVICEDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid message type in followCoachAdvice()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getContestantState() != ContestantState.STAND_IN_POSITION) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName()+ ": Invalid contestant state in followCoachAdvice()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getContestantId() != ((Contestant) Thread.currentThread()).getContestantId()) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid contestant id in followCoachAdvice()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        // GenericIO.writelnString(
        //         "Contestant " + ((Contestant) Thread.currentThread()).getContestantId() + " followed advice");
        com.close();
        ((Contestant) Thread.currentThread()).setContestantState(inMessage.getContestantState());
    }

    /**
     * Operation seatDown.
     * 
     * It is called by a contestant to seat down and wait until he is selected by
     * the coach to play.
     * 
     */

    public void seatDown() {
        // GenericIO.writelnString("SeatDown > Contestant: " + ((Contestant) Thread.currentThread()).getContestantId());
        ClientCom com;      // communication channel
        Message outMessage, // outgoing message
                inMessage;  // incoming message

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
                MessageType.REQSEATDOWN,
                ((Contestant) Thread.currentThread()).getContestantId(),
                ((Contestant) Thread.currentThread()).getContestantState(),
                ((Contestant) Thread.currentThread()).getStrength() 
        );

        // GenericIO.writelnString("SeatDown > Server ->  Player: " + ((Contestant) Thread.currentThread()).getContestantId());
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null) {
        //     GenericIO.writelnString("Server (null) > SeatDown");
        // } else {
        //     GenericIO.writelnString("Server > SeatDown");
        // }

        if (inMessage.getMsgType() != MessageType.SEATDOWNDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid message type in seatDown()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getContestantState() != ContestantState.SEAT_AT_THE_BENCH) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid contestant state in seatDown()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getContestantId() != ((Contestant) Thread.currentThread()).getContestantId()) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid contestant id in seatDown()!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        // GenericIO.writelnString(
        //         "Contestant " + ((Contestant) Thread.currentThread()).getContestantId() + " seated down");
        com.close();
        ((Contestant) Thread.currentThread()).setContestantState(inMessage.getContestantState());
        ((Contestant) Thread.currentThread()).setStrength(inMessage.getStrength());
    }

    /**
     * Operation canEndTheGame.
     * 
     * It is called by the Referee to wait for all players to seat down and wake
     * both contestants and coaches to finish the match.
     * 
     * @param endOfMatch boolean flag that indicates if the match has ended
     */

    public void canEndTheGame(boolean endOfMatch) {
        ClientCom com;      // communication channel
        Message outMessage, // outgoing message
                inMessage;  // incoming message
        

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) // waits for a connection to be established
        {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        // form 3 - int int boolean
        outMessage = new Message(
                MessageType.REQCANENDTHEGAME,
                ((Referee) Thread.currentThread()).getRefereeState(),
                endOfMatch);

        //GenericIO.writelnString("canEndTheGame > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null) {
        //     GenericIO.writelnString("Server (null) > canEndTheGame");
        // } else {
        //     GenericIO.writelnString("Server > canEndTheGame");
        // }

        if (inMessage.getMsgType() != MessageType.CANENDTHEGAMEDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }
        if (inMessage.getRefereeState() != RefereeState.END_OF_A_GAME) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid referee state!");
            GenericIO.writelnString (inMessage.toString ());
            System.exit(1);
        }

        com.close();
        ((Referee) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
    }

    /**
     * Operation server shutdown.
     *
     * New operation.
     */

    public void shutdown() {
        ClientCom com;      // communication channel
        Message outMessage, // outgoing message
                inMessage;  // incoming message

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