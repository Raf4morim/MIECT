package serverSide.sharedRegion;

import clientSide.entities.*;
import commInfra.Message;
import commInfra.MessageException;
import commInfra.MessageType;
import serverSide.main.SimulPar;

/**
 *  Interface to the General Repository of Information.
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    General Repository and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class GeneralReposInterface {

	/**
	 * Reference to the general repository.
	 */

	private final GeneralRepos repos;

	/**
	 * Instantiation of an interface to the general repository.
	 *
	 * @param repos reference to the general repository
	 */

	public GeneralReposInterface(GeneralRepos repos) {
		this.repos = repos;
	}

	/**
	 *  Processing of the incoming messages.
	 *
	 *  Validation, execution of the corresponding method and generation of the outgoing message.
	 *
	 *    @param inMessage service request
	 *    @return service reply
	 *    @throws MessageException if the incoming message is not valid
	 */

	public Message processAndReply(Message inMessage) throws MessageException {
		Message outMessage = null; // outgoing message

		/* validation of the incoming message */

		switch (inMessage.getMsgType()) {
			case MessageType.SETNFIC:
				if (inMessage.getLogFName() == null)
					throw new MessageException("Invalid log file name!", inMessage);
				break;

			case MessageType.SETPOSROPE:
				break;

			case MessageType.SETCOACHSTATE:
				if ((inMessage.getCoachId() < 0) || (inMessage.getCoachId() > SimulPar.C))
					throw new MessageException("Invalid coach id!", inMessage);
				else if ((inMessage.getCoachState() < CoachState.WAIT_FOR_REFEREE_COMMAND)
						|| (inMessage.getCoachState() > CoachState.WATCH_TRIAL))
					throw new MessageException("Invalid coach state!", inMessage);
				break;

			case MessageType.SETCONTESTANTSTATE:
				if ((inMessage.getContestantId() < 0) || (inMessage.getContestantId() > SimulPar.P))
					throw new MessageException("Invalid contestant id!", inMessage);
				else if ((inMessage.getContestantState() < ContestantState.SEAT_AT_THE_BENCH)
						|| (inMessage.getContestantState() > ContestantState.DO_YOUR_BEST))
					throw new MessageException("Invalid contestant state!", inMessage);
				break;

			case MessageType.SETCONTESTANTSTATEANDSTRENGTH:
				if ((inMessage.getContestantId() < 0) || (inMessage.getContestantId() > SimulPar.P))
					throw new MessageException("Invalid contestant id!", inMessage);
				else if ((inMessage.getContestantState() < ContestantState.SEAT_AT_THE_BENCH)
						|| (inMessage.getContestantState() > ContestantState.DO_YOUR_BEST))
					throw new MessageException("Invalid contestant state!", inMessage);
				else if ((inMessage.getStrength() < 0) || (inMessage.getStrength() > 10))
					throw new MessageException("Invalid strength!", inMessage);
				break;

			case MessageType.SETREFEREESTATE:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				break;

			case MessageType.SETNTRIALS:
				if ((inMessage.getNTrials() < 0) || (inMessage.getNTrials() > SimulPar.T))
					throw new MessageException("Invalid number of trials!", inMessage);
				break;

			case MessageType.SETREFEREESTATEANDNGAMES:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				else if ((inMessage.getNGames() < 0) || (inMessage.getNGames() > SimulPar.G))
					throw new MessageException("Invalid number of games!", inMessage);
				break;

			case MessageType.SETREFEREESTATEANDMATCHWINNER:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				else if ((inMessage.getNGames() < 0) || (inMessage.getNGames() > 3))
					throw new MessageException("Invalid match winner!", inMessage);
				else if ((inMessage.getScore0() < 0) || (inMessage.getScore0() > 3))
					throw new MessageException("Invalid score team 0!", inMessage);
				else if ((inMessage.getScore1() < 0) || (inMessage.getScore1() > 3))
					throw new MessageException("Invalid score team 1!", inMessage); 
				break;

			case MessageType.SETGAMEWINNER:
				if ((inMessage.getGameWinner() < 0) || (inMessage.getGameWinner() > 2))
					throw new MessageException("Invalid game winner!", inMessage);
				break;


			case MessageType.SHUT: // check nothing
				break;
			default:
				throw new MessageException("Invalid message type!", inMessage);
		}

		/* processing */

		switch (inMessage.getMsgType()) {
			case MessageType.SETNFIC:
				repos.initSimul(inMessage.getLogFName());
				outMessage = new Message(MessageType.NFICDONE);
				break;

			case MessageType.SETPOSROPE:
				repos.setPosRope(inMessage.getPosRope());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SETCOACHSTATE:
				repos.setCoachState(inMessage.getCoachId(), inMessage.getCoachState());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SETCONTESTANTSTATE:
				repos.setContestantState(inMessage.getContestantId(), inMessage.getContestantState());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SETCONTESTANTSTATEANDSTRENGTH:
				repos.setContestantStateAndStrength(inMessage.getContestantId(), inMessage.getContestantState(),
						inMessage.getStrength(), inMessage.getCoachId());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SETREFEREESTATE:
				repos.setRefereeState(inMessage.getRefereeState());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SETREFEREESTATEANDNGAMES:
				repos.setRefereeStateAndNGames(inMessage.getRefereeState(), inMessage.getNGames());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SETREFEREESTATEANDMATCHWINNER:
				repos.setRefereeStateAndMatchWinner(inMessage.getRefereeState(), inMessage.getMatchWinner(),
						inMessage.getScore0(), inMessage.getScore1());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SETGAMEWINNER:
				repos.setGameWinner(inMessage.getGameWinner());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SETNTRIALS:
				repos.setNTrials(inMessage.getNTrials());
				outMessage = new Message(MessageType.SACK);
				break;

			case MessageType.SHUT:
				repos.shutdown();
				outMessage = new Message(MessageType.SHUTDONE);
				break;
		}
		return (outMessage);
	}

}
