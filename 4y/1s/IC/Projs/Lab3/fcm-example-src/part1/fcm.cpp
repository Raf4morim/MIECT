#include "CircularBuffer.hpp"
#include "FiniteContextModel.hpp"
#include <fstream>
#include <iostream>
#include <ostream>
#include <cctype>
#include <locale>
#include <math.h>
#include <numeric>
#include <utility>
#include <bits/stdc++.h>
using namespace std;

FiniteContextModel::FiniteContextModel(int k, float alpha, string filename) {
    this->k = k;
    this->alpha = alpha;
    occurenceMap(filename);
}

void FiniteContextModel::occurenceMap(string filename) {
    CircularBuffer buffer(this->k + 1);
    char text_character;
    int caracters = 0;

    this->oFile.open(filename);
    for (int i = 0; i < this->k;) {
        this->oFile.get(text_character);
        if (isValidChar(text_character)) {
            buffer.putChar(text_character);
            i++;
        }
    }

    while (this->oFile.get(text_character)) {
        if (isValidChar(text_character)) {
            caracters++;
            buffer.putChar(text_character);
            string context_string = buffer.readBuffer();

            if (this->context_map.count(context_string)) {
                map<char, int> string_next_character = this->context_map.at(context_string);

                if (string_next_character.count(buffer.getLast())) {
                    int character_counter = string_next_character.at(buffer.getLast());
                    string_next_character[buffer.getLast()] = character_counter + 1;
                    this->context_map[context_string] = string_next_character;
                }
                else {
                    string_next_character.insert(make_pair(buffer.getLast(), 1));
                    this->context_map[context_string] = string_next_character;
                }
            } else { 
                map<char, int> new_map;
                new_map.insert(make_pair(buffer.getLast(), 1));
                this->context_map.insert(make_pair(context_string, new_map));
            }
        }
    }
    this->total_characters = caracters;
    this->oFile.close();
}

double FiniteContextModel::calculateEntropy() {
    double entropia_contexto;
    map<string, double> entropy;
    map<char, double> probsMap;

    for (auto strIterator = this->context_map.cbegin(); strIterator != this->context_map.cend(); strIterator++) {
        double res = accumulate(strIterator->second.cbegin(), strIterator->second.cend(), 0, [](int acc, pair<char, int> p) { return (acc + p.second); });
        entropia_contexto = 0;
        for (auto countChar = strIterator->second.cbegin(); countChar != strIterator->second.cend(); countChar++) {
            double i = (countChar->second);
            double prob = (i + alpha) / (res + (alpha * 27));
            entropia_contexto += log2(prob) * (prob);
        }
        entropy.insert(make_pair(strIterator->first, -(entropia_contexto * (res / this->total_characters))));
    }
    double final = accumulate(begin(entropy), end(entropy), 0.0, [](double acc, pair<string, double> p) { return (acc + p.second); });

    return final;
}

void FiniteContextModel::printOccurenceMap() {
    ofstream file("occurrence_map.txt");

    if (file.is_open()) {
        for (auto strIterator = this->context_map.cbegin(); strIterator != this->context_map.cend(); strIterator++) {
            file << "|" << strIterator->first << "| ";
            for (auto countChar = strIterator->second.cbegin(); countChar != strIterator->second.cend(); countChar++) {
                file << "letter: " << countChar->first << " : " << countChar->second << " | ";
            }
            file << "\n";
        }
    } else {
        cout << "ERROR!!\nUnable to open file!" << endl;
    }
    cout << "Occurrence map was written to \"occurrence_map.txt\" file" << endl;
}

int FiniteContextModel::isValidChar(char &character) {
    if (isalnum(character) || character == ' ')
        return 1;
    else
        return 0;
}

map<string, map<char, int>> FiniteContextModel::getContextMap(FiniteContextModel &fcm) { return fcm.context_map; }