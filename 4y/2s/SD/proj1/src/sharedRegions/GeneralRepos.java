package sharedRegions;

import main.*;
import entities.*;
import genclass.GenericIO;
import genclass.TextFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * General Repository.
 * 
 * It is responsible to keep the visible internal state of the problem and provide 
 * means for it to be printed in the logging file.
 * It is implemented as an implicit monitor.
 * All public methods are executed in mutual exclusion.
 * There are no internal synchronization points.
 */

public class GeneralRepos {

    /**
     * Name of the logging file.
     */

    private final String logFileName;

    /**
     * Headings for the logging file.
     */

    private String heading1;
    private String heading2;
    private String heading3;

    /**
     * List of selected contestants identifications for each team.
     */

    private List<Integer> selectedTeam1IDs;
    private List<Integer> selectedTeam0IDs;

    /**
     * Number of games played.
     */

    private int nGames;

    /**
     * Number of trials in progress.
     */

    private int nTrials;

    /**
     * Strength of each contestant.
     */

    private final int[] strength;

    /**
     * State of the coaches.
     */

    private final int[] coachState;

    /**
     * State of the contestants.
     */

    private final int[] contestantState;

    /**
     * State of the referee.
     */

    private int refereeState;

    /**
     * Position of the rope.
     */

    private int posRope;

    /**
     * Winner of the game.
     */

    private int gameWinner;

    /**
     * Winner of the match.
     */
    private int matchWinner;

    /**
     * Score of team 1.
     */

    private int score1;

    /**
     * Score of team 0.
     */

    private int score0;

    /**
     * Instantiation of a general repository object.
     * 
     * @param logFileName name of the logging file
     * @param strengthPerContestant strength of each contestant
     */

    public GeneralRepos(String logFileName) {//int[] strengthPerContestant
        nGames = 0;
        nTrials = 0;
        posRope = 0;
        
        heading1 = "Ref Coa 1 Cont 1 Cont 2 Cont 3 Cont 4 Cont 5 Coa 2 Cont 1 Cont 2 Cont 3 Cont 4 Cont 5       Trial        ";
        heading2 = "Sta  Stat Sta SG Sta SG Sta SG Sta SG Sta SG  Stat Sta SG Sta SG Sta SG Sta SG Sta SG 3 2 1 . 1 2 3 NB PS";
        heading3 = "Game";
        
        selectedTeam1IDs = new ArrayList<>();
        selectedTeam0IDs = new ArrayList<>();
        
        refereeState = RefereeState.START_OF_THE_MATCH;
        coachState = new int[SimulPar.C];
        contestantState = new int[SimulPar.P];
        strength = new int[SimulPar.P];

        if ((logFileName == null) || Objects.equals(logFileName, ""))
            this.logFileName = "logger";
        else
            this.logFileName = logFileName;
        for (int i = 0; i < SimulPar.C; i++)
            coachState[i] = CoachState.WAIT_FOR_REFEREE_COMMAND;
        for (int i = 0; i < SimulPar.P; i++)
            contestantState[i] = ContestantState.SEAT_AT_THE_BENCH;
        // for (int i = 0; i < SimulPar.P; i++) {
        //     strength[i] = strengthPerContestant[i];
        // }

        reportInitialStatus();
    }

    /**
     * Set coach state.
     * 
     * @param id coach identification
     * @param state coach state
     */

    public synchronized void setCoachState(int id, int state) {
        coachState[id] = state;
        reportStatus();
    }

    /**
     * Set contestant state.
     * 
     * @param id contestant identification
     * @param state contestant state
     */

    public synchronized void setContestantState(int id, int state) {
        contestantState[id] = state;
        reportStatus();
    }

    /**
     * Set contestant state and strength.
     * 
     * @param id contestant identification
     * @param state contestant state
     * @param strength contestant strength
     * @param teamID team identification
     */

    public synchronized void setContestantStateAndStrength(int id, int state, int strength, int teamID) {
        contestantState[id] = state;
        this.strength[id] = strength;
        if (state == ContestantState.STAND_IN_POSITION) {
            if (teamID == 1) {
                selectedTeam1IDs.add(id);
            } else {
                selectedTeam0IDs.add(id);
            }
        }
        reportStatus();
    }

    // public synchronized void setContestantStrength(int id, int strength) {
    //     this.strength[id] = strength;
    //     reportStatus();
    // }

    /**
     * Set referee state.
     * 
     * @param state referee state
     */

    public synchronized void setRefereeState(int state) {
        refereeState = state;
        reportStatus();
    }

    /**
     * Set referee state and number of games.
     * 
     * @param state referee state
     * @param nGames number of games
     */

    public synchronized void setRefereeStateAndNGames(int state, int nGames) {
        refereeState = state;
        this.nGames = nGames;
        reportStatus();
    }

    /**
     * Set referee state and match winner.
     * 
     * @param state referee state
     * @param matchWinner match winner
     * @param score1 score of team 1
     * @param score0 score of team 0
     */

    public synchronized void setRefereeStateAndMatchWinner(int state, int matchWinner, int score1, int score0) {
        refereeState = state;
        this.matchWinner = matchWinner;
        this.score1 = score1;
        this.score0 = score0;
        reportStatus();
    }

    /**
     * Set position of the rope.
     * 
     * @param posRope position of the rope
     */

    public synchronized void setPosRope(int posRope) {
        this.posRope = posRope;
        reportStatus();
    }

    /**
     * Set number of trials.
     * 
     * @param nTrials number of trials
     */

    public synchronized void setNTrials(int nTrials) {
        this.nTrials = nTrials;
        reportStatus();
    }

    /**
     * Set number of winner of the game.
     * 
     * @param gameWinner winner of the game
     */
    public synchronized void setGameWinner(int gameWinner) {
        this.gameWinner = gameWinner;
        reportStatus();
    }

    /**
     *  Write the header to the logging file.
     *
     *  The referee is starting a match, the coaches are waiting for the referee command
     *  to start assembling the teams and the contestants are seated at the bench. 
     */
    private void reportInitialStatus() {
        TextFile log = new TextFile(); // instantiation of a text file handler

        if (!log.openForWriting(".", logFileName)) {
            GenericIO.writelnString("The operation of creating the file " + logFileName + " failed!");
            System.exit(1);
        }
        log.writelnString("                Game of the Rope - Description of the internal state");
        log.writelnString(heading1);
        log.writelnString(heading2);
        if (!log.close()) {
            GenericIO.writelnString("The operation of closing the file " + logFileName + " failed!");
            System.exit(1);
        }
        reportStatus();
    }

    /**
     * Write a state line at the end of the logging file.
     * 
     * The current state of the entities is organized in a line to be printed.
     * 
     */

    private void reportStatus() {
        TextFile log = new TextFile(); // instantiation of a text file handler

        String lineStatus = "";
        int allSAB = 0;

        if (!log.openForAppending(".", logFileName)) {
            GenericIO.writelnString("The operation of opening for appending the file " + logFileName + " failed!");
            System.exit(1);
        }

        switch (refereeState) {
            case RefereeState.START_OF_THE_MATCH:
                lineStatus += "SOM";
                break;
            case RefereeState.START_OF_A_GAME:
                lineStatus += "SOG";
                break;
            case RefereeState.TEAMS_READY:
                lineStatus += "TRY";
                break;
            case RefereeState.WAIT_FOR_TRIAL_CONCLUSION:
                lineStatus += "WTC";
                break;
            case RefereeState.END_OF_A_GAME:
                lineStatus += "EOG";
                break;
            case RefereeState.END_OF_THE_MATCH:
                lineStatus += "EOM";
                break;
        }

        switch (coachState[0]) {
            case CoachState.WAIT_FOR_REFEREE_COMMAND:
                lineStatus += "  WFRC";
                break;
            case CoachState.ASSEMBLE_TEAM:
                lineStatus += "  ASTM";
                break;
            case CoachState.WATCH_TRIAL:
                lineStatus += "  WATL";
                break;
        }

        for (int i = 0; i < SimulPar.P/2; i++) {
            switch (contestantState[i]) {
                case ContestantState.SEAT_AT_THE_BENCH:
                    lineStatus += " SAB";
                    allSAB++;
                    break;
                case ContestantState.STAND_IN_POSITION:
                    lineStatus += " SIP";
                    break;
                case ContestantState.DO_YOUR_BEST:
                    lineStatus += " DYB";
                    break;
            }
            lineStatus += " " + String.format("%2d", strength[i]);
        }

        switch (coachState[1]) {
            case CoachState.WAIT_FOR_REFEREE_COMMAND:
                lineStatus += "  WFRC";
                break;
            case CoachState.ASSEMBLE_TEAM:
                lineStatus += "  ASTM";
                break;
            case CoachState.WATCH_TRIAL:
                lineStatus += "  WATL";
                break;
        }

        for (int i = SimulPar.P/2; i < SimulPar.P; i++) {
            switch (contestantState[i]) {
                case ContestantState.SEAT_AT_THE_BENCH:
                    lineStatus += " SAB";
                    allSAB++;
                    break;
                case ContestantState.STAND_IN_POSITION:
                    lineStatus += " SIP";
                    break;
                case ContestantState.DO_YOUR_BEST:
                    lineStatus += " DYB";
                    break;
            }
            lineStatus += " " + String.format("%2d", strength[i]);
        }

        String lado1 = " - - -";
        String meio = " .";
        String lado2 = " - - -";

        int ifanCount = 6;

        for (Integer id : selectedTeam1IDs) {
            lado1 = lado1.replaceFirst(" -", " " + id);
            ifanCount--;
            if (ContestantState.SEAT_AT_THE_BENCH == contestantState[id])
                lado1 = lado1.replaceFirst(" " + id, " -");

        }
        for (Integer id : selectedTeam0IDs) {
            lado2 = lado2.replaceFirst(" -", " " + id);
            ifanCount--;
            if (ContestantState.SEAT_AT_THE_BENCH == contestantState[id])
                lado2 = lado2.replaceFirst(" " + id, " -");
        }
        lineStatus += lado1 + meio + lado2;
        // If there are still "ifans" remaining, replace them by dashes
        for (int i = 0; i < ifanCount; i++) {
            lineStatus = lineStatus.replaceFirst(" -", " -");
        }

        if (RefereeState.WAIT_FOR_TRIAL_CONCLUSION == refereeState) {
            lineStatus += " " + nTrials;
            lineStatus += "  " + posRope;
        } else {
            lineStatus += " -  -";
        }

        if (RefereeState.START_OF_A_GAME == refereeState) {
            log.writelnString(heading3 + " " + nGames);
            log.writelnString(heading1);
            log.writelnString(heading2);
        }
        log.writelnString(lineStatus);
        
        if (RefereeState.END_OF_A_GAME == refereeState) {
            if (Math.abs(posRope)>=4) {
                log.writelnString("Game " + nGames + " was won by team " + gameWinner + " by knock out in " + nTrials + " trials.");
            } else if(posRope==0) {
                log.writelnString("Game " + nGames + " was a draw.");
            } else {
                log.writelnString("Game " + nGames + " was won by team " + gameWinner + " by points.");
            }
        }

        if (RefereeState.END_OF_THE_MATCH == refereeState) {
            if (matchWinner==2) {
                log.writelnString("Match was a draw.");
            } else {
                log.writelnString("Match was won by team " + matchWinner + " (" + score1 + "-" + score0+").");
            }
        }

        if (allSAB == 10) {
            selectedTeam1IDs.clear();
            selectedTeam0IDs.clear();
        }
        
        if (!log.close()) {
            GenericIO.writelnString("The operation of closing the file " + logFileName + " failed!");
            System.exit(1);
        }
    }

}