# How to compile:

Go to the diretory with make file -> ./Lab1/sndfile-example-src/
### 1:
    > make

### 2:
    Change the CMakeLists.txt
    > make
    > ../sndfile-example-bin/wav_hist input_wav channel
    Exemplo: ../sndfile-example-bin/wav_hist sample.wav mid
  
### 3:
    Change the CMakeLists.txt
    > make
    > ../sndfile-example-bin/wav_quant sample.wav sampleQuant.wav 2
    reduce 14 bits by original input
  
### 4:
    Change the CMakeLists.txt
    > make
    > ../sndfile-example-bin/wav_cmp sample.wav sampleQuant.wav
    Check the SNR and maximum per sample absolute error
    
### 5:
    Change the CMakeLists.txt
    > make
    > ../sndfile-example-bin/wav_effects sample.wav sampleSingle.wav SingleEcho
    > Ganho: 2                    |OR         > Frequencia: 1
    > Atraso: 40000               |
    
### 6:
    It's a class, not executable
   
### 7:
    Change the CMakeLists.txt
    > make
    > ../sndfile-example-bin/encoder exemplo.texto encExemplo.txt
    
<br>
    
    Change the CMakeLists.txt
    > make
    > ../sndfile-example-bin/decoder encExemplo.txt decExemplo.txt
