package serverSide.sharedRegion;

import clientSide.entities.*;
import commInfra.Message;
import commInfra.MessageException;
import commInfra.MessageType;
import serverSide.entities.RefereeSiteClientProxy;
import serverSide.main.SimulPar;

/**
 *  Interface to the Referee Site.
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    Referee Site and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class RefereeSiteInterface {
	/**
	 * Reference to the referee site.
	 */

	private final RefereeSite refereeSite;

	/**
	 * Instantiation of an interface to the referee site.
	 *
	 * @param refereeSite reference to the referee site
	 */

	public RefereeSiteInterface(RefereeSite refereeSite) {
		this.refereeSite = refereeSite;
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
			case MessageType.REQANNOUNCENEWGAME:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				break;

			case MessageType.REQDECLAREGAMEWINNER:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				break;

			case MessageType.REQDECLAREMATCHWINNER:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				break;

			case MessageType.REQENDOFMATCHREFEREE:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				break;

			case MessageType.REQENDOFMATCHCOACH:
				if ((inMessage.getCoachId() < 0) || (inMessage.getCoachId() > SimulPar.C))
					throw new MessageException("Invalid coach id!", inMessage);
				else if ((inMessage.getCoachState() < CoachState.WAIT_FOR_REFEREE_COMMAND)
						|| (inMessage.getCoachState() > CoachState.WATCH_TRIAL))
					throw new MessageException("Invalid coach state!", inMessage);
				break;

			case MessageType.REQENDOFMATCHCONTESTANT:
				if ((inMessage.getContestantId() < 0) || (inMessage.getContestantId() > SimulPar.P))
					throw new MessageException("Invalid contestant id!", inMessage);
				else if ((inMessage.getContestantState() < ContestantState.SEAT_AT_THE_BENCH)
						|| (inMessage.getContestantState() > ContestantState.DO_YOUR_BEST))
					throw new MessageException("Invalid contestant state!", inMessage);
				break;

			case MessageType.SHUT: // check nothing
				break;
			default:
				throw new MessageException("Invalid message type!", inMessage);
		}

		/* processing */

		switch (inMessage.getMsgType()) {
			case MessageType.REQANNOUNCENEWGAME:
				((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
				refereeSite.announceNewGame();
				// form 2 - int int
				outMessage = new Message(
						MessageType.ANNOUNCENEWGAMEDONE,
						((RefereeSiteClientProxy) Thread.currentThread()).getRefereeState());
				break;

			case MessageType.REQDECLAREGAMEWINNER:
				((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
				boolean endOfGame = refereeSite.declareGameWinner(inMessage.getPosRope());
				// form 3 - int int boolean
				outMessage = new Message(
					MessageType.DECLAREGAMEWINNERDONE,
						((RefereeSiteClientProxy) Thread.currentThread()).getRefereeState(),
						endOfGame);
				break;

			case MessageType.REQDECLAREMATCHWINNER:
				((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
				refereeSite.declareMatchWinner();
				// form 2 - int int
				outMessage = new Message(
						MessageType.DECLAREMATCHWINNERDONE,
						((RefereeSiteClientProxy) Thread.currentThread()).getRefereeState());
				break;

			case MessageType.REQENDOFMATCHREFEREE:
				((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
				boolean endOfMatch = refereeSite.getEndOfMatch();
				// form 3 - int int boolean
				outMessage = new Message(
						MessageType.ENDOFMATCHREFEREEDONE,
						((RefereeSiteClientProxy) Thread.currentThread()).getRefereeState(),
						endOfMatch);
				break;

			case MessageType.REQENDOFMATCHCOACH:
				((RefereeSiteClientProxy) Thread.currentThread()).setCoachState(inMessage.getCoachState());
				endOfMatch = refereeSite.getEndOfMatch();

				// form 4 - int int int boolean
				outMessage = new Message(
						MessageType.ENDOFMATCHCOACHDONE,
						((RefereeSiteClientProxy) Thread.currentThread()).getCoachId(),
						((RefereeSiteClientProxy) Thread.currentThread()).getCoachState(),
						endOfMatch);
				break;

			case MessageType.REQENDOFMATCHCONTESTANT:
				((RefereeSiteClientProxy) Thread.currentThread()).setContestantState(inMessage.getContestantState());
				endOfMatch = refereeSite.getEndOfMatch();
				// form 4 - int int int boolean
				outMessage = new Message(
						MessageType.ENDOFMATCHCONTESTANTDONE,
						((RefereeSiteClientProxy) Thread.currentThread()).getContestantId(),
						((RefereeSiteClientProxy) Thread.currentThread()).getContestantState(),
						endOfMatch);
				break;


			case MessageType.SHUT:
				refereeSite.shutdown();
				// form 1 - int
				outMessage = new Message(MessageType.SHUTDONE);
				break;

		}
		return (outMessage);
	}
}
