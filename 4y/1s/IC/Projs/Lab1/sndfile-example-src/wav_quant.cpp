#include <iostream>
#include <sndfile.hh>
#include <vector>
#include "wav_quant.h"

using namespace std;

constexpr size_t FRAMES_BUFFER_SIZE = 65536;

int main(int argc, char **argv){
    SndfileHandle input{argv[1]};
    SndfileHandle output{argv[2], SFM_WRITE, input.format(), input.channels(), input.samplerate()};
    int n_bits = stoi(argv[3]);

    if (argc != 4) throw  "Usage: ../sndfile-example-bin/wav_quant <input_wav> <output_wav> <n_bits>" ;
    if (input.error()) throw "Error opening input file ";
    if ((input.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV) throw "Input file is not a WAV file";
    if ((input.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16) throw "Input file is not a 16-bit PCM WAV file";
    if (output.error()) throw "Error opening output file ";
    if (n_bits < 1 || n_bits > 15) throw "Invalid number of bits: ";

    vector<short> samples(FRAMES_BUFFER_SIZE * input.channels());
    WAVQuant quantizer{samples.size()};
    size_t n_frames;
    int length {0};
    while ((n_frames = input.readf(samples.data(), FRAMES_BUFFER_SIZE))){
        samples.resize(n_frames * input.channels());    // Redimensiona o vetor de acordo com o numero de frames lidos
        quantizer.escUn(samples, 16-n_bits);            // Escalonamento uniforme
    }
    quantizer.toFile(output);
    return 0;
}
