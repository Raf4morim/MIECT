#!/bin/bash

# function to perform cleanup actions
function cleanup {
    echo -e "\nCleaning up before terminating..."
    # add your cleanup actions here
    exit 0
}

# register the cleanup function to be executed on SIGINT (Ctrl + C) signal
trap cleanup SIGINT

# navigate to the correct directory
cd "$(dirname "$0")"

# delete "runs/" directory if it exists
if [ -d "../runs" ]; then
    echo "Deleting existing runs directory..."
    rm -r ../runs
fi

# create the "runs" folder if it doesn't exist
mkdir -p ../runs

# compile the program to the "bin/" directory
javac -d ../bin -cp ../lib/genclass.jar:./entities:./sharedRegions main/theRopeGame.java entities/*.java sharedRegions/*.java main/*.java

# check if the compilation was successful
if [ $? -ne 0 ]; then
    echo "Compilation failed. Exiting."
    exit 1
fi

# run the program 10 times
echo -e "\nLet runs until n.0 10"
for i in {1..2}
do
    echo -e "\nRun n.o $i"
    
    # automatically generate filename like "run1", "run2", etc.
    filename="../runs/run$i"
    
    # generate input data
    echo "../runs/run$i.log" | java -cp ../bin:../lib/genclass.jar main.theRopeGame > "$filename"
done
