import argparse
import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt
import os

def extractStatsAdv(data,threshold=0):
    nSamp=data.shape
    M1=np.mean(data,axis=0)
    Md1=np.median(data,axis=0)
    Std1=np.std(data,axis=0)
    silence,activity=extratctSilenceActivity(data,threshold)

    if len(silence) > 0:
        print("len(silence), np.std(silence), np.mean(silence): ", len(silence), np.std(silence), np.mean(silence))
        silence_faux = np.array([len(silence), np.std(silence), np.mean(silence)])
    else:
        silence_faux = np.zeros(3)
    if len(activity) > 0:
        activity_faux = np.array([len(activity), np.std(activity), np.mean(activity)])
    else:
        activity_faux = np.zeros(3)
    print("AAAAAAAAAAACTIVITYYY: ", activity_faux)
    print("SILEEEEEEEEEEEEEENCE: ", silence_faux)
    features = np.hstack((M1, Md1, Std1, silence_faux, activity_faux))
    return(features)


1, Md1, Std1, len(silence), np.std(silence), np.mean(silence), len(activity), np.std(activity), np.mean(activity), , Md1, Std1, len(silence), np.std(silence), np.mean(silence), len(activity), np.std(activity), np.mean(activity)


def extratctSilenceActivity(data,threshold=0):
    print("data[0]: ", data[0])
    if(data[0]<=threshold):
        s=[1]
        a=[]
    else:
        s=[]
        a=[1]
    for i in range(1,len(data)):
        print("data[i-1]: ", data[i-1])
        print("data[i]: ", data[i])

        if(data[i-1]>threshold and data[i]<=threshold):
            print("APPEEEEND SILENCIO",s)
            s.append(1)
        elif(data[i-1]<=threshold and data[i]>threshold):
            print("APPEEEEND ATIIVIDDADE",a)
            a.append(1)
        elif (data[i-1]<=threshold and data[i]<=threshold):
            print("INCREMEEEENTA SILENCIO",s[-1])
            s[-1]+=1
        else:
            print("INCREMEEEENTA ATIIVIDDADE",a[-1])
            a[-1]+=1
    # print('sssssssssssssssssssssss ', s)        
    # print('aaaaaaaaaaaaaaaaaaaaaaa ', a)
    return(s,a)


def slidingObsWindow(data,lengthObsWindow,slidingValue):
    iobs=0
    nSamples,nMetrics=data.shape

    while iobs*slidingValue<nSamples-lengthObsWindow:
        obsFeatures=np.array([])
        for m in np.arange(nMetrics):
            # print("DAAAAAAAAAAAATA", data)
            print('==================================================================\n'+str(data[iobs*slidingValue:iobs*slidingValue+lengthObsWindow,m]))
            wmFeatures=extractStatsAdv(data[iobs*slidingValue:iobs*slidingValue+lengthObsWindow,m])
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
    # parser.add_argument('-m', '--method', nargs='?',required=False, help='obs. window creation method',default=2)
    parser.add_argument('-w', '--widths', nargs='*',required=False, help='list of observation windows widths',default=60)
    parser.add_argument('-s', '--slide', nargs='?',required=False, help='observation windows slide value',default=0)
    args=parser.parse_args()
    
    fileInput=args.input
    lengthObsWindow=[int(w) for w in args.widths]
    slidingValue=int(args.slide)
        
    data=np.loadtxt(fileInput,dtype=int)
    fname=''.join(fileInput.split('.')[:-1])+"_features_m{}_w{}_s{}".format(2,lengthObsWindow,slidingValue)

    print("\n\n### SLIDING Observation Windows with Length {} and Sliding {} ###".format(lengthObsWindow[0],slidingValue))
    features=slidingObsWindow(data,lengthObsWindow[0],slidingValue)
    print(features)
    print(fname)
    np.savetxt(fname,features,fmt='%d')        
        

if __name__ == '__main__':
    main()
