#ifndef WAVHIST_H
#define WAVHIST_H

#include <iostream>
#include <vector>
#include <map>
#include <sndfile.hh>
#include <fstream>

class WAVHist
{
private:
	std::map<short, size_t> mid_ch;
	std::map<short, size_t> side_ch;
	std::vector<std::map<short, size_t>> c;

public:
	WAVHist(const SndfileHandle & sfh){
		c.resize(sfh.channels());			// redefinimos o tamanho do vector c para o numero de canais do ficheiro de audio
	}

	void update(const std::vector<short> & samples){
		for(int i=0; i < (int) samples.size()/2; i+=2){	// percorremos de 2 em 2 porque 1 deles corresponde ao MidChannel e o outro ao SideChannel
			c[0][samples[i]]++;				// incrementamos o valor da chave correspondente ao valor do sample no canal 0			
			c[1][samples[i+1]]++;			// incrementamos o valor da chave correspondente ao valor do sample no canal 1
			mid_ch[(samples[i] + samples[i+1]) / 2]++;	// Soma-se os 2 e divide-se por 2 para obter o valor do sample no canal mid
			side_ch[(samples[i] - samples[i+1]) / 2]++; // Subtrai-se os 2 e divide-se por 2 para obter o valor do sample no canal side
		}
	}


	void midD(void) {
		std::ofstream midFile("midChannel.dat");
		for (auto [valor, cont] : mid_ch)		// Percorre o map mid_ch
			midFile << valor << '\t' << cont << '\n';	// Escreve no ficheiro midChannel.dat o valor do sample e o numero de vezes que aparece
		midFile.close();
	}

	void sideD(void) {
		std::ofstream sideFile("sideChannel.dat");
		for (auto [valor, cont] : side_ch)		// Percorre o map side_ch
			sideFile << valor << '\t' << cont << '\n';	// Escreve no ficheiro sideChannel.dat o valor do sample e o numero de vezes que aparece
		sideFile.close();
	}

	void dump(const size_t channel) const{ 
		std::ofstream oF("channel.dat");
		for (auto [valor, cont] : c[channel])	// Percorre o map c[channel]
			oF << valor << '\t' << cont << '\n';	// Escreve no ficheiro channel.dat o valor do sample e o numero de vezes que aparece
		oF.close();
	}
};

#endif
