#include <iostream>
#include "BitStream.hpp"

using namespace std;

int main (int argc, char *argv[]) {	
    BitStream inputFile (argv [1], 'r') ;    
    ofstream outputFile (argv [2], ios::out) ;

    if (argc < 3) throw "Usage: ../sndfile-example-bin/decoder <input file> <output file>";
    
    if (! outputFile) throw "Error: could not open output file ";

    vector<int> bits;
    bits = inputFile.readBits(inputFile.tamanhoF() * 8);    // le todos os bits do arquivo de entrada e armazena em um vetor de inteiros 
    inputFile.close();

    for (long unsigned int i = 0; i < bits.size(); i++) outputFile << bits[i];    // escreve os bits no arquivo de saida
    outputFile.close();
    return 0;
}