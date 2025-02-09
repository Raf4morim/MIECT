package commInfra;

import java.io.Serializable;

/**
 * Internal structure of the exchanged messages.
 *
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */
public class Message implements Serializable {

	/**
	 * Serialization key.
	 */

	private static final long serialVersionUID = 2021L;
	/**
	 * Message type.
	 */
	private int msgType = -1;

	/**
	 * Name of the logging file.
	 */
	private String fName = null;
	/**
	 * Contestant identification.
	 */
	private int contestantId = -1;
	/**
	 * Coach identification.
	 */
	private int coachId = -1;
	  /**
   *  Contestant state.
   */

	private int contestantState = -1;
	/**
	 * Coach state.
	 */

	private int coachState = -1;
	/**
	 * Referee state.
	 */

	private int refereeState = -1;
	/**
	 * Contestant strength.
	 */

	private int contestantStrenght;
	/**
	 * End of match flag.
	 */

	private boolean endOfMatch = false;
	/**
	 * Finished game flag.
	 */

	private boolean finishedGame = false;
	/**
	 * Position of the rope.
	 */
	private int posRope = 0;

	/**
	 * Number of games.
	 */
	private int nGames = 0;

	/**
	 * Number of trials.
	 */
	private int nTrials = 0;

	/**
	 * Match winner.
	 */
	private int matchWinner = 0;

	/**
	 * Score of team 0.
	 */
	private int score0 = 0;
	/**
	 * Score of team 1.
	 */

	private int score1 = 0;
	/**
	 * Game winner.
	 */

	private int gameWinner = 0;


	  /**
   *  Getting Contestant state.
   *
   *     @return contestant state
   */

	public int getContestantState() {
		return contestantState;
	}

	/**
	 * Getting Coach state.
	 *
	 * @return coach state
	 */
	public int getCoachState() {
		return coachState;
	}
	/**
	 * Getting Referee state.
	 *
	 * @return referee state
	 */

	public int getRefereeState() {
		return refereeState;
	}

	/**
	 * Getting Contestant identification.
	 *
	 * @return contestant identification
	 */
	public int getContestantId() {
		return contestantId;
	}

	/**
	 * Getting Coach identification.
	 *
	 * @return coach identification
	 */
	public int getCoachId() {
		return coachId;
	}

	/**
	 * Getting Contestant strength.
	 *
	 * @return contestant strength
	 */
	public int getStrength() {
		return contestantStrenght;
	}

	/**
	 * Getting the number of trials.
	 *
	 * @return number of trials
	 */
	public int getNTrials() {
		return nTrials;
	}

	
	/**
	 * Getting the number of games.
	 *
	 * @return number of games
	 */
	public int getNGames() {
		return nGames;
	}

	/**
	 * Getting the match winner.
	 *
	 * @return match winner
	 */
	public int getMatchWinner() {
		return matchWinner;
	}

	/**
	 * Getting the score of team 0.
	 *
	 * @return score of team 0
	 */
	public int getScore0() {
		return score0;
	}

	/**
	 * Getting the score of team 1.
	 *
	 * @return score of team 1
	 */
	public int getScore1() {
		return score1;
	}

	/**
	 * Getting the game winner.
	 *
	 * @return game winner
	 */
	public int getGameWinner() {
		return gameWinner;
	}

	/**
	 * Getting the end of match flag.
	 *
	 * @return end of match flag
	 */
	public boolean getEndOfMatch() {
		return endOfMatch;
	}

	/**
	 * Getting the finished game flag.
	 *
	 * @return finished game flag
	 */
	public boolean getFinishedGame() {
		return finishedGame;
	}

	/**
	 * Getting the position of the rope.
	 *
	 * @return position of the rope
	 */
	public int getPosRope() {
		return posRope;
	}

	/**
	 * 
	 * Message instantiation (form 1).
	 * To SHUTDOWN everything and SACK messages on GeneralReposInterface
	 *
	 * @param type message type
	 */
	public Message(int type) {
		msgType = type;
	}

	/**
	 * 
	 * Message instantiation (form 2 - int String).
	 * Used on initSimul to set the name of the logging file on GeneralReposStub
	 * 
	 * @param type message type
	 * @param name name of the logging file
	 */
	public Message(int type, String name) {
		msgType = type;
		fName = name;
	}

	/**
	 * 
	 * Message instantiation (form 2 - int int).
	 * Used to pass referee state in several stubs and interfaces, 
	 * 		to setPosRope, setNTrials and setGameWinner on GenerealReposStub
	 *
	 * @param type      message type
	 * @param secondArg entity identification
	 */
	public Message(int type, int secondArg) {
		msgType = type;
		// Referee life cycle
		if (type == MessageType.SETREFEREESTATE ||
				type == MessageType.REQSTARTTRIAL || type == MessageType.STARTTRIALDONE ||
				type == MessageType.REQASSERTTRIALDECISION ||
				type == MessageType.REQGETFINISHEDGAME ||
				type == MessageType.REQANNOUNCENEWGAME || type == MessageType.ANNOUNCENEWGAMEDONE ||
				type == MessageType.REQDECLAREMATCHWINNER || type == MessageType.DECLAREMATCHWINNERDONE ||
				type == MessageType.REQENDOFMATCHREFEREE ||
				type == MessageType.REQCALLTRIAL || type == MessageType.CALLTRIALDONE ||
				type == MessageType.CANENDTHEGAMEDONE) {
			refereeState = secondArg;
		}
		// Position Rope
		else if (type == MessageType.SETPOSROPE) {
			posRope = secondArg;
		}
		// Number of Trials
		else if (type == MessageType.SETNTRIALS) {
			nTrials = secondArg;
		}
		// Game Winner
		else if (type == MessageType.SETGAMEWINNER) {
			gameWinner = secondArg;
		}
	}

	/**
	 * 
	 * Message instantiation (form 3 - int int int).
	 * Used to pass coach and contestant state followed by id in several stubs and interfaces, 
	 * 		to pass nGames in GeneralReposStub
	 * 		to pass posRope in RefereeSiteStub
	 * 
	 * @param type      message type
	 * @param secondArg entity identification / entity state
	 * @param thirdArg  entity state / posRope / nGames  
	 */

	public Message(int type, int secondArg, int thirdArg) {
		msgType = type;
		// Coach life cycle
		if (type == MessageType.SETCOACHSTATE ||
				type == MessageType.REQINFORMREFEREE || type == MessageType.REQREVIEWNOTES ||
				type == MessageType.REQENDOFMATCHCOACH ||
				type == MessageType.REQCALLCONTESTANTS || type == MessageType.CALLCONTESTANTSDONE ||
				type == MessageType.INFORMREFEREEDONE || type == MessageType.REVIEWNOTESDONE) {
			coachId = secondArg;
			coachState = thirdArg;
		}
		// Contestant life cycle
		else if (type == MessageType.SETCONTESTANTSTATE ||
				type == MessageType.REQAMDONE || type == MessageType.AMDONEDONE ||
				type == MessageType.REQENDOFMATCHCONTESTANT) {
			contestantId = secondArg;
			contestantState = thirdArg;
		}
		// Referee life cycle
		else if (type == MessageType.REQDECLAREGAMEWINNER ||
				type == MessageType.ASSERTTRIALDECISIONDONE) {
			refereeState = secondArg;
			posRope = thirdArg;
		}
		/* General Repos Stub */
		else if (type == MessageType.SETREFEREESTATEANDNGAMES) {
			refereeState = secondArg;
			nGames = thirdArg;
		}
	}

	/**
	 * Message instantiation (form 3 - int int boolean).
	 * Used to pass the flag to end of the match in BenchStub waitting for all players to seat down
	 * 		to pass the flag to end of the game in the interface
	 *
	 * @param type     message type
	 * @param id       waiter identification
	 * @param thirdArg boolean flag
	 */

	public Message(int type, int id, boolean thirdArg) {
		msgType = type;
		// Referee life cycle
		if (type == MessageType.REQCANENDTHEGAME ||
				type == MessageType.ENDOFMATCHREFEREEDONE ||
				type == MessageType.DECLAREGAMEWINNERDONE) {
			refereeState = id;
			endOfMatch = thirdArg;
		}
		// Playground life cycle
		else if (type == MessageType.GETFINISHEDGAMEDONE) {
			refereeState = id;
			finishedGame = thirdArg;
		}
	}

	/**
	 * 
	 * Message instantiation (form 4 - int int int int).
	 * Only used on PlaygroundStub when contestant change the strength
	 * 
	 * @param MsgType         message type
	 * @param contestantId    contestant identification
	 * @param contestantState contestant state
	 * @param strength        contestant strength
	 */

	public Message(int MsgType, int contestantId, int contestantState, int strength) {

		msgType = MsgType;
		if (MsgType == MessageType.REQGETREADY || MsgType == MessageType.GETREADYDONE ||
				MsgType == MessageType.REQFOLLOWCOACHADVICE || MsgType == MessageType.FOLLOWCOACHADVICEDONE ||
				MsgType == MessageType.REQSEATDOWN || MsgType == MessageType.SEATDOWNDONE) {

			this.contestantId = contestantId;
			this.contestantState = contestantState;
			contestantStrenght = strength;
		}
	}

	/**
	 * 
	 * Message instantiation (form 4 - int int int boolean).
	 * Used on RefereeSiteInterface when coach is the one who sends the message
	 *
	 * @param type       message type
	 * @param id         waiter identification
	 * @param state      waiter state
	 * @param endOfMatch endOfMatch boolean
	 */

	public Message(int type, int id, int state, boolean endOfMatch) {
		msgType = type;
		if (type == MessageType.ENDOFMATCHCOACHDONE) {
			coachId = id;
			coachState = state;
		} else if (type == MessageType.ENDOFMATCHCONTESTANTDONE) {
			contestantId = id;
			contestantState = state;
		}
		this.endOfMatch = endOfMatch;
	}

	/**
	 * 
	 * Message instantiation (form 5 - int int int int int).
	 * Used to pass the strength of contestant in GeneralReposStub 
	 * 		to pass the scores when the match is declared
	 *
	 * @param MsgType   message type
	 * @param secondArg entity identification or state
	 * @param thirdArg  entity state or match winner
	 * @param fourthArg entity strength or score0
	 * @param fifthArg  coach teamId or score1
	 */

	public Message(int MsgType, int secondArg, int thirdArg, int fourthArg, int fifthArg) {

		msgType = MsgType;
		if (MsgType == MessageType.SETCONTESTANTSTATEANDSTRENGTH) {
			this.contestantId = secondArg;
			this.contestantState = thirdArg;
			contestantStrenght = fourthArg;
			coachId = fifthArg;
		} else if (MsgType == MessageType.SETREFEREESTATEANDMATCHWINNER) {
			refereeState = secondArg;
			matchWinner = thirdArg;
			score0 = fourthArg;
			score1 = fifthArg;
		}
	}

	/**
	 * Getting message type.
	 *
	 * @return message type
	 */
	public int getMsgType() {
		return (msgType);
	}

	/**
	 * Getting name of logging file.
	 *
	 * @return name of the logging file
	 */

	public String getLogFName() {
		return (fName);
	}


  /** 
   *  Printing the values of the internal fields.
   *
   *  It is used for debugging purposes.
   *
   *     @return string containing, in separate lines, the pair field name - field value
   */
	@Override
	public String toString ()
	{
	   return ("\nMessage type = " + msgType +
			   "\nContestant Id = " + contestantId +
			   "\nContestant State = " + contestantState +
			   "\nCoach Id = " + coachId +
			   "\nCoach State = " + coachState +
			   "\nReferee State = " + refereeState +
			   "\nContestant Strength = " + contestantStrenght +
			   "\nEnd of Match = " + endOfMatch +
			   "\nFinished Game = " + finishedGame +
			   "\nPosition of the rope = " + posRope +
			   "\nNumber of games = " + nGames +
			   "\nNumber of trials = " + nTrials +
			   "\nMatch Winner = " + matchWinner +
			   "\nScore of team 0 = " + score0 +
			   "\nScore of team 1 = " + score1 +
			   "\nGame Winner = " + gameWinner +			   
			   "\nName of logging file = " + fName);
	}
}