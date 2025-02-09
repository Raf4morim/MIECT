import argparse
import scipy.stats as stats
import scipy.signal as signal
import numpy as np
import matplotlib.pyplot as plt
import scalogram
from baseObsWindows import slidingMultObsWindow
import os

def extractPeriodicityFeatures(data):
    scales=np.arange(2,50)                  
    S,scales=scalogram.scalogramCWT(data,scales)   #periodogram using CWT (Morlet wavelet)
    
    return S

def seqObsWindow(data,lengthObsWindow,imetric=1):
    iobs=0
    nSamples,nMetrics=data.shape
    while iobs*lengthObsWindow<nSamples-lengthObsWindow:
        obsFeatures=np.array([])
        wmFeatures=extractPeriodicityFeatures(data[iobs*lengthObsWindow:(iobs+1)*lengthObsWindow,imetric])
        obsFeatures=np.hstack((obsFeatures,wmFeatures))
        iobs+=1
        
        if 'allFeatures' not in locals():
            allFeatures=obsFeatures.copy()
        else:
            allFeatures=np.vstack((allFeatures,obsFeatures))
    return(allFeatures)

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('-i', '--input', nargs='?',required=True, help='input file')
    parser.add_argument('-w', '--width', nargs='*',required=False, help='observation windows width',default=120)
    args=parser.parse_args()
    
    fileInput=args.input
    lengthObsWindow=int(args.width)
        
    data=np.loadtxt(fileInput,dtype=int)
    fname=''.join(fileInput.split('.')[:-1])+"_period_features_w{}".format(lengthObsWindow)
    

    print("\n\n### SEQUENTIAL Observation Windows with Length {} ###".format(lengthObsWindow))
    features=seqObsWindow(data,lengthObsWindow)
    print(features)
    print(fname)
    np.savetxt(fname,features,fmt='%f')

            
        

if __name__ == '__main__':
    main()

