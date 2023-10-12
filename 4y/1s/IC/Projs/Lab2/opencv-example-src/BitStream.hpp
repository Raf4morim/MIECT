#ifndef BITSTREAM_H
#define BITSTREAM_H
#include <iostream>
#include <fstream>
#include <string>
#include <stdlib.h>
#include <map>

using namespace std;
class BitStream {
    private:
        fstream file;
        int mode; // write = 0 / read = 1 
        unsigned char buffer;   // buffer[7] Msb , ... , buffer[0] Lsb
        int pointer; // goes from 0 to 7
        // pointer in 'r' mode points to last read bit
        // pointer in 'w' mode points to last written bit
        int size;   // file size in bytes

    public:
        BitStream();
        BitStream(const char *filename, char mode);
        unsigned char readBit();
        void writeBit(char bit);
        void readNbits(char* bits, int n);
        void writeNbits(char* bits, int n);
        bool eof();
        void close();
};

#endif