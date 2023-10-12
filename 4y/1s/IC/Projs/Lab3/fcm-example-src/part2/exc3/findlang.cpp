#include "Findlang.hpp"
#include "../exc2/Lang.hpp"
#include <iostream>
#include <vector>

using namespace std;

Findlang::Findlang(int k, float alpha, vector<string> iRefTxt) {
    this->k = k;
    this->alpha = alpha;
    this->iRefTxt = iRefTxt;
    Lang::loadRefTextModels(k, alpha, iRefTxt, this->ref_text_models);
}

string Findlang::guessLanguage(string filename) {
    cout << "Comparing...\n" << endl;

    double max_bits = __DBL_MAX__;
    int index = -1;

    for (long unsigned int i = 0; i < this->iRefTxt.size(); i++) {
        double bits = Lang::calculateBits(this->k, this->alpha, this->ref_text_models[i], filename);

        cout << this->iRefTxt.at(i) << ": " << bits << " bits per symbol" << endl;

        if (bits < max_bits) {
            max_bits = bits;
            index = i;
        }
    }
    string str = this->iRefTxt.at(index), tmp = str.substr(22, str.size()), lang = tmp.substr(0, tmp.find("_"));
    return lang;
}