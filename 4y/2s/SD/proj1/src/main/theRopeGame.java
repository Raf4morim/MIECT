package main;

import entities.*;
import sharedRegions.*;
import genclass.FileOp;
import genclass.GenericIO;
import java.util.ArrayList;
import java.util.List;

/**
 *   Simulation of the Assignment 1 - Game of the Rope.
 */

public class theRopeGame {

    /**
     *  Main method.
     * 
     *   @param args runtime arguments
     */

    public static void main(String[] args) {

        Coach coach[] = new Coach[SimulPar.C]; // reference to the coach threads
        Contestant contestants[] = new Contestant[SimulPar.P]; // reference to the contestant threads
        int strengthPerContestant[] = new int[SimulPar.P]; // strength of each contestant

        RefereeSite refereeSite; // reference to the referee site
        PlayGround playground; // reference to the playground
        Bench bench; // reference to the bench
        GeneralRepos repos; // reference to the general repository

        String fileName; // name of the logger file
        char opt;
        boolean success;

        /* problem initialization */

        GenericIO.writelnString("\n" + "\tThe Rope Game\n");

        do {
            GenericIO.writelnString("Logging file name? ");
            fileName = GenericIO.readlnString();
            if (FileOp.exists(".", fileName)) {
                do {
                    GenericIO.writeString("There is already a file with this name. Delete it (y - yes; n - no)? ");
                    opt = GenericIO.readlnChar();
                } while ((opt != 'y') && (opt != 'n'));
                if (opt == 'y')
                    success = true;
                else
                    success = false;
            } else
                success = true;
        } while (!success);

        /* Obtain each contestant strength */

        for (int i = 0; i < SimulPar.P; i++)
            strengthPerContestant[i] = (int) (Math.random() * 5) + 6;

        repos = new GeneralRepos(fileName);
        refereeSite = new RefereeSite(repos);
        playground = new PlayGround(repos);
        bench = new Bench(repos);

        List<Integer> playersTeam0 = new ArrayList<Integer>();
        List<Integer> playersTeam1 = new ArrayList<Integer>();

        Referee referee = new Referee("Referee_", playground, refereeSite, bench);

        for (int i = 0; i < SimulPar.P/2; i++) {
            contestants[i] = new Contestant("Contestant_" + i, i, 0, strengthPerContestant[i], playground, bench, refereeSite);
            playersTeam0.add(i);
        }

        for (int i = SimulPar.P/2; i < SimulPar.P; i++) {
            contestants[i] = new Contestant("Contestant_" + i, i, 1, strengthPerContestant[i], playground, bench, refereeSite);
            playersTeam1.add(i);
        }

        for (int i = 0; i < SimulPar.P; i++)
            referee.addContestant(i); // Referee knows the contestants ids to invoke the methods

        for (int c = 0; c < SimulPar.C; c++) {
            coach[c] = new Coach("Coach_" + c, c, (c == 0) ? playersTeam0 : playersTeam1, bench, refereeSite, playground);
            referee.addCoach(c); // Referee knows the coaches ids to invoke the methods
        }

        /* start of the simulation */

        for (int i = 0; i < SimulPar.P; i++)
            contestants[i].start();
        
        coach[0].start();
        coach[1].start();
        
        referee.start();
        /* waiting for the end of the simulation */

        GenericIO.writelnString();

        try {
            referee.join();
        } catch (InterruptedException e) {
            GenericIO.writelnString("The Referee has terminated.");
        }

        for (int i = 0; i < SimulPar.P; i++) {
            try {
                contestants[i].join();
            } catch (InterruptedException e) {
                GenericIO.writelnString("The contestants " + 1 + " has terminated.");
            }
        }

        for (int i = 0; i < SimulPar.C; i++) {
            try {
                coach[i].join();
            } catch (InterruptedException e) {
                GenericIO.writelnString("The coach " + (i + 1) + " has terminated.");
            }
        }
        GenericIO.writelnString();
    }
}