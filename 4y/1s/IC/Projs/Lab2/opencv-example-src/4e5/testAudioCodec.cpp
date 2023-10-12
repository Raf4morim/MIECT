#include "AudioCodec.cpp"

using namespace std;

int main(int argc, char* argv[]) {

   if(argc != 2){
        cout << "Usage: " << argv[0] << " <input_file>\n";
        return 1; 
    }
    char *iFile = argv[1];

    AudioCodec c(iFile);
    
    int operation1 = -1;
    while(!(operation1 == 0 || operation1 == 1)) {
        cout << "Escolha cada opção 0 -> lossless /1 -> lossy: ";
        cin >> operation1;
    }
    int operation2 = 0;
    while(operation2 < 1 || operation2 > 3) {
        cout << "Escolha o predictor (1, 2 or 3): ";
        cin >> operation2;
    }
    int nBitsSh = -1;
    if(operation1 == 1){
        while(nBitsSh < 0 || nBitsSh > 15) {
            cout << "Escolhe o numero de bits para deslocar: ";
            cin >> nBitsSh;
        }
    }
    c.compress("4e5/compress.txt", operation2, operation1, nBitsSh);

    c.decompress("4e5/compress.txt");
    
}  