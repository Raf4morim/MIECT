#ifndef GOLOMB_H
#define GOLOMB_H

#include "../BitStream.cpp"
#include <math.h> 

using namespace std;

/**
 * Class for encoding and decoding values using golomb code.
 */
class Golomb {
    public:
        Golomb(const char *filename, char mode, int mvalue);
        int encode(int n);
        int decode();
        int fold(int n);
        int unfold(int n);
        void close();
        void encodeM(int n);
        int decodeM();
        void setM(int mi);
        void encodeHS(int nFrames, int sampleRate, int Channels, int format, bool lossy);
        void encodeShift(int shamt);
        int decodeShift();
        void decodeHS(int arr[]);
        void encodeMode(int mode);
        int decodeMode();

    private:
        BitStream file; 
        int m; 
        int b;
};

#endif