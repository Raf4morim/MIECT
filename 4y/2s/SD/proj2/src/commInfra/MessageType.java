package commInfra;

/**
 * Type of the exchanged messages.
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */
public class MessageType {

    /**
     *  Initialization of the logging file name and the number of iterations (service request).
     */

    public static final int SETNFIC = 1;

    /**
     *  Logging file was initialized (reply).
     */

    public static final int NFICDONE = 2;

    /**
     *  Server shutdown (service request).
     */

    public static final int SHUT = 3;

    /**
     *  Server was shutdown (reply).
     */

    public static final int SHUTDONE = 4;

    // BENCH

    /**
     * Request too call trial by the referee (service request).
     */

    public static final int REQCALLTRIAL = 11;

    /**
     * Trial was called by the referee (reply).
     */

    public static final int CALLTRIALDONE = 12;

    /**
     * Request too call contestants by the coach (service request).
     */

    public static final int REQCALLCONTESTANTS = 13;

    /**
     * Contestants were called by the coach (reply).
     */

    public static final int CALLCONTESTANTSDONE = 14;

    /**
     * Request too follow coach advice by the contestant (service request).
     */

    public static final int REQFOLLOWCOACHADVICE = 15;

    /**
     * Contestant followed coach advice (reply).
     */

    public static final int FOLLOWCOACHADVICEDONE = 16;

    /**
     * Request too seat down by the contestant (service request).
     */

    public static final int REQSEATDOWN = 17;

    /**
     * Contestant seated down (reply).
     */

    public static final int SEATDOWNDONE = 18;

    /**
     * Request too call end of the game by the referee (service request).
     */

    public static final int REQCANENDTHEGAME = 19;

    /**
     * End of the game was called by the referee (reply).
     */

    public static final int CANENDTHEGAMEDONE = 20;

    // PLAYGROUND

    /**
     * Request too get ready by the contestant (service request).
     */

    public static final int REQGETREADY = 21;

    /**
     * Contestant is ready (reply).
     */

    public static final int GETREADYDONE = 22;

    /**
     * Request too inform referee by the contestant (service request).
     */

    public static final int REQINFORMREFEREE = 23;

    /**
     * Referee was informed by the contestant (reply).
     */

    public static final int INFORMREFEREEDONE = 24;

    /**
     * Request too start trial by the referee (service request).
     */

    public static final int REQSTARTTRIAL = 25;

    /**
     * Trial was started by the referee (reply).
     */

    public static final int STARTTRIALDONE = 26;

    /**
     * Request too am done by the contestant (service request).
     */

    public static final int REQAMDONE = 27;

    /**
     * Contestant is done playing (reply).
     */

    public static final int AMDONEDONE = 28;

    /**
     * Request too assert trial decision by the referee (service request).
     */

    public static final int REQASSERTTRIALDECISION = 29;

    /**
     * Trial decision was asserted by the referee (reply).
     */

    public static final int ASSERTTRIALDECISIONDONE = 30;

    /**
     * Request too review notes by the coach (service request).
     */

    public static final int REQREVIEWNOTES = 31;

    /**
     * Notes were reviewed by the coach (reply).
     */

    public static final int REVIEWNOTESDONE = 32;

    /**
     * Request to see if the game is finished by the referee (service request).
     */

    public static final int REQGETFINISHEDGAME = 33;

    /**
     * Game is finished (reply).
     */

    public static final int GETFINISHEDGAMEDONE = 34;

    // REFEREE SITE

    /**
     * Request too announce new game by the referee (service request).
     */

    public static final int REQANNOUNCENEWGAME = 36;

    /**
     * New game was announced by the referee (reply).
     */

    public static final int ANNOUNCENEWGAMEDONE = 37;

    /**
     * Request too declare game winner by the referee (service request).
     */

    public static final int REQDECLAREGAMEWINNER = 38;

    /**
     * Game winner was declared by the referee (reply).
     */

    public static final int DECLAREGAMEWINNERDONE = 39;
    
    /**
     * Request too declare match winner by the referee (service request).
     */

    public static final int REQDECLAREMATCHWINNER = 40;

    /**
     * Match winner was declared by the referee (reply).
     */

    public static final int DECLAREMATCHWINNERDONE = 41;

    /**
     * Request too to see if match ended by the coach (service request).
     */

    public static final int REQENDOFMATCHCOACH = 42;

    /**
     * Match ended (reply).
     */

    public static final int ENDOFMATCHCOACHDONE = 43;

    /**
     * Request too to see if match ended by the referee (service request).
     */

    public static final int REQENDOFMATCHREFEREE = 44;

    /**
     * Match ended (reply).
     */

    public static final int ENDOFMATCHREFEREEDONE = 45;

    /**
     * Request too to see if match ended by the contestant (service request).
     */

    public static final int REQENDOFMATCHCONTESTANT = 46;

    /**
     * Match ended (reply).
     */

    public static final int ENDOFMATCHCONTESTANTDONE = 47;

    // GENERAL REPOSITORY

    /**
     * Request to set coach state (service request).
     */

    public static final int SETCOACHSTATE = 48;

    /**
     * Request to set contestant state (service request).
     */

    public static final int SETCONTESTANTSTATE = 49;

    /**
     * Request to set referee state (service request).
     */

    public static final int SETREFEREESTATE = 50;

    /**
     * Request to set contestant state and strength (service request).
     */

    public static final int SETCONTESTANTSTATEANDSTRENGTH = 51;

    /**
     * Request to set referee state and number of games (service request).
     */

    public static final int SETREFEREESTATEANDNGAMES = 52;

    /**
     * Request to set referee state and match winner (service request).
     */

    public static final int SETREFEREESTATEANDMATCHWINNER = 53;

    /**
     * Request to set position of the rope (service request).
     */

    public static final int SETPOSROPE = 54;

    /**
     * Request to set number of trials (service request).
     */

    public static final int SETNTRIALS = 55;

    /**
     * Request to set game winner (service request).
     */

    public static final int SETGAMEWINNER = 56;

    /**
     * Setting acknowledged (reply).
     */
    
    public static final int SACK = 57;
}