#include <iostream>
#include "BitStream.hpp"

using namespace std;

int main (int argc, char *argv[]) {	
    ifstream iFile (argv [1], ios::in) ;                                 
    string oFile = argv[2];

    if (argc != 3) throw "Usage: ../sndfile-example-bin/encoder <input file> <output file>" ;
    if (! iFile) throw "Error: could not open input file." ;

    string buf;
    getline(iFile, buf);                                       
    cout << "\n" << buf << endl;                     
    iFile.close();

    BitStream oF (oFile, 'w') ;     // cria arquivo de saida com o nome passado como parametro e abre para escrita  

    vector<int> bits;
    for (long unsigned int i = 0; i < buf.length(); i++){
        bits.push_back(buf[i] - '0');
    }
    oF.writeBits(bits);
    oF.close();

    return 0;
} ; 