#include "FiniteContextModel.hpp"
#include <iostream>
#include <sstream>
using namespace std;

int main(int argc, char *argv[]) {
    if (argc == 4) {
        stringstream toInt(argv[1]);
        int k = 0;
        toInt >> k;

        stringstream toFloat(argv[2]);
        float alpha = 0;
        toFloat >> alpha;

        FiniteContextModel fcm = FiniteContextModel(k, alpha, argv[3]);
        fcm.printOccurenceMap();
        double entropy = fcm.calculateEntropy();
        cout << "Entropy of the file: " << entropy << endl;
    } else {
        cout << "ERROR!\nUsage <bin path> <k> <alpha> <text_path>" << endl;
        exit(1);
    }
}