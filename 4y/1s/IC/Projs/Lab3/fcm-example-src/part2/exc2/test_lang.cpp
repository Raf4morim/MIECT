#include "../../part1/FiniteContextModel.hpp"
#include "Lang.cpp"
#include <iostream>
#include <sstream>
using namespace std;

int main(int argc, char *argv[]){
    
    if (argc == 5){
        stringstream toInt(argv[1]);
        int k = 0;
        toInt >> k;

        stringstream toFloat(argv[2]);
        float alpha = 0;
        toFloat >> alpha;
        
        Lang lang  = Lang(k, alpha, argv[3], argv[4]);

        stringstream toString(argv[3]);
        string refText;
        toString >> refText;

        string tmp = refText.substr(22, refText.size()), str = tmp.substr(0, tmp.find("_"));

        double bits = lang.calculateBits();
        cout << "Number of bits needed (" << str << "): " << bits << " per symbol" << endl;
    }else throw  "ERROR!\nUsage <bin path> <k> <alpha> <reference text file path> <analysis text file path>";
}