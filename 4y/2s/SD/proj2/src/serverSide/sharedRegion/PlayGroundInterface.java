package serverSide.sharedRegion;

import clientSide.entities.*;
import commInfra.Message;
import commInfra.MessageException;
import commInfra.MessageType;
import serverSide.entities.PlayGroundClientProxy;
import serverSide.main.SimulPar;

/**
 *  Interface to the PlayGround.
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    PlayGround and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class PlayGroundInterface {

    /**
	 * Reference to the PlayGround.
	 */

    private final PlayGround playground;

    /**
	 * Instantiation of an interface to the PlayGround.
	 *
	 * @param playground reference to the PlayGround
	 */

    public PlayGroundInterface(PlayGround playground) {
        this.playground = playground;
    }

    /**
	 * Processing of the incoming messages.
	 *
	 * Validation, execution of the corresponding method and generation of the
	 * outgoing message.
	 *
	 * @param inMessage service request
	 * @return outMessage service reply
	 * @throws MessageException if the incoming message is not valid
	 */

    public Message processAndReply(Message inMessage) throws MessageException {
        Message outMessage = null; // outgoing message

        /* validation of the incoming message */

        switch (inMessage.getMsgType()) {
            case MessageType.REQGETREADY:
                if ((inMessage.getContestantId() < 0) || (inMessage.getContestantId() >= SimulPar.P))
                    throw new MessageException("Invalid contestant id!", inMessage);
                else if ((inMessage.getContestantState() < ContestantState.SEAT_AT_THE_BENCH)
                        || (inMessage.getContestantState() > ContestantState.DO_YOUR_BEST))
                    throw new MessageException("Invalid contestant state!", inMessage);
                break;

            case MessageType.REQINFORMREFEREE:
                if ((inMessage.getCoachId() < 0) || (inMessage.getCoachId() >= SimulPar.C))
                    throw new MessageException("Invalid coach id!", inMessage);
                else if ((inMessage.getCoachState() < CoachState.WAIT_FOR_REFEREE_COMMAND)
                        || (inMessage.getContestantState() > CoachState.WATCH_TRIAL))
                    throw new MessageException("Invalid coach state!", inMessage);
                break;

            case MessageType.REQSTARTTRIAL:
                if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
                        || (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
                    throw new MessageException("Invalid referee state!", inMessage);
                break;

            case MessageType.REQAMDONE:
                if ((inMessage.getContestantId() < 0) || (inMessage.getContestantId() >= SimulPar.P))
                    throw new MessageException("Invalid contestant id!", inMessage);
                else if ((inMessage.getContestantState() < ContestantState.SEAT_AT_THE_BENCH)
                        || (inMessage.getContestantState() > ContestantState.DO_YOUR_BEST))
                    throw new MessageException("Invalid contestant state!", inMessage);
                break;

            case MessageType.REQASSERTTRIALDECISION:
                if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
                        || (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
                    throw new MessageException("Invalid referee state!", inMessage);
                break;

            case MessageType.REQREVIEWNOTES:
                if ((inMessage.getCoachId() < 0) || (inMessage.getCoachId() >= SimulPar.C))
                    throw new MessageException("Invalid coach id!", inMessage);
                else if ((inMessage.getCoachState() < CoachState.WAIT_FOR_REFEREE_COMMAND)
                        || (inMessage.getCoachState() > CoachState.WATCH_TRIAL))
                    throw new MessageException("Invalid coach state!", inMessage);
                break;

            case MessageType.REQGETFINISHEDGAME:
                if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
                        || (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
                    throw new MessageException("Invalid referee state!", inMessage);
                break;

            case MessageType.SHUT: // check nothing
                break;
            default:
                throw new MessageException("Invalid message type!", inMessage);
        }

        /* processing */
        switch (inMessage.getMsgType()) {
            case MessageType.REQGETREADY:
                ((PlayGroundClientProxy) Thread.currentThread()).setContestantId(inMessage.getContestantId());
                ((PlayGroundClientProxy) Thread.currentThread()).setContestantState(inMessage.getContestantState());
                ((PlayGroundClientProxy) Thread.currentThread()).setStrength(inMessage.getStrength());


                playground.getReady();

                // form 4 - int int int int 
                outMessage = new Message(
                        MessageType.GETREADYDONE,
                        ((PlayGroundClientProxy) Thread.currentThread()).getContestantId(),
                        ((PlayGroundClientProxy) Thread.currentThread()).getContestantState(),
                        ((PlayGroundClientProxy) Thread.currentThread()).getStrength());
                break;

            case MessageType.REQINFORMREFEREE:
                ((PlayGroundClientProxy) Thread.currentThread()).setCoachId(inMessage.getCoachId());
                ((PlayGroundClientProxy) Thread.currentThread()).setCoachState(inMessage.getCoachState());

                playground.informReferee();

                // form 3 - int int int
                outMessage = new Message(
                        MessageType.INFORMREFEREEDONE,
                        ((PlayGroundClientProxy) Thread.currentThread()).getCoachId(),
                        ((PlayGroundClientProxy) Thread.currentThread()).getCoachState());
                break;

            case MessageType.REQSTARTTRIAL:
                ((PlayGroundClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());

                playground.startTrial();

                // form 2 - int int
                outMessage = new Message(
                        MessageType.STARTTRIALDONE,
                        ((PlayGroundClientProxy) Thread.currentThread()).getRefereeState());
                break;

            case MessageType.REQAMDONE:
                ((PlayGroundClientProxy) Thread.currentThread()).setContestantId(inMessage.getContestantId());
                ((PlayGroundClientProxy) Thread.currentThread()).setContestantState(inMessage.getContestantState());

                playground.amDone();

                // form 3 - int int int
                outMessage = new Message(
                        MessageType.AMDONEDONE,
                        ((PlayGroundClientProxy) Thread.currentThread()).getContestantId(),
                        ((PlayGroundClientProxy) Thread.currentThread()).getContestantState());
                break;

            case MessageType.REQASSERTTRIALDECISION:
                ((PlayGroundClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());

                int posRope = playground.assertTrialDecision();

                // form 3 - int int int
                outMessage = new Message(
                        MessageType.ASSERTTRIALDECISIONDONE,
                        ((PlayGroundClientProxy) Thread.currentThread()).getRefereeState(),
                        posRope);
                break;

            case MessageType.REQREVIEWNOTES:
                ((PlayGroundClientProxy) Thread.currentThread()).setCoachId(inMessage.getCoachId());
                ((PlayGroundClientProxy) Thread.currentThread()).setCoachState(inMessage.getCoachState());

                playground.reviewNotes();

                // form 3 - int int int
                outMessage = new Message(
                        MessageType.REVIEWNOTESDONE,
                        ((PlayGroundClientProxy) Thread.currentThread()).getCoachId(),
                        ((PlayGroundClientProxy) Thread.currentThread()).getCoachState());

                break;

            case MessageType.REQGETFINISHEDGAME:
                ((PlayGroundClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());

                boolean finishedGame = playground.getFinishedGame();
                // form 3 - int int boolean
                outMessage = new Message(
                        MessageType.GETFINISHEDGAMEDONE,
                        ((PlayGroundClientProxy) Thread.currentThread()).getRefereeState(),
                        finishedGame);

                break;

            case MessageType.SHUT:
                playground.shutdown();
                outMessage = new Message(
                        MessageType.SHUTDONE);
                break;
        }

        return (outMessage);
    }

}
