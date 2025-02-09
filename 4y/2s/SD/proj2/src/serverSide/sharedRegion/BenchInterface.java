package serverSide.sharedRegion;

import clientSide.entities.*;
import commInfra.Message;
import commInfra.MessageException;
import commInfra.MessageType;
import genclass.GenericIO;
import serverSide.entities.BenchClientProxy;
import serverSide.main.SimulPar;

/**
 *  Interface to the Bench.
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    Bench and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class BenchInterface {

	/**
	 * Reference to the bench.
	 */

	private final Bench bench;

	/**
	 * Instantiation of an interface to the bench.
	 *
	 * @param bench reference to the bench
	 */

	public BenchInterface(Bench bench) {
		this.bench = bench;
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
			case MessageType.REQCALLTRIAL:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				break;

			case MessageType.REQCALLCONTESTANTS:
				if ((inMessage.getCoachId() < 0 || inMessage.getCoachId() >= SimulPar.C))
					throw new MessageException("Invalid coach id!", inMessage);
				else if ((inMessage.getCoachState() < CoachState.WAIT_FOR_REFEREE_COMMAND)
						|| (inMessage.getCoachState() > CoachState.WATCH_TRIAL))
					throw new MessageException("Invalid coach state!", inMessage);
				break;

			case MessageType.REQFOLLOWCOACHADVICE:
				if ((inMessage.getContestantId() < 0 || inMessage.getContestantId() >= SimulPar.P))
					throw new MessageException("Invalid contestant id follow advice!", inMessage);
				else if ((inMessage.getContestantState() < ContestantState.SEAT_AT_THE_BENCH)
						|| (inMessage.getContestantState() > ContestantState.DO_YOUR_BEST))
					throw new MessageException("Invalid contestant state follow !", inMessage);
				break;

			case MessageType.REQSEATDOWN:
				if ((inMessage.getContestantId() < 0 || inMessage.getContestantId() > SimulPar.P))
					throw new MessageException("Invalid contestant id seat down!", inMessage);
				else if ((inMessage.getContestantState() < ContestantState.SEAT_AT_THE_BENCH)
						|| (inMessage.getContestantState() > ContestantState.DO_YOUR_BEST))
					throw new MessageException("Invalid contestant state seat down!", inMessage);
				break;

			case MessageType.REQCANENDTHEGAME:
				if ((inMessage.getRefereeState() < RefereeState.START_OF_THE_MATCH)
						|| (inMessage.getRefereeState() > RefereeState.WAIT_UNTIL_ALL_SEATED))
					throw new MessageException("Invalid referee state!", inMessage);
				break;

			case MessageType.SHUT:
				break;

			default:
				throw new MessageException("Invalid message type!", inMessage);
		}

		/* processing */

		switch (inMessage.getMsgType()) {
			case MessageType.REQCALLTRIAL:
				//GenericIO.writelnString("BenchInterface - CallTrial starts");
				((BenchClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());

				bench.callTrial();

				// form 2 - int int
				outMessage = new Message(
						MessageType.CALLTRIALDONE,
						((BenchClientProxy) Thread.currentThread()).getRefereeState());
				//GenericIO.writelnString("BenchInterface - CallTrial ends");
				break;

			case MessageType.REQCALLCONTESTANTS:
				// GenericIO.writelnString("BenchInterface - CallContestant starts");
				((BenchClientProxy) Thread.currentThread()).setCoachId(inMessage.getCoachId());
				((BenchClientProxy) Thread.currentThread()).setCoachState(inMessage.getCoachState());

				bench.callContestants();

				// form 3 - int int int
				outMessage = new Message(
						MessageType.CALLCONTESTANTSDONE,
						((BenchClientProxy) Thread.currentThread()).getCoachId(),
						((BenchClientProxy) Thread.currentThread()).getCoachState());
				// GenericIO.writelnString("BenchInterface - CallContestant ends");
				break;

			case MessageType.REQFOLLOWCOACHADVICE:
				// GenericIO.writelnString("BenchInterface - FollowCoachAdvice starts");
				((BenchClientProxy) Thread.currentThread()).setContestantId(inMessage.getContestantId());
				((BenchClientProxy) Thread.currentThread()).setContestantState(inMessage.getContestantState());
				((BenchClientProxy) Thread.currentThread()).setStrength(inMessage.getStrength());


				bench.followCoachAdvice();

				// form 4 - int int int int
				outMessage = new Message(
						MessageType.FOLLOWCOACHADVICEDONE,
						((BenchClientProxy) Thread.currentThread()).getContestantId(),
						((BenchClientProxy) Thread.currentThread()).getContestantState(),
						((BenchClientProxy) Thread.currentThread()).getStrength()
						);
				// GenericIO.writelnString("BenchInterface - FollowCoachAdvice ends");
				break;

			case MessageType.REQSEATDOWN:
				// GenericIO.writelnString("BenchInterface - SeatDown starts");
				((BenchClientProxy) Thread.currentThread()).setContestantId(inMessage.getContestantId());
				((BenchClientProxy) Thread.currentThread()).setContestantState(inMessage.getContestantState());
				((BenchClientProxy) Thread.currentThread()).setStrength(inMessage.getStrength());

				bench.seatDown();
				// form 4 - int int int int
				outMessage = new Message(
						MessageType.SEATDOWNDONE,
						((BenchClientProxy) Thread.currentThread()).getContestantId(),
						((BenchClientProxy) Thread.currentThread()).getContestantState(),
						((BenchClientProxy) Thread.currentThread()).getStrength()
						);
				// GenericIO.writelnString("BenchInterface - SeatDown ends");
				break;

			case MessageType.REQCANENDTHEGAME:
				// GenericIO.writelnString("BenchInterface - CanEndTheGame starts");
				((BenchClientProxy) Thread.currentThread()).setRefereeState(inMessage.getRefereeState());
	
				bench.canEndTheGame(inMessage.getEndOfMatch());

				// form 2 - int int
				outMessage = new Message(
						MessageType.CANENDTHEGAMEDONE,
						((BenchClientProxy) Thread.currentThread()).getRefereeState());
				// GenericIO.writelnString("BenchInterface - CanEndTheGame ends");
				break;

			case MessageType.SHUT:
				bench.shutdown();
				outMessage = new Message(MessageType.SHUTDONE);
		}

		return (outMessage);

	}
}
