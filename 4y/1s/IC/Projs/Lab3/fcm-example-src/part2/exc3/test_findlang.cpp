#include "../exc2/Lang.hpp"
#include "Findlang.hpp"
#include <iostream>
#include <ostream>
#include <sstream>
using namespace std;

int main(int argc, char *argv[]) {
    if (argc == 3) {
        string analysis_texts_path = "fcm-example-src/textos/";

        vector<string> ref_texts = {"fcm-example-src/exemplos/en.txt", "fcm-example-src/exemplos/pt.txt",
                                    "fcm-example-src/exemplos/es.txt", "fcm-example-src/exemplos/fr.txt",
                                    "fcm-example-src/exemplos/it.txt"};
        stringstream toInt(argv[1]);
        int k = 0;
        toInt >> k;

        stringstream toFloat(argv[2]);
        float alpha = 0;
        toFloat >> alpha;

        Findlang findlang = Findlang(k, alpha, ref_texts);

        cout << "Welcome to the Language Guessing Program!" << endl;

        string user_input;
        while (true) {
            cout << "Insert the name of the text: " << endl;
            cout << "> ";
            cin >> user_input;
            cout << "\nLooking for language...\n" << "-> " << user_input << "\n" << endl;

            string lang = findlang.guessLanguage(analysis_texts_path + user_input);
            cout << "\nThe language of text is " << lang << "\n" << endl;

            cout << "Again, with another text? (y/n) " << endl;
            cin >> user_input;

            if (user_input == "n")
                break;
        }
    } else {
        cout << "ERROR!\nUsage <bin path> <k> <alpha>" << endl;
        exit(1);
    }
}