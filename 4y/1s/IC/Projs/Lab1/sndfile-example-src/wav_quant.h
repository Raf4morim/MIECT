#ifndef WAVQUANT_H
#define WAVQUANT_H

#include <iostream>
#include <vector>

using namespace std;

class WAVQuant{
private:
    vector<short> quantizado;
    size_t n_frames;

public:
    WAVQuant(size_t n_frames){
        this->n_frames = n_frames;
        quantizado.resize(n_frames);
    }
    void escUn(vector<short> &samples, int n_bits){         // Escala uniforme
        short sampleCut;
        for (auto& sample : samples) {
            sample = sample >> n_bits;                      // perde o numero de bits escolhidos
            sampleCut = sample << n_bits;                   // devolve o mesmo numero sem os bits tirados fora
            quantizado.insert(quantizado.end(), sampleCut); // inserimos no vetor
        }
    }
    void toFile(SndfileHandle output) const{
        output.write(quantizado.data(), quantizado.size()); // escreve no arquivo de saida os valores quantizados
    }
};

#endif
