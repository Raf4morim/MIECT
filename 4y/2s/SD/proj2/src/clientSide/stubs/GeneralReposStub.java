package clientSide.stubs;

import commInfra.*;
import genclass.GenericIO;

/**
 *  Stub to the general repository.
 *
 *    It instantiates a remote reference to the general repository.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class GeneralReposStub {
    private String serverHostName = null;
    private int serverPortNumb;

    public GeneralReposStub(String hostName, int port) {
        this.serverHostName = hostName;
        this.serverPortNumb = port;
    }

    /**
     * Set coach state.
     * 
     * @param id    coach identification
     * @param state coach state
     */

    public void setCoachState(int id, int state) {
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
                MessageType.SETCOACHSTATE,
                id,
                state);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Coach state was not set.");
            GenericIO.writelnString(inMessage.toString());
            System.exit(1);
        }

        com.close();
    }

    /**
     * Set contestant state.
     * 
     * @param id    contestant identification
     * @param state contestant state
     */

    public void setContestantState(int id, int state) {
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
                MessageType.SETCONTESTANTSTATE,
                id,
                state);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Contestant state was not set.");
            GenericIO.writelnString(inMessage.toString());
            System.exit(1);
        }

        com.close();
    }

    /**
     * Set contestant state and strength.
     * 
     * @param id       contestant identification
     * @param state    contestant state
     * @param strength contestant strength
     * @param teamID   team identification
     */

    public void setContestantStateAndStrength(int id, int state, int strength, int teamID) {
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
        // form 5 - int int int int int
        outMessage = new Message(
                MessageType.SETCONTESTANTSTATEANDSTRENGTH,
                id,
                state,
                strength,
                teamID);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString(
                    "Thread " + Thread.currentThread().getName() + ": Contestant state and strength were not set.");
            System.exit(1);
        }

        com.close();
    }

    /**
     * Set referee state.
     * 
     * @param state referee state
     */

    public void setRefereeState(int state) {
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
                MessageType.SETREFEREESTATE,
                state);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Referee state was not set.");
            System.exit(1);
        }

        com.close();
    }

    /**
     * Set referee state and number of games.
     * 
     * @param state  referee state
     * @param nGames number of games
     */

    public void setRefereeStateAndNGames(int state, int nGames) {
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
                MessageType.SETREFEREESTATEANDNGAMES,
                state,
                nGames);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString(
                    "Thread " + Thread.currentThread().getName() + ": Referee state and number of games were not set.");
            System.exit(1);
        }

        com.close();
    }

    /**
     * Set referee state and match winner.
     * 
     * @param state       referee state
     * @param matchWinner match winner
     * @param score0      score of team 0
     * @param score1      score of team 1
     */

    public void setRefereeStateAndMatchWinner(int state, int matchWinner, int score0, int score1) {
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

        // form 5 - int int int int int
        outMessage = new Message(
                MessageType.SETREFEREESTATEANDMATCHWINNER,
                state,
                matchWinner,
                score0,
                score1);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString(
                    "Thread " + Thread.currentThread().getName() + ": Referee state and match winner were not set.");
            System.exit(1);
        }

        com.close();

    }

    /**
     * Set position of the rope.
     * 
     * @param posRope position of the rope
     */

    public void setPosRope(int posRope) {
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
                MessageType.SETPOSROPE,
                posRope);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString(
                    "Thread " + Thread.currentThread().getName() + ": Position of the rope was not set.");
            System.exit(1);
        }

        com.close();

    }

    /**
     * Set number of trials.
     * 
     * @param nTrials number of trials
     */

    public void setNTrials(int nTrials) {
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
                MessageType.SETNTRIALS,
                nTrials);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Number of trials was not set.");
            System.exit(1);
        }

        com.close();

    }

    /**
     * Set number of winner of the game.
     * 
     * @param gameWinner winner of the game
     */
    public void setGameWinner(int gameWinner) {
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
                MessageType.SETGAMEWINNER,
                gameWinner);

        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.SACK) {
            GenericIO.writelnString("Thread " + Thread.currentThread().getName() + ": Game winner was not set.");
            System.exit(1);
        }

        com.close();
    }

    /**
     * Operation initialization of the simulation.
     *
     * @param fileName logging file name
     * @param nIter    number of iterations of the customer life cycle
     */

    public void initSimul(String fileName) {
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
        // GenericIO.writelnString("Simulation has started on GeneralRepos!");
        // form 2 - int String
        outMessage = new Message(
                MessageType.SETNFIC,
                fileName);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // if (inMessage == null) {
        //     GenericIO.writelnString("Server (null) > initSimul");
        // }

        if (inMessage.getMsgType() != MessageType.NFICDONE) {
            GenericIO.writelnString("Simulation was not initialized!");
            System.exit(1);
        }

        com.close();
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