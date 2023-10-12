#include "../../part1/FiniteContextModel.hpp"

#include <vector>
#include <map>
#include <fstream>
using namespace std;


class Lang{
    int k;
    float alpha;
    map<string, map<char,int>> ref_text_map;
    ifstream analysis_text;

    public:
        Lang(int k, float alpha, string reference_text, string analysis_text);
        double calculateBits();
        static double calculateBits(int k, float alpha, map<string, map<char,int>> &ref_text_map, string filename);
        static void loadRefTextModels(int k, float alpha, vector<string> ref_text, map<string, map<char, int>> ref_text_models[]);
};