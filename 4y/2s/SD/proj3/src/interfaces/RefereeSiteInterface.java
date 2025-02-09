package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type Bench.
 *
 *     It provides the functionality to access the Bench.
 */


public interface RefereeSiteInterface extends Remote{

	/**
	 * Operation announce new game
	 *
	 * It is called by the referee to announce the start of a new game
	 * @return referee state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public int announceNewGame() throws RemoteException;

	/**
	 * Operation declare game winner
	 *
	 * It is called by the referee to declare game winner
	 * @param getPosRope position of the rope at the end of the game
	 * @return end of the match flag and referee state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public ReturnBoolean declareGameWinner(int getPosRope) throws RemoteException;

	/**
	 * Operation declare match winner
	 *
	 * It is called by a referee to declare match winner
	 * @return referee state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public int declareMatchWinner() throws RemoteException;

	/**
	 * Operation get end of match
	 *
	 * Check if the match has ended
	 * @return end of match flag
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
	 *                         service fails
	 */

	public boolean getEndOfMatch() throws RemoteException;

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