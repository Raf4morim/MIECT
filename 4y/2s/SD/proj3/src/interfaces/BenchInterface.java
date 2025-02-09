package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type Bench.
 *
 *     It provides the functionality to access the Bench.
 */

public interface BenchInterface extends Remote{

	/**
	 * Operation call the trial
	 * 
	 * It is called by the referee for the coach to call the contestants to the trial.
	 * @return referee state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
   	 *                         service fails
	 */

	public int callTrial() throws RemoteException;

	/**
	 * Operation can end the game
	 * 
	 * It is called by the referee to check if the game can end and wake up coaches and contestants to finish game.
	 * @param endOfMatch flag to check if the match has ended
	 * @return referee state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
   	 *                         service fails
	 */

	public int canEndTheGame(boolean endOfMatch) throws RemoteException;

	/**
	 * Operation call contestants
	 * 
	 * It is called by the coach to call the contestants to play in the trial.
	 * @param coachId the coach id
	 * @return coach state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
   	 *                         service fails
	 */

	public int callContestants(int coachId) throws RemoteException;

	/**
	 * Operation follow coach advice
	 * 
	 * It is called by the contestant to follow the coach advice and go play.
	 * @param strength the contestant strength
	 * @param contestantId the contestant id
	 * @return the contestant id and state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
   	 *                         service fails
	 */

	public ReturnInt followCoachAdvice(int strength, int contestantId) throws RemoteException;
	
	/**
	 * Operation seat down
	 * 
	 * It is called by the contestant to seat down in the bench.
	 * @param strength the contestant strength
	 * @param contestantId the contestant id
	 * @return the contestant strength and state
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry
   	 *                         service fails
	 */

	public ReturnInt seatDown(int strength ,int contestantId) throws RemoteException;
	
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