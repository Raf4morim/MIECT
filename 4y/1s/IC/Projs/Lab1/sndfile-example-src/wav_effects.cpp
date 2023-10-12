#include <iostream>
#include <fstream>
#include <sndfile.hh>
#include <vector>
#include <cmath>
#include <math.h>
#include "wav_hist.h"

using namespace std;

constexpr size_t FRAMES_BUFFER_SIZE = 65536;

int main(int argc, char **argv){
    SndfileHandle input{argv[1]};
    SndfileHandle output{argv[2], SFM_WRITE, input.format(), input.channels(), input.samplerate()};
    if (argc != 4) throw "Usage: ../sndfile-example-bin/wav_effects <input_wav> <output_wav> <effect>";
    if (input.error()) throw "Error opening input file";
    if ((input.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV) throw "Input file is not a WAV file";
    if ((input.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16) throw "Input file is not a 16-bit PCM WAV file";
        
    string effect = argv[3];
    if (effect != "SingleEcho" && effect != "MultipleEcho" && effect != "AmplitudeModulation" && effect != "reverse")
        throw " Must be one of the following: singleEcho, multipleEcho, amplitudeModulation, reverse";
    
    float ganho = 0.0;
    int atraso = 0;
    float frequencia = 0.0;

     if (effect == "SingleEcho"){
         cout << "SingleEcho" << endl;
         cout << "Digite o ganho: ";
         cin >> ganho;
         cout << "Digite o atraso: ";
         cin >> atraso;
     }else if (effect == "MultipleEcho"){
        cout << "MultipleEcho" << endl;
    cout << "Digite o ganho: ";
        cin >> ganho;
        cout << "Digite o atraso: ";
        cin >> atraso;
    }else if (effect == "AmplitudeModulation"){
        cout << "AmplitudeModulation" << endl;
        cout << "Digite a frequencia: ";
        cin >> frequencia;
    }else{
    throw "Must be one of the following: singleEcho, multipleEcho, amplitudeModulation";
}

    vector<short> samples(FRAMES_BUFFER_SIZE * input.channels());
    vector<short> out_smp;
    out_smp.resize(0);
    size_t nFrames;
    short sample_out;

    if (effect == "SingleEcho" || effect == "MultipleEcho"){
        while (nFrames = input.readf(samples.data(), FRAMES_BUFFER_SIZE)){
            samples.resize(nFrames * input.channels() );                    
            if(effect == "SingleEcho"){
                for (int i = 0; i < (int)samples.size(); i++){
                    if(i >= atraso) sample_out = (samples.at(i) + ganho * samples.at(i - atraso))/ (1 + ganho); // y(n) =  x(n) + g * x(n - atraso) / (1 + g)
                    else sample_out = samples.at(i);    // Passa para a saida o valor do sample
                    out_smp.insert(out_smp.end(), sample_out);
                }
            }else if (effect == "MultipleEcho"){
                for (int i = 0; i < (int)samples.size(); i++){
                    if(i >= atraso) sample_out = (samples.at(i) + ganho * out_smp.at(i - atraso))/ (1 + ganho);     //y(n) = x(n) + g*y(n - atraso) / (1 + g)
                    else sample_out = samples.at(i); 
                    out_smp.insert(out_smp.end(), sample_out);
                }         
            } 
        } 
    } else if (effect == "AmplitudeModulation"){   
        while (nFrames = input.readf(samples.data(), FRAMES_BUFFER_SIZE)){
            samples.resize(nFrames * input.channels() );
            for (int i = 0; i < (int)samples.size(); i++){
                sample_out = samples.at(i) * cos(2 * M_PI * i * (frequencia/ input.samplerate()));      //y(n) = x(n) * cos(2 * pi * n * (f / fs))
                out_smp.insert(out_smp.end(), sample_out);
            }
        }
    }
    output.writef(out_smp.data(), out_smp.size() / input.channels());
}