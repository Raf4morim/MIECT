import argparse
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
import os


def extractStats(data):
    nSamp=data.shape
    print(data)

    M1=np.mean(data,axis=0)
    Md1=np.median(data,axis=0)
    Std1=np.std(data,axis=0)
#   p=[75,90,95,98]
#   Pr1=np.array(np.percentile(data,p,axis=0))
    
    features=np.hstack((M1,Md1,Std1))
    return(features)

def extractStatsAdv(data,threshold=0):
    nSamp=data.shape
    print(data)

    M1=np.mean(data,axis=0)
    Md1=np.median(data,axis=0)
    Std1=np.std(data,axis=0)
#   p=[75,90,95,98]
#   Pr1=np.array(np.percentile(data,p,axis=0))

    silence,activity=extratctSilenceActivity(data,threshold)
    
    if len(silence)>0:
        silence_faux=np.array([len(silence),np.mean(silence),np.std(silence)])
    else:
        silence_faux=np.zeros(3)
        
    # if len(activity)>0:
        # activity_faux=np.array([len(activity),np.mean(activity),np.std(activity)])
    # else:
        # activity_faux=np.zeros(3)
    # activity_features=np.hstack((activity_features,activity_faux))  
    
    features=np.hstack((M1,Md1,Std1,silence_faux))
    return(features)

def extratctSilenceActivity(data,threshold=0):
    if(data[0]<=threshold):
        s=[1]
        a=[]
    else:
        s=[]
        a=[1]
    for i in range(1,len(data)):
        if(data[i-1]>threshold and data[i]<=threshold):
            s.append(1)
        elif(data[i-1]<=threshold and data[i]>threshold):
            a.append(1)
        elif (data[i-1]<=threshold and data[i]<=threshold):
            s[-1]+=1
        else:
            a[-1]+=1
    return(s,a)


def seqObsWindow(data,lengthObsWindow):
    iobs=0
    nSamples,nMetrics=data.shape
    while iobs*lengthObsWindow<nSamples-lengthObsWindow:
        obsFeatures=np.array([])
        for m in np.arange(nMetrics):
            wmFeatures=extractStats(data[iobs*lengthObsWindow:(iobs+1)*lengthObsWindow,m])
            obsFeatures=np.hstack((obsFeatures,wmFeatures))
        iobs+=1
        
        if 'allFeatures' not in locals():
            allFeatures=obsFeatures.copy()
        else:
            allFeatures=np.vstack((allFeatures,obsFeatures))
    return(allFeatures)

        
def slidingObsWindow(data,lengthObsWindow,slidingValue):
    iobs=0
    nSamples,nMetrics=data.shape
    while iobs*slidingValue<nSamples-lengthObsWindow:
        obsFeatures=np.array([])
        for m in np.arange(nMetrics):
            wmFeatures=extractStats(data[iobs*slidingValue:iobs*slidingValue+lengthObsWindow,m])
            obsFeatures=np.hstack((obsFeatures,wmFeatures))
        iobs+=1
        
        if 'allFeatures' not in locals():
            allFeatures=obsFeatures.copy()
        else:
            allFeatures=np.vstack((allFeatures,obsFeatures))
    return(allFeatures)
        
def slidingMultObsWindow(data,allLengthsObsWindow,slidingValue):
    iobs=0
    nSamples,nMetrics=data.shape
    while iobs*slidingValue<nSamples-max(allLengthsObsWindow):
        obsFeatures=np.array([])
        for lengthObsWindow in allLengthsObsWindow:
            for m in np.arange(nMetrics):
                wmFeatures=extractStats(data[iobs*slidingValue:iobs*slidingValue+lengthObsWindow,m])
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
    parser.add_argument('-m', '--method', nargs='?',required=False, help='obs. window creation method',default=2)
    parser.add_argument('-w', '--widths', nargs='*',required=False, help='list of observation windows widths',default=60)
    parser.add_argument('-s', '--slide', nargs='?',required=False, help='observation windows slide value',default=0)
    args=parser.parse_args()
    
    fileInput=args.input
    method=int(args.method)
    lengthObsWindow=[int(w) for w in args.widths]
    slidingValue=int(args.slide)
        
    data=np.loadtxt(fileInput,dtype=int)
    if method==1:
        fname=''.join(fileInput.split('.')[:-1])+"_features_m{}_w{}".format(method,lengthObsWindow)
    else:
        fname=''.join(fileInput.split('.')[:-1])+"_features_m{}_w{}_s{}".format(method,lengthObsWindow,slidingValue)
    
    if method==1:
        print("\n\n### SEQUENTIAL Observation Windows with Length {} ###".format(lengthObsWindow[0]))
        features=seqObsWindow(data,lengthObsWindow[0])
        print(features)
        print(fname)
        np.savetxt(fname,features,fmt='%d')
    elif method==2:
        print("\n\n### SLIDING Observation Windows with Length {} and Sliding {} ###".format(lengthObsWindow[0],slidingValue))
        features=slidingObsWindow(data,lengthObsWindow[0],slidingValue)
        print(features)
        print(fname)
        np.savetxt(fname,features,fmt='%d')
    elif method==3:
        print("\n\n### SLIDING Observation Windows with Lengths {} and Sliding {} ###".format(lengthObsWindow,slidingValue))    
        features=slidingMultObsWindow(data,lengthObsWindow,slidingValue)
        print(features)
        print(fname)
        np.savetxt(fname,features,fmt='%d')
            
        

if __name__ == '__main__':
    main()
