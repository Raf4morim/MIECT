package clientSide.stubs;

import clientSide.entities.*;
import commInfra.*;
import genclass.GenericIO;

/**
 *  Stub to the referee site.
 *
 *    It instantiates a remote reference to the referee site.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class RefereeSiteStub {

    private String serverHostName = null;
    private int serverPortNumb;

    public RefereeSiteStub(String hostName, int port) {
        this.serverHostName = hostName;
        this.serverPortNumb = port;
    }

    /**
     * Operation announce new game.
     * 
     * It is called by the referee to announce a new game on the start of the match
     * or after a game ends.
     * 
     */

    public void announceNewGame() {
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
                MessageType.REQANNOUNCENEWGAME, // message type
                ((Referee) Thread.currentThread()).getRefereeState() // referee state
        );

        //GenericIO.writelnString("announceNewGame > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > announceNewGame");
        // else
        //     GenericIO.writelnString("Server > announceNewGame");

        if (inMessage.getMsgType() != MessageType.ANNOUNCENEWGAMEDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid type in announceNewGame()!");
            System.exit(1);
        }
        //GenericIO.writelnString("Referee announceNewGame in stub");
        com.close();
        ((Referee) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
    }

    /**
     * Operation declare game winner.
     * 
     * It is called by the referee after a game has come to an end (either by trials
     * or KO);
     * determines the winner of the game using the position of the rope.
     * 
     * @param posRope position of the rope at the end of the game
     * @return end of the match flag
     */

    public boolean declareGameWinner(int posRope) {
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
                MessageType.REQDECLAREGAMEWINNER,
                ((Referee) Thread.currentThread()).getRefereeState(),
                posRope
        );

        // GenericIO.writelnString("declareGameWinner > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > declareGameWinner");
        // else
        //     GenericIO.writelnString("Server > declareGameWinner");

        if (inMessage.getMsgType() != MessageType.DECLAREGAMEWINNERDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid type in declareGameWinner()!");
            System.exit(1);
        }

        // GenericIO.writelnString("Referee declareGameWinner in stub");
        com.close();
        ((Referee) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
        return inMessage.getEndOfMatch();
    }

    /**
     * Operation declare match winner.
     * 
     * It is called by the referee after all games have been played;
     * determines the winner of the match by comparing the scores of the teams.
     *
     */

    public void declareMatchWinner() {
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
                MessageType.REQDECLAREMATCHWINNER, 
                ((Referee) Thread.currentThread()).getRefereeState() 
        );

        // GenericIO.writelnString("declareMatchWinner > Server");
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();
        // if (inMessage == null)
        //     GenericIO.writelnString("Server (null) > declareMatchWinner");
        // else
        //     GenericIO.writelnString("Server > declareMatchWinner");

        if (inMessage.getMsgType() != MessageType.DECLAREMATCHWINNERDONE) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid type in declareMatchWinner()!");
            System.exit(1);
        }

        //GenericIO.writelnString("Referee declare MatchWinner stub!");
        com.close();
        ((Referee) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
    }

    /**
     * Operation getEndOfMatch.
     * 
     * It is called by the referee to check if the match has finished.
     * 
     * @return true if the match has finished, false otherwise
     */

    public boolean getEndOfMatch() {
        ClientCom com; // communication channel
		Message outMessage, inMessage; // // outgoing, incoming message

		com = new ClientCom(serverHostName, serverPortNumb);
		while (!com.open()) // waits for a connection to be established
		{
			try {
				Thread.currentThread().sleep((long) (10));
			} catch (InterruptedException e) {
			}
		}

        if(Thread.currentThread() instanceof Referee){
            outMessage = new Message(MessageType.REQENDOFMATCHREFEREE, ((Referee) Thread.currentThread()).getRefereeState());
            // GenericIO.writelnString("declareMatchWinner - Referee > Server");

            com.writeObject(outMessage);
            inMessage = (Message) com.readObject();

            // if (inMessage == null) {
            //     GenericIO.writelnString("Server (null) > declareMatchWinner - Referee");
            // } else {
            //     GenericIO.writelnString("Server > declareMatchWinner - Referee");
            // }

            if (inMessage.getMsgType() != MessageType.ENDOFMATCHREFEREEDONE) {
                GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid message type in getEndOfMatch!");
                GenericIO.writelnString (inMessage.toString ());
                System.exit(1);
            }

            com.close();
            // GenericIO.writelnString("getEndOfMatch - Referee: Flag EndOfMatch? " + inMessage.getEndOfMatch());
            return inMessage.getEndOfMatch();

        } else if(Thread.currentThread() instanceof Coach){
            outMessage = new Message(MessageType.REQENDOFMATCHCOACH,((Coach)Thread.currentThread()).getCoachId() ,((Coach) Thread.currentThread()).getCoachState());
            //GenericIO.writelnString("declareMatchWinner - Coach > Server");

            com.writeObject(outMessage);
            inMessage = (Message) com.readObject();

            // if (inMessage == null) {
            //     GenericIO.writelnString("Server (null) > declareMatchWinner - Coach");
            // } else {
            //     GenericIO.writelnString("Server > declareMatchWinner - Coach");
            // }

            if (inMessage.getMsgType() != MessageType.ENDOFMATCHCOACHDONE) {
                GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid message type in getEndOfMatch!");
                GenericIO.writelnString (inMessage.toString ());
                System.exit(1);
            }

            //GenericIO.writelnString("getEndOfMatch - Coach: Flag EndOfMatch? " + inMessage.getEndOfMatch());
            com.close();

            return inMessage.getEndOfMatch();
        } else {
            outMessage = new Message(MessageType.REQENDOFMATCHCONTESTANT,((Contestant)Thread.currentThread()).getContestantId() ,((Contestant) Thread.currentThread()).getContestantState());
            // GenericIO.writelnString("declareMatchWinner - Coach > Server");

            com.writeObject(outMessage);
            inMessage = (Message) com.readObject();

            // if (inMessage == null) {
            //     GenericIO.writelnString("Server (null) > declareMatchWinner - Contestant");
            // } else {
            //     GenericIO.writelnString("Server > declareMatchWinner - Contestant");
            // }

            if (inMessage.getMsgType() != MessageType.ENDOFMATCHCONTESTANTDONE) {
                GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Invalid message type in getEndOfMatch!");
                GenericIO.writelnString (inMessage.toString ());
                System.exit(1);
            }
            
            //GenericIO.writelnString("getEndOfMatch - Contestant: Flag EndOfMatch? " + inMessage.getEndOfMatch());
            com.close();
            return inMessage.getEndOfMatch();
        }
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