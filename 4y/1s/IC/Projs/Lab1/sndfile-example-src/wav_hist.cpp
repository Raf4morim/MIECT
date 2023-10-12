#include <iostream>
#include <vector>
#include <sndfile.hh>
#include "wav_hist.h"

using namespace std;

constexpr size_t FRAMES_BUFFER_SIZE = 65536;

int main(int argc, char *argv[]){

	SndfileHandle sndFile{argv[1]};
	int channel{stoi(argv[2])};
	
	if (argc != 3) throw "Usage: ../sndfile-example-bin/wav_hist <input_wav> <channel> (where midChannel = 0 and sideChannel = 1)";
	if (sndFile.error()) throw "Error: invalid input file\n";
	if ((sndFile.format() & SF_FORMAT_TYPEMASK) != SF_FORMAT_WAV) throw "Error: file is not in WAV format";
	if ((sndFile.format() & SF_FORMAT_SUBMASK) != SF_FORMAT_PCM_16) throw "Error: file is not a 16-bit PCM WAV file";
	if(channel >= sndFile.channels()) throw "Error: invalid channel requested";

	size_t nFrames;
	vector<short> samples (FRAMES_BUFFER_SIZE * sndFile.channels());
	WAVHist histograma {sndFile};
	while ((nFrames = sndFile.readf(samples.data(), FRAMES_BUFFER_SIZE))){
		samples.resize(FRAMES_BUFFER_SIZE * sndFile.channels()); 
		histograma.update(samples);	
	}
	
	if (channel == 0) histograma.midD();		// 0 corresponde ao MidChannel
	else if (channel == 1) histograma.sideD();	// 1 corresponde ao SideChannel
	else histograma.dump(size_t(channel));		// qualquer outro valor corresponde ao canal especificado
	return 0;
}
