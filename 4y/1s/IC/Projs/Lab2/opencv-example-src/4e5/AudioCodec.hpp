#ifndef AUDIOCODEC_H
#define AUDIOCODEC_H

#include "../3/Golomb.cpp"

#include <iostream>
#include <stdio.h>
#include <sndfile.h>
#include <math.h>
#include <vector>
#include <map>

using namespace std;

class AudioCodec{

    public:
        /**
         * @brief Construct a new Audio Codec object
         * 
         */
        AudioCodec();

        /**
         * @brief Construct a new Audio Codec object
         * 
         * @param fileSrc filename path to an audio file
         */
        AudioCodec(const char *fileSrc);

        /**
         * @brief Compress an audio file
         * 
         * @param fileDst filename path to a file to store the encoded value
         * @param num value to choose the order of the predictor that will be use. 
         * Choosing 1, the predictor will only consider the previous value; 2 it will consider the 2 previous values; and choosing 3 will consider the 3 previous values.
         * @param lossy value to choose between lossless (0) and lossy (1) encoding.
         * @param num_bits_shift number of bits to be shifted in the predictor
         */
        void compress(const char *fileDst, int num, bool loosy, int num_bits_shift);

        /**
         * @brief Decompress an audio file

         * @param fileSrc path to a file were the stored enconded value is.
         */
        void decompress(const char *fileSrc);

        /**
         * @brief Lossless Preditor 

         * @param audioSamples vector that contains all the samples of the audio file.
         */    
        void preditor(std::vector<short> audioSamples);

         /**
         * @brief Lossy Preditor 
         
         * @param audioSamples vector that contains all the samples of the audio file.
         * @param num_bits_shift number of bits to be shifted in the predictor
         */   
        void preditorLossy(vector<short> audioSamples, int num_bits_shift);

    private:
        char* fileSrc;
        SF_INFO sfinfo;
        int inputN;
        std::vector<short> channels = {};
        std::vector<short> rn = {};
};
#endif
