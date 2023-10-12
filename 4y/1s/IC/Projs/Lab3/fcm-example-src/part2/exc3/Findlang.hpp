#include <string>
#include <vector>
#include <map>
#include <memory>

using namespace std;


class Findlang{
    vector<string> iRefTxt;
    map<string, map<char,int>> ref_text_models[20];
    float alpha;
    int k;
    public:
        string guessLanguage(string filename); 
        Findlang(int k, float alpha, vector<string> iRefTxt);
};