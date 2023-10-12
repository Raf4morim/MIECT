#include "Lang.hpp"
#include "../../part1/FiniteContextModel.hpp"
#include <fstream>
#include <iostream>
#include <map>
#include <math.h>
#include <numeric>
#include <vector>
using namespace std;

Lang::Lang(int k, float alpha, string ref_text, string analysis_text) {
    this->k = k;
    this->alpha = alpha;
    this->analysis_text.open(analysis_text);
    FiniteContextModel ref =
        FiniteContextModel(k, alpha, ref_text);
    this->ref_text_map = FiniteContextModel::getContextMap(ref);
}

double Lang::calculateBits() {
    double bits = 0.0, ocorr, prob;
    int res = 0;
    char text_character;

    map<char, int> submodelsRefTxt;

    CircularBuffer buffer(this->k + 1);
    for (int i = 0; i < this->k;) {
        this->analysis_text.get(text_character);
        if (FiniteContextModel::isValidChar(text_character)) {
            buffer.putChar(text_character);
            i++;
        }
    }

    while (this->analysis_text.get(text_character)) {
        if (FiniteContextModel::isValidChar(text_character)) {
            buffer.putChar(text_character);
            string analysis_file_context = buffer.readBuffer();

            if (this->ref_text_map.count(analysis_file_context)) {
                submodelsRefTxt = ref_text_map.at(analysis_file_context);
                res = accumulate(submodelsRefTxt.cbegin(), submodelsRefTxt.cend(), 0,
                                 [](int acc, pair<char, int> p) { return (acc + p.second); });

                if (submodelsRefTxt.count(text_character)) {
                    ocorr = submodelsRefTxt.at(text_character);
                    prob = (ocorr + this->alpha) / (res + (this->alpha * 27));
                    bits += (log2(prob) * -1);
                } else {
                    ocorr = 0;
                    prob = (ocorr + this->alpha) / (res + (this->alpha * 27));
                    bits += (log2(prob) * -1);
                }
            }else {
                ocorr = 0;
                prob = (ocorr + this->alpha) / (res + (this->alpha * 27));
                bits += (log2(prob) * -1);
            }
        }
    }
    this->analysis_text.close();
    return (bits / 27);
}

double Lang::calculateBits(int k, float alpha, map<string, map<char, int>> &ref_text, string filename) {
    double bits = 0.0, ocorr = 0, prob = 0;
    int res = 0;
    char text_character;
    ifstream analysis_text;
    analysis_text.open(filename);

    map<char, int> submodelsRefTxt;

    CircularBuffer buffer(k + 1);
    for (int i = 0; i < k;) {
        analysis_text.get(text_character);
        if (FiniteContextModel::isValidChar(text_character)) {
            buffer.putChar(text_character);
            i++;
        }
    }

    while (analysis_text.get(text_character)) {
        if (FiniteContextModel::isValidChar(text_character)) {
            buffer.putChar(text_character);
            string analysis_file_context = buffer.readBuffer();
            if (ref_text.count(analysis_file_context)) {
                submodelsRefTxt = ref_text.at(analysis_file_context);
                res = accumulate(submodelsRefTxt.cbegin(), submodelsRefTxt.cend(), 0,[](int acc, pair<char, int> p) { return (acc + p.second); });

                if (submodelsRefTxt.count(text_character)) {
                    ocorr = submodelsRefTxt.at(text_character);
                    prob = (ocorr + alpha) / (res + (alpha * 27));
                    bits += (log2(prob) * -1);
                } else {
                    ocorr = 0;
                    prob = (ocorr + alpha) / (res + (alpha * 27));
                    bits += (log2(prob) * -1);
                }
            } else {
                ocorr = 0;
                prob = (ocorr + alpha) / (res + (alpha * 27));
                bits += (log2(prob) * -1);
            }
        }
    }

    analysis_text.close();
    return (bits / 27);
}

void Lang::loadRefTextModels(int k, float alpha, vector<string> idiomas,map<string, map<char, int>> ref_text_models[]) {
    map<string, map<char, int>> ref_text_map;
    cout << "Getting language model into memory! " << endl;
    for (long unsigned int i = 0; i < idiomas.size(); i++) {
        FiniteContextModel ref = FiniteContextModel(k, alpha, idiomas.at(i));
        ref_text_map = FiniteContextModel::getContextMap(ref);
        ref_text_models[i] = ref_text_map;
        cout << idiomas.at(i) << endl;
    }
}