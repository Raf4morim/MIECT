#include "Golomb.hpp"
#include "../BitStream.hpp"
#include <math.h>
#include <cstdlib>

using namespace std;

////////////////////////////////////////////////////////////
int cvtArrayFromBinToInt(char arr[], int size){
    int res=0;
    for(int i=0;i<size;i++){
        if(arr[i] != 0x00){
            res+=pow(2, i);
        }
    }
    return res;
}

string cvtIntToStrBin(int value, int numBits){
    string tmp = "";
    while (value != 0){
        tmp += ( value % 2 == 0 ? '0' : '1' );
        value /= 2;
        numBits --;
    }
    while(numBits != 0){
        tmp += '0';
        numBits--;
    }
    return tmp;
}
////////////////////////////////////////////////////////////

Golomb::Golomb(const char *filename, char mode, int mvalue){
    if (mode != 'd' && mode != 'e'){
        cout << "ERROR: invalid mode!" << endl;
        exit(EXIT_FAILURE);
    }
    if (mode == 'd')
        file = BitStream(filename, 'r');
    else
        file = BitStream(filename, 'w');
    m = mvalue;
    b =  ceil(log2(m));
}

int Golomb::encode(int n){
    n = fold(n);
    int q = floor((int)(n / m));
    int r = n - q*m;
    int numbits;
    int value;

    if (m!=0 && (m & (m-1)) == 0){      //If m is power of two 
        value = r;
        numbits = b;
    }
    else{
        if (r < pow(2, b) - m){         //If m is not power of two
            value =  r; 
            numbits = b-1;
        }
        else{
            value = r + pow(2, b) - m;
            numbits = b;
        }
    }
    
    string tmp;
    int numbitstmp = numbits;

    while (value != 0){
        tmp += ( value % 2 == 0 ? '0' : '1' );
        value /= 2;
        numbitstmp --;
    }
    while(numbitstmp != 0){
        tmp+= '0';
        numbitstmp--;
    }

    int size = numbits;
    size++;
    for (int i = 0 ; i < q; i++){
        file.writeBit('1');
        size++;
    }
    file.writeBit('0');

    for(int i = numbits-1; i >= 0; i-- )
        file.writeBit(tmp[i]);
    return size;
}

int Golomb::decode(){
    int A = 0;
    int R = 0;

    char c;
    while(true){
        c = file.readBit();
        if((c & 0x01) == 0x00)
            break;
        A++;
    }

    if (m!=0 && (m & (m-1)) == 0){
        char binary[b];
        file.readNbits(binary,b);
        int tmp = 0;
        for( int i = b-1; i >= 0; i--){
            if(binary[i] != 0x0)
                R+= pow(2, tmp);
            tmp++;
        }
        
        return unfold(m*A + R);         //Calculo do valor decoded
    }else{
        int tmp = 0;
        char binary[b];
        file.readNbits(binary,b-1);
        binary[b-1] = 0;

        for (int i = b-2; i >= 0; i--){ //Extrair b-1 MSBs e calcula R em decimal
            if(binary[i] != 0x00)
                R+= pow(2, tmp);
            tmp++;
        } 
 
        if(R < pow(2, b) - m){
            return unfold(m*A + R);
        }else{                          //Extrair b MSBs e calcula R em decimal
            binary[b-1] = file.readBit();
            R=0, tmp=0;
            for (int i = b-1; i >= 0; i--){
                if(binary[i] != 0x0)
                    R+= pow(2, tmp);
                tmp++;
            }
            return unfold(m*A + R - (pow(2, b) - m)); 
        }
    }
    return 0;
}

int Golomb::fold(int n){
    if (n >= 0)
        return n*2;
    else
        return abs(n)*2-1;
}


int Golomb::unfold(int n){
    if (n % 2 == 0)
        return n/2;
    return (-1)*ceil(n/2)-1;
}

void Golomb::close(){
    file.close();
}

void Golomb::encodeM(int m){
    string s = cvtIntToStrBin(m, 32);
    char space[32];

    for(int i = 0; i < 32; i++){
        space[i] = s[i];
    }

    file.writeNbits(space, 32);
}

int Golomb::decodeM(){
    char space[32];
    file.readNbits(space, 32);
    return cvtArrayFromBinToInt(space, 32);
}

void Golomb::setM(int mi){
    this->m = mi;
    b =  ceil(log2(m));
}

void Golomb::encodeHS(int nFrames, int sampleRate, int Channels, int format, bool lossy){
    string header;
    if(lossy)                                   // 1 bit(0->Lossless, 1->Lossy)
        header = '1';
    else
        header = '0';
    header += cvtIntToStrBin(nFrames, 32);      // Number of samples 32 bits
    header += cvtIntToStrBin(sampleRate, 32);   // Sample Rate 32 bits
    header += cvtIntToStrBin(format,32);        // Format 32 bits
    header += cvtIntToStrBin(Channels, 4);      // Channels 4 bits

    char hdr[101];
    for(int i=0; i < 101; i++)
        hdr[i] = header[i];
    file.writeNbits(hdr, 101);
}

void Golomb::encodeShift(int amt){
    string sh = cvtIntToStrBin(amt, 5);
    char h[5];
    for(int i=0; i < 5; i++)
        h[i] = sh[i];
    file.writeNbits(h, 5);
}

int Golomb::decodeShift(){
    char sh[5];
    file.readNbits(sh, 5);
    return cvtArrayFromBinToInt(sh,5);
}

void Golomb::decodeHS(int arr[]){
    
    char option = file.readBit();
    char rd[32];
    char nc[4];
    arr[0] = int(option&0x1);               //Arr[0] is codecoption (lossy or lossless)
    file.readNbits(rd, 32);                
    arr[1] = cvtArrayFromBinToInt(rd,32);   //Arr[1] is num of samples
    file.readNbits(rd, 32);
    arr[2] = cvtArrayFromBinToInt(rd,32);   //Arr[2] is Sample Rate
    file.readNbits(rd, 32);
    arr[3] = cvtArrayFromBinToInt(rd,32);   //Arr[3] is num of samples
    file.readNbits(nc, 4);
    arr[4] = cvtArrayFromBinToInt(nc,4);    //Arr[4] is num of channels
}

void Golomb::encodeMode(int mode){
    char x = (mode == 0) ? '0' : '1';
    file.writeBit(x);
}

int Golomb::decodeMode(){
    return (int) (file.readBit() & 0x01);
}