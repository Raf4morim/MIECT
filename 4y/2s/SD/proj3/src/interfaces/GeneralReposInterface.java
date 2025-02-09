package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type General repos.
 *
 *     It provides the functionality to access the General repos.
 */


public interface GeneralReposInterface extends Remote{

	/**
	 * Operation set rope position
	 * 
	 * @param posRope rope position
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public void setPosRope(int posRope) throws RemoteException;

	/**
	 *  Set coach state
	 * 
	 * @param coachId coach identifier
	 * @param coachState coach state 
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public void setCoachState(int coachId, int coachState) throws RemoteException;

	/**
	 *  Set contestant state
	 * 
	 * @param contestantId contestant identifier
	 * @param contestantState contestant state 
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */
	public void setContestantState(int contestantId, int contestantState) throws RemoteException;

	/**
	 * Set contestant state and strength
	 * 
	 * @param contestantId contestant identifier
	 * @param contestantState contestant state 
	 * @param contestantStrength contestant strength
	 * @param team_id team id of contestant
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */
	public void setContestantStateAndStrength(int contestantId, int contestantState, int contestantStrength, int team_id) throws RemoteException;

	/**
	 *  Set referee state
	 * 
	 * @param refereeState referee state 
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */
	public void setRefereeState(int refereeState) throws RemoteException;

	/**
	 *  Set referee state and number of games
	 * 
	 * @param refereeState referee state 
	 * @param getNGames number of games
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */
	public void setRefereeStateAndNGames(int refereeState, int getNGames) throws RemoteException;

	/**
	 *  Set referee state and number of games
	 * 
	 * @param refereeState referee state 
	 * @param getMatchWinner winner 
	 * @param getScore0 score of team 0 
	 * @param getScore1 score of team 1 
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */
	public void setRefereeStateAndMatchWinner(int refereeState, int getMatchWinner, int getScore0, int getScore1) throws RemoteException;

	/**
	 *  Set game winner
	 * 
	 * @param getGameWinner winner of the game
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */
	public void setGameWinner(int getGameWinner) throws RemoteException;

	/**
	 *  Set number of trials played in that game
	 * 
	 * @param getNTrials number of trials 
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */
	public void setNTrials(int getNTrials) throws RemoteException;

	/**
	 *   Operation initialization of simulation.
	 *
	 *   New operation.
	 *
	 *     @param logFileName name of the logging file
	 *     @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                             service fails
	 */

	public void initSimul (String logFileName) throws RemoteException;

	/**
	 *   Operation server shutdown.
	 *
	 *   New operation.
	 *
	 *     @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                             service fails
	 */

	public void shutdown () throws RemoteException;
	
}