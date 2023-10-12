#include <iostream>
#include <vector>
#include <sndfile.hh>
#include <cmath>

using namespace std;

constexpr size_t FRAMES_BUFFER_SIZE = 65536;

int main(int argc, char **argv) {
  SndfileHandle input1 { argv[1] };
  SndfileHandle input2 { argv[2] };

  if(argc != 3) throw  "Usage: ../sndfile-example-bin/wav_cmp <input1_wav> <inputQuant_wav>";
  if(input1.error() || input2.error()) throw "Error opening one of the files";
  if((input1.samplerate() * input1.channels()) != (input2.samplerate() * input2.channels())) throw "Input files have different sample rate";
  if((input1.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV) throw "Input file is not a WAV file";
  if((input2.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV) throw "Input file2 is not a WAV file";
  if((input1.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16) throw "Input file1 is not a 16-bit PCM WAV file";
  if((input2.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16) throw "Input file2 is not a 16-bit PCM WAV file";
  if(input1.channels() != input2.channels()) throw "Input files have different number of channels";

  vector <double> origFile(FRAMES_BUFFER_SIZE * input1.channels());
  vector <double> quantFile(FRAMES_BUFFER_SIZE * input2.channels());

  size_t  n_frames_origFile;
  size_t  n_frames_quantFile;

  double errTempor, errM = 0;
  double totalSamples = input1.samplerate() * input1.channels();
  double x = 0,  r = 0; // energia, ruido
  double snr;
  while(n_frames_origFile = input1.readf(origFile.data(), FRAMES_BUFFER_SIZE), n_frames_quantFile = input2.readf(quantFile.data(), FRAMES_BUFFER_SIZE)) {
    origFile.resize(n_frames_origFile * input1.channels()); 
    quantFile.resize(n_frames_origFile * input2.channels());  // redefinir o tamanho do vector para o tamanho do ficheiro
    // Percorrer a matriz td de samples
    for(long unsigned int i = 0; i < origFile.size(); i++){
        x += pow(abs(origFile[i]), 2); // Somatorio de x^2
        errTempor = abs(origFile[i] - quantFile[i]); // Erro temporario
        r += pow(errTempor, 2); // Somatorio do ruido 
        if(errTempor > errM) errM = errTempor; // Erro maximo
    }
  }

  snr = 10 * log10(x/r);  // ruido/normal
  cout << "SNR is " << snr << endl;
  cout << "Maximum per sample absolute error is " << errM << endl;

  return 0;

}
