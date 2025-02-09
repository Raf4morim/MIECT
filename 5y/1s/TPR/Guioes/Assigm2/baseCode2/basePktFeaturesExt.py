import argparse
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
import os


def extractStats(data):
    nSamp=data.shape
    print(data)

    # media, mediana e desvio padrao/var
    M1=np.mean(data,axis=0)
    Md1=np.median(data,axis=0)
    Std1=np.std(data,axis=0)
    mxm = np.max(data,axis=0)
    mnm = np.min(data,axis=0)
    p=[75,90,95,98]
    Pr1=np.array(np.percentile(data,p,axis=0))
    
    features=np.hstack((M1,Md1,Std1,Pr1,mxm,mnm))
    # hstack junta horizontalmente linhas
    return(features)

def extractStatsAdv(data,threshold=0):
    nSamp=data.shape
    print(data)

    M1=np.mean(data,axis=0)
    Md1=np.median(data,axis=0)
    Std1=np.std(data,axis=0)
#   p=[75,90,95,98]
#   Pr1=np.array(np.percentile(data,p,axis=0))

    silence,activity=extractSilenceActivity(data,threshold)
    
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

def extractSilenceActivity(data,threshold=0):
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
    fname=''.join(fileInput.split('.')[:-1])+"_features_m{}_w{}_s{}".format(2,lengthObsWindow,slidingValue)
    
    # Dividir os 3 metodos
    # janelas sequenciais/deslizante e
    print("\n\n### SLIDING Observation Windows with Length {} and Sliding {} ###".format(lengthObsWindow[0],slidingValue))
    features=slidingObsWindow(data,lengthObsWindow[0],slidingValue)
    print(features)
    print(fname)
    np.savetxt(fname,features,fmt='%d')


if __name__ == '__main__':
    main()
