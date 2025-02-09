package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type Bench.
 *
 *     It provides the functionality to access the Bench.
 */


public interface PlayGroundInterface extends Remote{

	/**
	 * Operation get ready
	 *
	 * It is called by a contestant to get ready to play
	 * @param strength contestant strength
	 * @param contestantId contestant id
	 * @return contestant state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public int getReady(int strength, int contestantId) throws RemoteException;

	/**
	 * Operation start trial
	 *
	 * It is called by a referee to start the trial
	 * @return referee state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public int startTrial() throws RemoteException;

	/**
	 * Operation am done
	 *
	 * It is called by a contestant to say he is done playing (or pulling the rope)
	 * @param contestantId contestant id
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public void amDone(int contestantId) throws RemoteException;

	/**
	 * Operation assert trial decision
	 *
	 * It is called by a referee to get the position of the rope
	 * @return rope position
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

    public int assertTrialDecision() throws RemoteException;

	/**
	 * Operation get finished game
	 *
	 * Check flag to see if the game has finished
	 * @return game finished
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

    public boolean getFinishedGame() throws RemoteException;

	/**
	 * Operation review notes
	 *
	 * It is called by a coach to review game notes
	 * @param coachId coach id
	 * @return coach state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

    public int reviewNotes(int coachId) throws RemoteException;

	/**
	 * Operation inform referee
	 *
	 * It is called by a coach to inform referee all players are ready to start playing
	 * @param coachId coach id
	 * @return coach state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public int informReferee(int coachId) throws RemoteException;

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