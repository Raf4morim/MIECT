package clientSide.main;

import clientSide.entities.Referee;
import clientSide.stubs.BenchStub;
import clientSide.stubs.GeneralReposStub;
import clientSide.stubs.PlayGroundStub;
import clientSide.stubs.RefereeSiteStub;
import genclass.GenericIO;
import serverSide.main.SimulPar;

/**
 * Client side of The Rope Game (Referee).
 *
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */


public class ClientTheRopeGameReferee {
	/**
	 * Main method.
	 *
	 * @param args runtime arguments
	 *             args[0] - name of the platform where is located the bench server
	 *             args[1] - port number for listening to service requests
	 * 
	 *             args[2] - name of the platform where is located the playground server
	 *             args[3] - port number for listening to service requests
	 * 
	 *             args[4] - name of the platform where is located the refereeSite server
	 *             args[5] - port number for listening to service requests
	 * 
	 *             args[6] - name of the platform where is located the general repository server
	 *             args[7] - port number for listening to service requests
	 */

	public static void main(String[] args) {

		String benchServerHostName; // name of the platform where is located the bench server
		int benchServerPortNumb = -1; // port number for listening to service requests

		String playGroundServerHostName; // name of the platform where is located the playground server
		int playGroundServerPortNumb = -1; // port number for listening to service requests

		String refereeSiteServerHostName; // name of the platform where is located the refereeSite server
		int refereeSiteServerPortNumb = -1; // port number for listening to service requests

		String genReposServerHostName; // name of the platform where is located the general repository server
		int genReposServerPortNumb = -1; // port number for listening to service requests

		BenchStub benchStub; // remote reference to the bench
		PlayGroundStub playGroundStub; // remote reference to the playground
		RefereeSiteStub refereeSiteStub; // remote reference to the referee site
		GeneralReposStub genReposStub; // remote reference to the general repository

		/* getting problem runtime parameters */

		if (args.length != 8) {
			GenericIO.writelnString("Wrong number of parameters!");
			System.exit(1);
		}

		benchServerHostName = args[0];
		try {
			benchServerPortNumb = Integer.parseInt(args[1]);
		} catch (NumberFormatException e) {
			GenericIO.writelnString("args[1] is not a number!");
			System.exit(1);
		}
		if ((benchServerPortNumb < 4000) || (benchServerPortNumb >= 65536)) {
			GenericIO.writelnString("args[1] is not a valid port number!");
			System.exit(1);
		}

		playGroundServerHostName = args[2];
		try {
			playGroundServerPortNumb = Integer.parseInt(args[3]);
		} catch (NumberFormatException e) {
			GenericIO.writelnString("args[3] is not a number!");
			System.exit(1);
		}
		if ((playGroundServerPortNumb < 4000) || (playGroundServerPortNumb >= 65536)) {
			GenericIO.writelnString("args[3] is not a valid port number!");
			System.exit(1);
		}

		refereeSiteServerHostName = args[4];
		try {
			refereeSiteServerPortNumb = Integer.parseInt(args[5]);
		} catch (NumberFormatException e) {
			GenericIO.writelnString("args[5] is not a number!");
			System.exit(1);
		}
		if ((refereeSiteServerPortNumb < 4000) || (refereeSiteServerPortNumb >= 65536)) {
			GenericIO.writelnString("args[5] is not a valid port number!");
			System.exit(1);
		}

		genReposServerHostName = args[6];
		try {
			genReposServerPortNumb = Integer.parseInt(args[7]);
		} catch (NumberFormatException e) {
			GenericIO.writelnString("args[7] is not a number!");
			System.exit(1);
		}
		if ((genReposServerPortNumb < 4000) || (genReposServerPortNumb >= 65536)) {
			GenericIO.writelnString("args[7] is not a valid port number!");
			System.exit(1);
		}

		/* problem initialization */

		benchStub = new BenchStub(benchServerHostName, benchServerPortNumb);
		playGroundStub = new PlayGroundStub(playGroundServerHostName, playGroundServerPortNumb);
		refereeSiteStub = new RefereeSiteStub(refereeSiteServerHostName, refereeSiteServerPortNumb);
		genReposStub = new GeneralReposStub(genReposServerHostName, genReposServerPortNumb);

		Referee referee = new Referee("Referee_", playGroundStub, refereeSiteStub, benchStub);

		referee.addCoach(0);
		referee.addCoach(1);

		for (int i = 0; i < SimulPar.P; i++) {
			referee.addContestant(i);
		}

		/* start of the simulation */

		referee.start();

		/* waiting for the end of the simulation */

		GenericIO.writelnString();
		try {
			referee.join();
		} catch (InterruptedException e) {
		}
		GenericIO.writelnString("The referee has terminated.");
		
		GenericIO.writelnString();
		benchStub.shutdown();
		playGroundStub.shutdown();
		refereeSiteStub.shutdown();
		genReposStub.shutdown();
	}
}
