package clientSide.main;

import clientSide.entities.Contestant;

import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

import interfaces.BenchInterface;
import interfaces.GeneralReposInterface;
import interfaces.PlayGroundInterface;
import interfaces.RefereeSiteInterface;

import genclass.GenericIO;
import serverSide.main.SimulPar;

/**
 * Client side of The Rope Game (Contestant).
 *
 * Implementation of a client-server model of type 2 (server replication).
 * Communication is based on Java RMI.
 */

public class ClientTheRopeGameContestant {
	/**
	 * Main method.
	 *
	 * @param args runtime arguments
	 *             args[0] - name of the platform where is located the RMI
	 *             registering service
	 *             args[1] - port number where the registering service is listening
	 *             to service requests
	 *             args[2] - name of the logging file
	 */

	public static void main(String[] args) {

		String rmiRegHostName; // name of the platform where is located the RMI registering service
		int rmiRegPortNumb = -1; // port number where the registering service is listening to service requests
		String fileName; // name of the logging file

		/* getting problem runtime parameters */

		if (args.length != 3) {
			GenericIO.writelnString("Wrong number of parameters!");
			System.exit(1);
		}
		rmiRegHostName = args[0];
		try {
			rmiRegPortNumb = Integer.parseInt(args[1]);
		} catch (NumberFormatException e) {
			GenericIO.writelnString("args[1] is not a number!");
			System.exit(1);
		}
		if ((rmiRegPortNumb < 4000) || (rmiRegPortNumb >= 65536)) {
			GenericIO.writelnString("args[1] is not a valid port number!");
			System.exit(1);
		}
		fileName = args[2];

		/* problem initialization */
		String nameEntryGeneralRepos = "GeneralRepository"; // public name of the general repository object
		GeneralReposInterface genReposStub = null; // remote reference to the general repository object

		String nameEntryBench = "Bench"; // public name of the bench object
		BenchInterface benchStub = null; // remote reference to the bench

		String nameEntryPlayGround = "PlayGround"; // public name of the playground object
		PlayGroundInterface playGroundStub = null; // remote reference to the playground

		String nameEntryRefereeSite = "RefereeSite"; // public name of the referee site object
		RefereeSiteInterface refereeSiteStub = null; // remote reference to the referee site

		Registry registry = null; // remote reference for registration in the RMI registry service
		Contestant contestants[] = new Contestant[SimulPar.P];

		int strengthPerContestant[] = new int[SimulPar.P];

		for (int i = 0; i < SimulPar.P; i++) {
			strengthPerContestant[i] = (int) (Math.random() * 5) + 6;
		}

		/* problem initialization */

		try {
			registry = LocateRegistry.getRegistry(rmiRegHostName, rmiRegPortNumb);
		} catch (RemoteException e) {
			GenericIO.writelnString("RMI registry creation exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		}

		try {
			genReposStub = (GeneralReposInterface) registry.lookup(nameEntryGeneralRepos);
		} catch (RemoteException e) {
			GenericIO.writelnString("GeneralRepos lookup exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		} catch (NotBoundException e) {
			GenericIO.writelnString("GeneralRepos not bound exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		}

		try {
			benchStub = (BenchInterface) registry.lookup(nameEntryBench);
		} catch (RemoteException e) {
			GenericIO.writelnString("Bench lookup exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		} catch (NotBoundException e) {
			GenericIO.writelnString("Bench not bound exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		}

		try {
			playGroundStub = (PlayGroundInterface) registry.lookup(nameEntryPlayGround);
		} catch (RemoteException e) {
			GenericIO.writelnString("PlayGround lookup exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		} catch (NotBoundException e) {
			GenericIO.writelnString("PlayGround not bound exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		}
		
		try {
			refereeSiteStub = (RefereeSiteInterface) registry.lookup(nameEntryRefereeSite);
		} catch (RemoteException e) {
			GenericIO.writelnString("RefereeSite lookup exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		} catch (NotBoundException e) {
			GenericIO.writelnString("RefereeSite not bound exception: " + e.getMessage());
			e.printStackTrace();
			System.exit(1);
		}

		try {
			genReposStub.initSimul(fileName);
		} catch (RemoteException e) {
			GenericIO.writelnString("GeneralRepos generator remote exception on initSimul: " + e.getMessage());
			System.exit(1);
		}

		for (int i = 0; i < SimulPar.P / 2; i++) {
			contestants[i] = new Contestant("Contestant_" + i, i, strengthPerContestant[i], playGroundStub, benchStub, refereeSiteStub);
		}

		for (int i = SimulPar.P / 2; i < SimulPar.P; i++) {
			contestants[i] = new Contestant("Contestant_" + i, i, strengthPerContestant[i], playGroundStub, benchStub, refereeSiteStub);
		}

		/* start of the simulation */

		for (int i = 0; i < SimulPar.P; i++)
			contestants[i].start();

		/* waiting for the end of the simulation */

		GenericIO.writelnString();
		for (int i = 0; i < SimulPar.P; i++) {
			try {
				contestants[i].join();
			} catch (InterruptedException e) {
			}
			GenericIO.writelnString("The contestants " + (i + 1) + " has terminated.");
		}
		GenericIO.writelnString();


		try {
			benchStub.shutdown();
		} catch (RemoteException e) {
			GenericIO.writelnString("Coach generator remote exception on Bench shutdown: " + e.getMessage());
			System.exit(1);
		}
		try {
			refereeSiteStub.shutdown();
		} catch (RemoteException e) {
			GenericIO.writelnString("Coach generator remote exception on RefereeSite shutdown: " + e.getMessage());
			System.exit(1);
		}
		try {
			playGroundStub.shutdown();
		} catch (RemoteException e) {
			GenericIO.writelnString("Coach generator remote exception on PlayGround shutdown: " + e.getMessage());
			System.exit(1);
		}
		try {
			genReposStub.shutdown();
		} catch (RemoteException e) {
			GenericIO.writelnString("Coach generator remote exception on GeneralRepos shutdown: " + e.getMessage());
			System.exit(1);
		}
	}
}
