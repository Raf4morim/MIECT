package serverSide.sharedRegion;

import clientSide.entities.*;
import clientSide.stubs.GeneralReposStub;
import serverSide.entities.RefereeSiteClientProxy;
import serverSide.main.*;

/**
 * Referee Site.
 * 
 * It is responsible for maintaining the state and managing the actions of the
 * referee.
 * It is implemented as an implicit monitor.
 * All public methods are executed in mutual exclusion.
 * There are no internal synchronization points.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */

public class RefereeSite {
    /**
     * Reference to customer threads.
     */

    private final RefereeSiteClientProxy[] contestants;

    /**
     * Reference to the general repository.
     */

    private final GeneralReposStub repos;

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

    public boolean getEndOfMatch() {
        return this.endOfMatch;
    }

    /**
     * Get the end of the games.
     * 
     * @return end of the games flag
     */

    public boolean getEndOfGames() {
        return this.endOfGames;
    }

    /**
     * Array to store the scores of games.
     */

    private int registScores[] = new int[SimulPar.C];

    /**
     * Instantiation of the referee site.
     * 
     * @param repos reference to the general repository
     */

    public RefereeSite(GeneralReposStub repos) {
        this.repos = repos;
        contestants = new RefereeSiteClientProxy[SimulPar.P];
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
     * 
     */

    public synchronized void announceNewGame() {
        nGames++;
        ((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(RefereeState.START_OF_A_GAME);
        repos.setRefereeStateAndNGames(RefereeState.START_OF_A_GAME, nGames);
    }

    /**
     * Operation declare game winner.
     * 
     * It is called by the referee after a game has come to an end (either by trials
     * or KO);
     * determines the winner of the game using the position of the rope.
     * 
     * @param posRope position of the rope at the end of the game
     * @return end of the match flag
     */

    public synchronized boolean declareGameWinner(int posRope) {
        if (posRope < 0) {
            storeGameWinner(0);
            repos.setGameWinner(0);
        } else if (posRope > 0) {
            storeGameWinner(1);
            repos.setGameWinner(1);
        } else {
            repos.setGameWinner(2);
        }

        if (nGames < SimulPar.G)
            endOfMatch = false;
            else
            endOfMatch = true;
            
        ((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(RefereeState.WAIT_UNTIL_ALL_SEATED);
        return endOfMatch;
    }

    /**
     * Operation declare match winner.
     * 
     * It is called by the referee after all games have been played;
     * determines the winner of the match by comparing the scores of the teams.
     *
     */

    public synchronized void declareMatchWinner() {
        int ScoreTeamID0 = getGamesScore(0);
        int ScoreTeamID1 = getGamesScore(1);
        int winnerTeam;

        ((RefereeSiteClientProxy) Thread.currentThread()).setRefereeState(RefereeState.END_OF_THE_MATCH);
        if (nGames == SimulPar.G) {
            if (ScoreTeamID0 > ScoreTeamID1) {
                winnerTeam = 0;
            } else if (ScoreTeamID0 < ScoreTeamID1) {
                winnerTeam = 1;
            } else {
                winnerTeam = 2; // represents a draw
            }
            repos.setRefereeStateAndMatchWinner(RefereeState.END_OF_THE_MATCH, winnerTeam, ScoreTeamID0, ScoreTeamID1);
        }
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
    
    public synchronized void shutdown() {
        ServerRefereeSite.waitConnection = false;
        notifyAll();
    }
}