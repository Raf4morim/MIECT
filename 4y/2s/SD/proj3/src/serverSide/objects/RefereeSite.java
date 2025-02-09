package serverSide.objects;

import java.rmi.RemoteException;

import interfaces.RefereeSiteInterface;
import interfaces.ReturnBoolean;
import interfaces.GeneralReposInterface;

import clientSide.entities.*;
import serverSide.main.*;

import genclass.GenericIO;

/**
 * Referee Site.
 * 
 * It is responsible for maintaining the state and managing the actions of the
 * referee.
 * It is implemented as an implicit monitor.
 * All public methods are executed in mutual exclusion.
 * There are no internal synchronization points.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on Java RMI.
 */

public class RefereeSite implements RefereeSiteInterface {

    /**
     * Reference to contestants threads.
     */

    private final Thread[] contestants;

    /**
     * Reference to the general repository.
     */

    private final GeneralReposInterface repos;

    /**
     * Boolean flag that indicates the end of the match.
     */

    private boolean endOfMatch;

    /**
     * Number of games played.
     */

    private int nGames;

    /**
     * Boolean flag that indicates the end of the games.
     */
    private boolean endOfGames;

    /**
     * Get the number of games played.
     * 
     * @return number of games played
     */

    public int getnGames() {
        return nGames;
    }

    /**
     * Get the end of the match.
     * 
     * @return end of the match flag
     */

    public boolean getEndOfMatch() throws RemoteException{
        return this.endOfMatch;
    }

    /**
     * Get the end of the games.
     * 
     * @return end of the games flag
     */

    public boolean getEndOfGames() throws RemoteException{
        return this.endOfGames;
    }

    /**
     * Array to store the scores of games.
     */

    private int registScores[] = new int[SimulPar.C];

    /**
     * Number of entities that have already shutdown.
     */

    private int nEntities = 0;

    /**
     * Instantiation of the referee site.
     * 
     * @param repos reference to the general repository
     */

    public RefereeSite(GeneralReposInterface repos) {
        this.repos = repos;
        contestants = new Thread[SimulPar.P];
        nGames = 0;
        endOfMatch = false;
        endOfGames = false;
        for (int i = 0; i < SimulPar.C; i++) {
            registScores[i] = 0;
        }
        for (int i = 0; i < SimulPar.P; i++) {
            contestants[i] = null;
        }
    }

    /**
     * Operation announce new game.
     * 
     * It is called by the referee to announce a new game on the start of the match
     * or after a game ends.
     * @return referee state
     */

    public synchronized int announceNewGame() throws RemoteException {
        nGames++;
        // ((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(RefereeState.START_OF_A_GAME);
        try {
            repos.setRefereeStateAndNGames(RefereeState.START_OF_A_GAME, nGames);
        } catch (RemoteException e){
            GenericIO.writelnString ("Referee remote exception on assertTrialDecision - setPosRope: " + e.getMessage ());
            System.exit (1);
        }
        return RefereeState.START_OF_A_GAME;
    }

    /**
     * Operation declare game winner.
     * 
     * It is called by the referee after a game has come to an end (either by trials
     * or KO);
     * determines the winner of the game using the position of the rope.
     * 
     * @param posRope position of the rope at the end of the game
     * @return end of the match flag and referee state
     */

    public synchronized ReturnBoolean declareGameWinner(int posRope) throws RemoteException {
        if (posRope < 0) {
            storeGameWinner(0);
            try { 
                repos.setGameWinner(0);
            } catch (RemoteException e){
                GenericIO.writelnString ("Referee remote exception on declareGameWinner - setGameWinner: " + e.getMessage ());
                System.exit (1);
            }
        } else if (posRope > 0) {
            storeGameWinner(1);
            try {
                repos.setGameWinner(1);
            } catch (RemoteException e){
                GenericIO.writelnString ("Referee remote exception on declareGameWinner - setGameWinner: " + e.getMessage ());
                System.exit (1);
            }
        } else {
            try {
                repos.setGameWinner(2);
            } catch (RemoteException e){
                GenericIO.writelnString ("Referee remote exception on declareGameWinner - setGameWinner: " + e.getMessage ());
                System.exit (1);
            }   
        }

        if (nGames < SimulPar.G)
            endOfMatch = false;
        else
            endOfMatch = true;
            
        return new ReturnBoolean(endOfMatch, RefereeState.WAIT_UNTIL_ALL_SEATED);
    }

    /**
     * Operation declare match winner.
     * 
     * It is called by the referee after all games have been played;
     * determines the winner of the match by comparing the scores of the teams.
     *
     * @return referee state
     */

    public synchronized int declareMatchWinner() throws RemoteException {
        int ScoreTeamID0 = getGamesScore(0);
        int ScoreTeamID1 = getGamesScore(1);
        int winnerTeam;

        // ((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(RefereeState.END_OF_THE_MATCH);
        if (nGames == SimulPar.G) {
            if (ScoreTeamID0 > ScoreTeamID1) {
                winnerTeam = 0;
            } else if (ScoreTeamID0 < ScoreTeamID1) {
                winnerTeam = 1;
            } else {
                winnerTeam = 2; // represents a draw
            }
            try {
                repos.setRefereeStateAndMatchWinner(RefereeState.END_OF_THE_MATCH, winnerTeam, ScoreTeamID0, ScoreTeamID1);
            } catch (RemoteException e){
                GenericIO.writelnString ("Referee remote exception on declareMatchWinner - setRefereeStateAndMatchWinner: " + e.getMessage ());
                System.exit (1);
            }
        }
        return RefereeState.END_OF_THE_MATCH;
    }

    /**
     * Increments the match score of the victory team.
     * 
     * @param teamId id of the team
     */

    public void storeGameWinner(int teamId) {
        registScores[teamId]++;
    }

    /**
     * Get the games score of a specific team in the match.
     * 
     * @param teamId id of the team
     * @return score of the specified team
     */

    public int getGamesScore(int teamId) {
        return registScores[teamId];
    }

    /**
     *   Operation server shutdown.
     *
     *   New operation.
     */
    
    public synchronized void shutdown() throws RemoteException {
        nEntities++;
        if (nEntities == 3)
		    ServerRefereeSite.shutdown(); 
		notifyAll(); 
    }
}