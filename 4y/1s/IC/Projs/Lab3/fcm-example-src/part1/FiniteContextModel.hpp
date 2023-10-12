#pragma once
#include "circularBuffer.hpp"
#include <fstream>
#include <map>
using namespace std;

class FiniteContextModel
{
    int k;
    float alpha;
    int total_characters;
    map<string, map<char,int>> context_map;
    ifstream oFile;

    public:
        FiniteContextModel(int k, float alpha, const string filename);
        void printOccurenceMap();
        double calculateEntropy();
        static map<string, map<char,int>> getContextMap(FiniteContextModel &fcm);
        static int isValidChar(char &character);
    private:
        void occurenceMap(string filename);
};