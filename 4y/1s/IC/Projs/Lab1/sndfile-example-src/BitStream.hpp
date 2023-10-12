#include <fstream>
#include <vector>
#include <string>
#include <iostream>
#include <bitset>

using namespace std;

class BitStream {
    private:
        struct BitBuffer{                   
            unsigned char byte = 0;
            int contagem = 0;
        };
        BitBuffer bitBuffer;
        fstream ficheiro;
        char modo;

        int ficheiroSize;
        vector<vector<int>> byteV;      
        vector<int> bitV;
        int currentArrayPos = 0;

    public:
        BitStream(string filename, char mode) {
            modo = mode;
            if (mode == 'r'){                 // Abre o ficheiro para leitura e guarda o tamanho do ficheiro
                ficheiro.open(filename, ios::in | ios::binary);
                ficheiroSize = tamanhoF();
            } else if (mode == 'w') {         // Abre o ficheiro para escrita
                ficheiro.open(filename, ios::out | ios::binary);
            } else {
                throw "Invalid mode";
            }
        }
        int tamanhoF() {
            ficheiro.seekg(0, ios::end);       // Coloca o ponteiro no fim do ficheiro
            int size = ficheiro.tellg();       // Guarda o valor do ponteiro
            ficheiro.seekg(0, ios::beg);       // Volta o ponteiro para o inicio do ficheiro
            return size;
        }
        vector<int> revbitV(){
            vector<int> bitV;
            for (int i = 0; i < 8; i++){       
                bitV.push_back((bitBuffer.byte >> i) & 1); // Adiciona ao vector bitV o valor do bit
            }
            vector<int> reversedbitV;
            for (int i = 7; i >= 0; i--){
                reversedbitV.push_back(bitV[i]);    
            }
            return reversedbitV;
        }
 
        int readBit() {
            if (modo != 'r') throw "Invalid mode";
            if (bitBuffer.contagem == 0) {                  // Quando o bitBuffer estiver vazio
                ficheiro.read((char*)&bitBuffer.byte, 1);   // Le o proximo byte do ficheiro
                bitV = revbitV();                           // Inverte o vector bitV
            }
            int bit = bitV[bitBuffer.contagem];             // Guarda o valor do bit
            bitBuffer.byte <<= 1;                           // Desloca o byte para a esquerda
            bitBuffer.contagem -= 1;                        // Decrementa o contador
            return bit;
        }

        vector<int> readBits(int n) {
            if (modo != 'r') throw "Invalid mode";
            vector <int> outBits;
            for(int i = 0; i < n; i++){
                if (bitBuffer.contagem == 0) {               // Quando o bitBuffer estiver vazio
                    ficheiro.read((char*)&bitBuffer.byte, 1);// Le o proximo byte do ficheiro
                    bitV = revbitV();                        // Inverte o vector bitV
                }
                outBits.push_back(bitV[bitBuffer.contagem]); // Guarda o valor do bit
                bitBuffer.contagem++;                        // Incrementa o contador
                if (bitBuffer.contagem == 8) {               
                    bitBuffer.contagem = 0;                  
                }
            }
            return outBits;
        }

        void writeBit(int bit) {
            if (modo != 'w') throw "Invalid mode";          
            if (bitBuffer.contagem == 8){
                vector<int> invbitV;
                bitBuffer.byte = 0;
                for (int i = 0; i < 8; i++){
                    invbitV.push_back(bitV[7-i]);           // Inverte o vector bitV
                    bitBuffer.byte |= invbitV[i] << i;      // Adiciona o valor do bit ao byte
                }
                char byte = bitBuffer.byte;                 
                ficheiro.write(&byte, 1);                   // Escreve o byte no ficheiro
                bitBuffer.contagem = 0;                     
            }
            if (bitBuffer.contagem == 0){
                bitV = std::vector<int>(8);                 // Inicializa o vector bitV com 8 bits a 0
            }
            bitV[bitBuffer.contagem] = bit;
            bitBuffer.contagem++;
        }

        void writeBits(std::vector<int> bits) {
            if (modo != 'w') throw "Invalid mode";
            
            int c = 0;
            for(int sz = bits.size(); sz > 0; sz--){
                if (bitBuffer.contagem == 8){
                    vector<int> invbitV;
                    bitBuffer.byte = 0;
                    for (int i = 0; i < 8; i++){
                        invbitV.push_back(bitV[7-i]);       // Inverte o vector bitV
                        bitBuffer.byte |= invbitV[i] << i;  // Adiciona o valor do bit ao byte
                    }
                    char byte = bitBuffer.byte;             
                    ficheiro.write(&byte, 1);               // Escreve o byte no ficheiro
                    bitBuffer.contagem = 0;
                }
                if (bitBuffer.contagem == 0){
                    bitV = std::vector<int>(8);             // Inicializa o vector bitV com 8 bits a 0
                }
                bitV[bitBuffer.contagem] = bits[c];
                bitBuffer.contagem++;
                c++;
            }
        }
        void close(){
            vector<int> invbitV;
            if (modo == 'w'){
                for (long unsigned int i = 0; i <= byteV.size(); i++){
                    bitBuffer.byte = 0;
                    for (int i = 0; i < 8; i++){
                        invbitV.push_back(bitV[7-i]);
                        bitBuffer.byte |= invbitV[i] << i;
                    }
                    ficheiro.write((char*)&bitBuffer.byte, 1);
                }
            }
            ficheiro.close();
        }
};