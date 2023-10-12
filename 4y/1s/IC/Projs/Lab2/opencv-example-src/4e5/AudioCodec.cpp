#include "AudioCodec.hpp"

AudioCodec::AudioCodec(){}

AudioCodec::AudioCodec(const char *fileSrc){
    
    SNDFILE *infile;
    int readcount;
    short ch[2];

	if (! (infile = sf_open (fileSrc, SFM_READ, &sfinfo))) throw "File doesn't exists";
    while ((readcount = (int) sf_readf_short (infile, ch, 1)) > 0) {
        channels.push_back(ch[0]);
        channels.push_back(ch[1]);
    }
    
	sf_close (infile) ;  
}

void AudioCodec::compress(const char *fileDst, int num, bool lossy, int nBitsShift){

    inputN = num;

    if(lossy)
        preditorLossy(channels, nBitsShift);
    else
        preditor(channels);

    Golomb g(fileDst,'e', 0);

    double m = 0;

    for(int i = 0; i < rn.size(); i++) {
        m += g.fold(rn[i]);
    }
    m = m/rn.size();
    m = (int) ceil(-1/(log2(m/(m+1))));

    g.setM(m);
    g.encodeM(m);
    g.encodeHS(sfinfo.frames, sfinfo.samplerate, sfinfo.channels, sfinfo.format, lossy);
    
    if(lossy)
        g.encodeShift(nBitsShift);
    for(int i = 0; i < rn.size(); i++) {
        
        g.encode(rn[i]);
    }
    g.close();

}

void AudioCodec::decompress(const char *fileSrc){

    Golomb g(fileSrc, 'd', 0);

    int m = g.decodeM();

    g.setM(m);

    int decodeHSnd[5]; 
    g.decodeHS(decodeHSnd);

    vector<short> resChannels, resLeft, resRight, resXl, resXr;

    if(decodeHSnd[0] == 1){
        int nBitsShift = g.decodeShift();
        for(int i = 0; i < decodeHSnd[1]*decodeHSnd[4]; i++){
            resChannels.push_back(g.decode() << nBitsShift) ;
        }
    }
    else{
        for(int i = 0; i < decodeHSnd[1]*decodeHSnd[4]; i++){
            resChannels.push_back(g.decode());
        }
    }
    
    for(int i = 0; i < resChannels.size()-1; i+=2){
        resLeft.push_back(resChannels[i]);           // MID Channel
        resRight.push_back(resChannels[i+1]);        // SIDE channel
    }

    g.close();

    vector<short> resNx, resHatXl, resHatXr; 
    
    if(inputN == 1) {
        resXl.push_back(resLeft[0]);
        resXr.push_back(resRight[0]);
        resNx.push_back(resLeft[0]);
        resNx.push_back(resRight[0]);
        for(int i = 1; i < resLeft.size(); i++) {
            resXl.push_back((short) resLeft[i] + resXl[i-1]);
            resXr.push_back((short) resRight[i] + resXr[i-1]);
            resNx.push_back(resXl[i]);
            resNx.push_back(resXr[i]);
        }
    }
    else if(inputN == 2) {
        for(int i = 0; i < 2; i++) {
            resHatXl.push_back(0);
            resHatXr.push_back(0);
            resXl.push_back(resLeft[i]);
            resXr.push_back(resRight[i]);
            resNx.push_back(resXl[i]);
            resNx.push_back(resXr[i]);
        }
        for(int i = 2; i < resLeft.size(); i++) {
            resHatXl.push_back((int) (2*resXl[i-1] - resXl[i-2]));
            resHatXr.push_back((int) (2*resXr[i-1] - resXr[i-2]));
            resXl.push_back((short) resLeft[i] + resHatXl[i]);
            resXr.push_back((short) resRight[i] + resHatXr[i]);
            resNx.push_back(resXl[i]);
            resNx.push_back(resXr[i]);
        }
    }
    else {
        for(int i = 0; i < 3; i++) {
            resHatXl.push_back(0);
            resHatXr.push_back(0);
            resXl.push_back(resLeft[i]);
            resXr.push_back(resRight[i]);
            resNx.push_back(resXl[i]);
            resNx.push_back(resXr[i]);
        }
        for(int i = 3; i < resLeft.size(); i++) {
            resHatXl.push_back((int) (3*resXl[i-1] - 3*resXl[i-2] + resXl[i-3]));
            resHatXr.push_back((int) (3*resXr[i-1] - 3*resXr[i-2] + resXr[i-3]));
            resXl.push_back((short) resLeft[i] + resHatXl[i]);
            resXr.push_back((short) resRight[i] + resHatXr[i]);
            resNx.push_back(resXl[i]);
            resNx.push_back(resXr[i]);
        }
    }

    SF_INFO sfinfoOut ;
    sfinfoOut.channels = decodeHSnd[4];
    sfinfoOut.samplerate = decodeHSnd[2];
    sfinfoOut.format = decodeHSnd[3];
    sfinfoOut.frames = decodeHSnd[1];

    SNDFILE * oFile = sf_open("4e5/smpGenerated.wav", SFM_WRITE, &sfinfoOut);
    sf_count_t count = sf_write_short(oFile, &resNx[0], resNx.size()) ;
    sf_write_sync(oFile);
    sf_close(oFile);
}

void AudioCodec::preditor(std::vector<short> audioSamples){
    
    vector<short> left, right;
    
    for(int i = 0; i < channels.size()-1; i+=2){
        left.push_back((channels[i]+channels[i+1])/2);       // left -> MID Channel
        right.push_back(channels[i]-channels[i+1]);          // right -> SIDE Channel
    }

    vector<short> xnl, xnr;
    if(inputN == 1) {
        for(int i = 0; i < left.size(); i++) {
            if(i == 0) {
                xnl.push_back(0);
                xnr.push_back(0);
            }
            else {
                xnl.push_back(left[i-1]);
                xnr.push_back(right[i-1]);
            }
            rn.push_back(left[i]-xnl[i]);
            rn.push_back(right[i]-xnr[i]);
        }
    }
    else if(inputN == 2) {
        for(int i = 0; i < left.size(); i++) {
            if(i == 0 || i == 1) {
                xnl.push_back(0);
                xnr.push_back(0);
            }
            else {
                xnl.push_back(2*left[i-1] - left[i-2]);
                xnr.push_back(2*right[i-1] - right[i-2]);
            }
            rn.push_back(left[i]-xnl[i]);
            rn.push_back(right[i]-xnr[i]);
        }
    }
    else {
        for(int i = 0; i < left.size(); i++) {
            if(i == 0 || i == 1 || i == 2) {
                xnl.push_back(0);
                xnr.push_back(0);
            }
            else {
                xnl.push_back(3*left[i-1] - 3*left[i-2] + left[i-3]);
                xnr.push_back(3*right[i-1] - 3*right[i-2] + right[i-3]);
            }
            rn.push_back(left[i]-xnl[i]);
            rn.push_back(right[i]-xnr[i]);
        }
    }
}

void AudioCodec::preditorLossy(vector<short> audioSamples, int nBitsShift) {

    vector<short> left, right;
    for(int i = 0; i < channels.size()-1; i+=2){
        left.push_back((channels[i]+channels[i+1])/2);       // left -> MID Channel
        right.push_back(channels[i]-channels[i+1]);          // right -> SIDE Channel
    }

    vector<int> xnr, xnl;
    
    if(inputN == 1) {
        for(int i = 0; i < left.size(); i++) {
            if(i == 0) {
                xnr.push_back(0);
                xnl.push_back(0);
            }
            else {
                xnl.push_back(left[i-1]);
                xnr.push_back(right[i-1]);
            }
            rn.push_back(((left[i]-xnl[i]) >> nBitsShift) );
            rn.push_back(((right[i]-xnr[i]) >> nBitsShift) );
            left[i] = (rn[2*i] << nBitsShift) + xnl[i];
            right[i] = (rn[2*i+1] << nBitsShift) + xnr[i];
        }
    }
    else if(inputN == 2) {
        for(int i = 0; i < left.size(); i++) {
            if(i == 0 || i == 1) {
                xnl.push_back(0);
                xnr.push_back(0);
            }
            else {
                xnl.push_back(2*left[i-1] - left[i-2]);
                xnr.push_back(2*right[i-1] - right[i-2]);
            }
            rn.push_back(((left[i]-xnl[i]) >> nBitsShift) );
            rn.push_back(((right[i]-xnr[i]) >> nBitsShift) );
            left[i] = (rn[2*i] << nBitsShift) + xnl[i];
            right[i] = (rn[2*i+1] << nBitsShift) + xnr[i];
        }
    }
    else {
        for(int i = 0; i < left.size(); i++) {
            if(i == 0 || i == 1 || i == 2) {
                xnl.push_back(0);
                xnr.push_back(0);
            }
            else {
                xnl.push_back(3*left[i-1] - 3*left[i-2] + left[i-3]);
                xnr.push_back(3*right[i-1] - 3*right[i-2] + right[i-3]);
            }
            rn.push_back(((left[i]-xnl[i]) >> nBitsShift) );
            rn.push_back(((right[i]-xnr[i]) >> nBitsShift) );
            left[i] = (rn[2*i] << nBitsShift ) + xnl[i];
            right[i] = (rn[2*i+1] << nBitsShift )  + xnr[i];
        }
    }
}
