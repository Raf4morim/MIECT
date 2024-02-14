import sys
import argparse
from netaddr import IPNetwork, IPAddress, IPSet
import pyshark
import numpy as np
import os
from os.path import exists
from pyclbr import Class
import numpy as np
import scipy.stats as stats
import scipy.signal as signal
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import MaxAbsScaler
from sklearn.decomposition import PCA
from sklearn.cluster import KMeans
from sklearn.cluster import DBSCAN
from sklearn.model_selection import train_test_split
from sklearn.decomposition import PCA
from sklearn.model_selection import GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.svm import SVC
from sklearn.svm import OneClassSVM
from scipy.stats import multivariate_normal
from sklearn.metrics import accuracy_score, precision_score, confusion_matrix
from sklearn.neural_network import MLPClassifier
from sklearn import svm
import seaborn as sns
import time
import sys
import warnings
import pandas as pd
from algoritmos import *
warnings.filterwarnings('ignore')

scenario = 0


# up_count      up_payload      down_count      down_payload

sampDelta = 5   # seconds
widths = 20      # sliding window width
slide = 4       # sliding window slide

#############################################################
NETClient = ['192.168.0.164']
# file = 'Captures/4brsg1h30.pcap'
file = 'Captures/5brsg1h30_lowFreq.pcap'

# file = 'Captures/4seq1h30.pcap'
# file = 'Captures/4smart1h30.pcap'
#############################################################
NETServer = ['157.240.212.0/24']  # Apenas para o do Wpp por agora
# NETServer = ['0.0.0.0/0']

samplesMatrices = []
ipList = ['157.240.212.0/24']

def pktHandler(timestamp, srcIP, dstIP, lengthIP, sampDelta, outfile):
    global scnets
    global ssnets
    global npkts
    global T0
    global outc
    global last_ks
    global ipList

    if (IPAddress(srcIP) in scnets and IPAddress(dstIP) in ssnets) or (IPAddress(srcIP) in ssnets and IPAddress(dstIP) in scnets):

        if npkts == 0:
            T0 = float(timestamp)
            last_ks = 0

        ks = int((float(timestamp)-T0) / sampDelta)

        if ks > last_ks:
            print()
            for i in outc:
                outfile.write(str(i[0]) + ' ' + str(i[1]) + ' ' + str(i[2]) + ' ' + str(i[3]) + ' ' + str(i[4]) + '\n')
                if ipList == []:
                    ipList.append('157.240.212.0/24')
                print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format(str(ipList[i[0]]), int(i[1]), int(i[2]), int(i[3]), int(i[4])))
            outfile.write('\n')
            # print(outc)
            outc = []
            outc.append([0,0,0,0,0])

        if IPAddress(srcIP) in scnets and int(lengthIP) > 150: # Upload
            # try:
            #     ipIndex = ipList.index(dstIP)
            # except:
            #     ipList.append(dstIP)
            #     ipIndex = ipList.index(dstIP)
            # inOutc = False
            # outCount = 0
            # for iterOutc in outc:
            #     if iterOutc[0] == ipIndex:
            #         inOutc = True
            #         outIdx = outCount
            #     else:
            #         outCount += 1
            # if not inOutc:
            #     outc.append([ipIndex,0,0,0,0])
            #     outIdx = len(outc)-1
            # outc[outIdx][1] = outc[outIdx][1] + 1
            # outc[outIdx][2] = outc[outIdx][2] + int(lengthIP)
                
            try:
                outc[0][1] = outc[0][1] + 1
                outc[0][2] = outc[0][2] + int(lengthIP)
            except:
                outc.append([0,0,0,0,0])
                outc[0][1] = outc[0][1] + 1
                outc[0][2] = outc[0][2] + int(lengthIP)

        if IPAddress(dstIP) in scnets and int(lengthIP) > 150: # Download
            # try:
            #     ipIndex = ipList.index(srcIP)
            # except:
            #     ipList.append(srcIP)
            #     ipIndex = ipList.index(srcIP)
            # inOutc = False
            # outCount = 0
            # for iterOutc in outc:
            #     if iterOutc[0] == ipIndex:
            #         inOutc = True
            #         outIdx = outCount
            #     else:
            #         outCount += 1
            # if not inOutc:
            #     outc.append([ipIndex,0,0,0,0])
            #     outIdx = len(outc)-1
            # outc[outIdx][3] = outc[outIdx][3] + 1
            # outc[outIdx][4] = outc[outIdx][4] + int(lengthIP)

            try:
                outc[0][3] = outc[0][3] + 1
                outc[0][4] = outc[0][4] + int(lengthIP)
            except:
                outc.append([0,0,0,0,0])
                outc[0][3] = outc[0][3] + 1
                outc[0][4] = outc[0][4] + int(lengthIP)


        # print('= ' + str(srcIP) + ' / ' + str(dstIP) + ' / ' + str(lengthIP))
        # print(outc)
        # print(ipList)
        # print()
        last_ks = ks
        npkts = npkts + 1


def dataIntoMatrices(dataFile):
    global ipList, samplesMatrices
    matrixDataFileName = dataFile + '_matrix'
    matrixDataFile = open(matrixDataFileName, 'w')
    with open(dataFile, 'r') as file:
        tmpMatrix = np.zeros((len(ipList), 4), dtype=int)
        for line in file:
            if line != '\n':
                lineArray = line.split(' ')
                tmpMatrix[int(lineArray[0])] = [int(lineArray[1]), int(lineArray[2]), int(lineArray[3]), int(lineArray[4])]
            else:
                for tmpIter in tmpMatrix:
                    matrixDataFile.write(str(tmpIter[0]) + ' ' + str(tmpIter[1]) + ' ' + str(tmpIter[2]) + ' ' + str(tmpIter[3]) + '\n')
                matrixDataFile.write('\n')
                samplesMatrices.append(tmpMatrix)
                tmpMatrix = np.zeros((len(ipList), 4), dtype=int)
    return matrixDataFileName


    ######################################################################################
    #                                      FEATURES                                      #
    ######################################################################################

def sumMatrices(matrices):
    sum = np.copy(matrices[0])
    for i in range(1, len(matrices)):
        sum = np.add(sum, np.copy(matrices[i]))
    return sum


def trafficMatrices(matrices):
    rows, columns = matrices[0].shape
    trafficList = []
    tmpMatrix = []
    for j in range(0,rows):
        for i in range(0,len(matrices)):
            tmpMatrix.append(np.copy(matrices[i][j]))
        npMatrix = np.array(tmpMatrix,dtype=int)
        trafficList.append(np.copy(npMatrix))
        tmpMatrix = []
    return trafficList


def maxMin(data):
    maxMatrix = np.copy(data[0])
    # print("\nMIIIIIIIIIIIIIIIIIN------",data[:])
    minMatrix = np.copy(data[0])
    for matrix in data[:]:
        for line in range(0,len(matrix)):
            for column in range(0,len(matrix[0])):
                if matrix[line][column] > maxMatrix[line][column]:
                    maxMatrix[line][column] = np.copy(matrix[line][column])
                if matrix[line][column] < minMatrix[line][column]:
                    minMatrix[line][column] = np.copy(matrix[line][column])
    # print("\nMIIIIIIIIIIIIIIIIIN------",maxMatrix)
    return (maxMatrix, minMatrix)


def sumColumns(matrix):
    sum = np.copy(matrix[0])
    for i in range(1,len(matrix)):
        for j in range(0,len(sum)):
            sum[j] += matrix[i][j]
    return sum


def getPercentages(matrix, sum):
    tmpMatrix = np.zeros((len(matrix),len(matrix[0])), dtype=float)
    for i in range (0,len(matrix)):
        for j in range(0,len(matrix[0])):
            try:
                tmpMatrix[i][j] = float(float(matrix[i][j]) / float(sum[j]))
            except:
                pass
    return tmpMatrix

def extractSilenceActivity(data, i, threshold=0):
    save_silence_npkt_payload_ul_dl = []
    for j in range(4):
        if(i[0][j]<=threshold):
            s=[1]
            a=[]
        else:
            s=[]
            a=[1]
        for k in range(1,len(i)):
            if(i[k-1][j]>threshold and i[k][j]<=threshold):
                s.append(1)
            elif(i[k-1][j]<=threshold and i[k][j]>threshold):
                a.append(1)
            elif (i[k-1][j]<=threshold and i[k][j]<=threshold):
                s[-1]+=1
            else:
                a[-1]+=1
        save_silence_npkt_payload_ul_dl.append([s,a])
    # print('save_silence_npkt_payload_ul_dl -> ', save_silence_npkt_payload_ul_dl)
    # up_count_S up_count_A     up_payload_S up_payload_A    down_count_S down_count_A   down_payload_S down_payload_A
    return save_silence_npkt_payload_ul_dl

def extractStatsAdv(data, i, threshold=0):
    nSamp=data.shape
    M1=np.mean(data,axis=0)
    Md1=np.median(data,axis=0)
    Std1=np.std(data,axis=0)

    extractSil = []
    extractAct = []
    silence_faux = []
    activity_faux = []

    for coluna in range(len(i[0])):
        extractSil,extractAct =extractSilenceActivity(data, i, threshold)[coluna]
        if len(extractSil) > 0:
            silence_faux.append([np.sum(extractSil), np.mean(extractSil), np.std(extractSil), np.median(extractSil), np.max(extractSil), np.min(extractSil)])
        else:
            silence_faux.append([0,0,0,0,0,0])
        if len(extractAct) > 0:
            activity_faux.append([np.sum(extractAct), np.mean(extractAct), np.std(extractAct), np.median(extractAct), np.max(extractAct), np.min(extractAct)])
        else:
            activity_faux.append([0,0,0,0,0,0])
        # i ->  [[  2 482   0   0] [  1 241   0   0]]
        # npku(sum-media-desvio-mediana-max-min)    nbytesu(sum-media-desvio-mediana-max-min)  npkd(sum-media-desvio-mediana-max-min)  nbytesd(sum-media-desvio-mediana-max-min)
        # silence_faux ->  [[0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0], [2, 2.0, 0.0, 2.0, 2, 2], [2, 2.0, 0.0, 2.0, 2, 2]]
        # activity_faux ->  [[2, 2.0, w0.0, 2.0, 2, 2], [2, 2.0, 0.0, 2.0, 2, 2], [0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0]]
    return [M1, Md1, Std1, silence_faux, activity_faux]

def extractStats(data):
    M1 = np.mean(data, axis=0)
    Md1 = np.median(data, axis=0)
    Std1 = np.std(data, axis=0)
    return [M1, Md1, Std1]

# Função para imprimir e escrever dados sem silêncios
def print_and_write_no_silence(data_matrix, out_file, ip_list, format_string, title):
    print(f'\n---- {title} Sem Silêncio ----')
    print(format_string.format('IP', 'npktUp', 'payUp', 'npktDown', 'payDown'))
    for i in range(len(data_matrix)):
        print(format_string.format(str(ip_list[i]), *data_matrix[i][:4]))
        out_file.write(' '.join(map(str, data_matrix[i][:4])) + '\n')

# Função para imprimir e escrever dados de silêncios
def print_and_write_silence(data_matrix, out_file, ip_list, format_string, title):
    print(f'\n---- {title} de Silêncio ----')
    print(format_string.format('IP', 's_npktUp', 's_payUp', 's_npktDown', 's_payDown'))
    for i in range(len(data_matrix)):
        print(format_string.format(str(ip_list[i]), *data_matrix[i][4:]))
        out_file.write(' '.join(map(str, data_matrix[i][4:])) + '\n')

def extractFeatures(dataFile):
    global ipList, samplesMatrices
    lengthObsWindow = widths
    slidingValue = slide
    # data = np.loadtxt(dataFile, dtype=int)
    data = np.copy(samplesMatrices)
    _fname = str(dataFile.split('.')[0])

    fname = ''.join(_fname.split('_')[0])+"_features_w{}_s{}".format(lengthObsWindow,slidingValue)

    directory, filename = os.path.split(fname)
    directory = directory.replace('Captures', 'Features')   # Store in Features to use in Profiles
    fname = directory + '/' + filename.split('_')[0] + "_features_w{}_s{}".format(lengthObsWindow,slidingValue)

    sumOutFile = open(fname+'_sum', 'w')
    totalOutFile = open(fname+'_total', 'w')
    percOutFile = open(fname+'_percentages', 'w')
    maxOutFile = open(fname+'_max', 'w')
    minOutFile = open(fname+'_min', 'w')
    avgOutFile = open(fname+'_avg', 'w')
    medianOutFile = open(fname+'_median', 'w')
    stdOutFile = open(fname+'_std', 'w')

    silSumOutFile = open(fname+'_sum_s', 'w')
    silTotalOutFile = open(fname+'_total_s', 'w')
    silPercOutFile = open(fname+'_percentages_s', 'w')
    silMaxOutFile = open(fname+'_max_s', 'w')
    silMinOutFile = open(fname+'_min_s', 'w')
    silAvgOutFile = open(fname+'_avg_s', 'w')
    silMedianOutFile = open(fname+'_median_s', 'w')
    silStdOutFile = open(fname+'_std_s', 'w')

    print("\n\n### SLIDING Observation Windows with Length {} and Sliding {} ###".format(lengthObsWindow,slidingValue))

    iobs = 0
    print(data)
    nSamples = len(data)
    print(nSamples)
    nMetrics = len(data[0])
    avgMatrix = np.array([])
    medianMatrix = np.array([])
    stdMatrix = np.array([])

    while iobs*slidingValue <= nSamples-lengthObsWindow:
        currentData = np.copy(data[iobs*slidingValue:iobs*slidingValue+lengthObsWindow])
        # print('==================================================================\n'+str(currentData))
        sumMatrix = sumMatrices(currentData)
        sumCol = sumColumns(sumMatrix)
        maxMatrix, minMatrix = maxMin(currentData)
        currentFlows = trafficMatrices(currentData)
        percentageMatrix = getPercentages(sumMatrix, sumCol)
        silSumMatrix = []
        silAvgMatrix = []
        silStdMatrix = []
        silMedMatrix = []
        silMaxMatrix = []
        silMinMatrix = []
        n = 0
        for i in currentFlows:
            print('==================================================================',n)
            print("i -> ", str(i))
            stats = extractStatsAdv(np.copy(currentData),i)
            avgMatrix = stats[0]
            medianMatrix = stats[1]
            stdMatrix = stats[2]


            tempSum = []
            tempAvg = []
            tempStd = []
            tempMed = []
            tempMax = []
            tempMin = []

            for metricas in range(0,4):
                tempSum.append(stats[3][metricas][0])
                tempAvg.append(stats[3][metricas][1])
                tempStd.append(stats[3][metricas][2])
                tempMed.append(stats[3][metricas][3])
                tempMax.append(stats[3][metricas][4])
                tempMin.append(stats[3][metricas][5])

            silSumMatrix.append(tempSum)
            silAvgMatrix.append(tempAvg)
            silStdMatrix.append(tempStd)
            silMedMatrix.append(tempMed)
            silMaxMatrix.append(tempMax)
            silMinMatrix.append(tempMin)

            silSumCol = sumColumns(silSumMatrix)
            silPercentageMatrix = getPercentages(silSumMatrix, silSumCol)

            n += 1

        print('\n-------------------------')
        print('   ' + str(iobs+1))
        print('--------- Total ---------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  npktUp','     payUp','  npktDown','  payDown'))
        for i in range(0,len(sumMatrix)):
            print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format(str(ipList[i]), int(sumMatrix[i][0]), int(sumMatrix[i][1]), int(sumMatrix[i][2]), int(sumMatrix[i][3])))
            sumOutFile.write(str(sumMatrix[i][0]) + ' ' + str(sumMatrix[i][1]) + ' ' + str(sumMatrix[i][2]) + ' ' + str(sumMatrix[i][3]) + '\n')
        sumOutFile.write('\n')

        print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format('TOTAL: ', int(sumCol[0]), int(sumCol[1]), int(sumCol[2]), int(sumCol[3])))
        totalOutFile.write(str(sumCol[0]) + ' ' + str(sumCol[1]) + ' ' + str(sumCol[2]) + ' ' + str(sumCol[3]) + '\n\n')

        print('--------- Total ---------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  s_npktUp',' s_payUp',' s_npktDown',' s_payDown'))
        for i in range(0,len(silSumMatrix)):
            print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format(str(ipList[i]), int(silSumMatrix[i][0]), int(silSumMatrix[i][1]), int(silSumMatrix[i][2]), int(silSumMatrix[i][3])))
            silSumOutFile.write(str(silSumMatrix[i][0]) + ' ' + str(silSumMatrix[i][1]) + ' ' + str(silSumMatrix[i][2]) + ' ' + str(silSumMatrix[i][3]) + '\n')
        silSumOutFile.write('\n')

        print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format('TOTAL: ', int(silSumCol[0]), int(silSumCol[1]), int(silSumCol[2]), int(silSumCol[3])))
        silTotalOutFile.write(str(silSumCol[0]) + ' ' + str(silSumCol[1]) + ' ' + str(silSumCol[2]) + ' ' + str(silSumCol[3]) + '\n\n')

        print('\n-------- Perc % ---------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  npktUp','     payUp','  npktDown','  payDown'))
        for i in range(0,len(percentageMatrix)):
            print('{:21s} {:10.2f} {:10.2f} {:10.2f} {:10.2f}'.format(str(ipList[i]), float(percentageMatrix[i][0]), float(percentageMatrix[i][1]), float(percentageMatrix[i][2]), float(percentageMatrix[i][3])))
            percOutFile.write(str(percentageMatrix[i][0]) + ' ' + str(percentageMatrix[i][1]) + ' ' + str(percentageMatrix[i][2]) + ' ' + str(percentageMatrix[i][3]) + '\n')
        percOutFile.write('\n')

        print('\n-------- Sil Perc % ---------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  s_npktUp',' s_payUp',' s_npktDown',' s_payDown'))
        for i in range(0,len(silPercentageMatrix)):
            print('{:21s} {:10.2f} {:10.2f} {:10.2f} {:10.2f}'.format(str(ipList[i]), float(silPercentageMatrix[i][0]), float(silPercentageMatrix[i][1]), float(silPercentageMatrix[i][2]), float(silPercentageMatrix[i][3])))
            silPercOutFile.write(str(silPercentageMatrix[i][0]) + ' ' + str(silPercentageMatrix[i][1]) + ' ' + str(silPercentageMatrix[i][2]) + ' ' + str(silPercentageMatrix[i][3]) + '\n')
        silPercOutFile.write('\n')

        print('\n---------- Max ----------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  npktUp','     payUp','  npktDown','  payDown'))
        for i in range(0,len(maxMatrix)):
            print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format(str(ipList[i]), int(maxMatrix[i][0]), int(maxMatrix[i][1]), int(maxMatrix[i][2]), int(maxMatrix[i][3])))
            maxOutFile.write(str(maxMatrix[i][0]) + ' ' + str(maxMatrix[i][1]) + ' ' + str(maxMatrix[i][2]) + ' ' + str(maxMatrix[i][3]) +'\n')
        maxOutFile.write('\n')

        print('\n---------- Sil Max ----------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  s_npktUp',' s_payUp',' s_npktDown',' s_payDown'))
        for i in range(0,len(silMaxMatrix)):
            print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format(str(ipList[i]), int(silMaxMatrix[i][0]), int(silMaxMatrix[i][1]), int(silMaxMatrix[i][2]), int(silMaxMatrix[i][3])))
            silMaxOutFile.write(str(silMaxMatrix[i][0]) + ' ' + str(silMaxMatrix[i][1]) + ' ' + str(silMaxMatrix[i][2]) + ' ' + str(silMaxMatrix[i][3]) +'\n')
        silMaxOutFile.write('\n')

        print('\n---------- Min ----------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  npktUp','     payUp','  npktDown','  payDown'))
        for i in range(0,len(minMatrix)):
            print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format(str(ipList[i]), int(minMatrix[i][0]), int(minMatrix[i][1]), int(minMatrix[i][2]), int(minMatrix[i][3])))
            minOutFile.write(str(minMatrix[i][0]) + ' ' + str(minMatrix[i][1]) + ' ' + str(minMatrix[i][2]) + ' ' + str(minMatrix[i][3]) + '\n')
        minOutFile.write('\n')


        print('\n---------- Sil Min ----------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  s_npktUp',' s_payUp',' s_npktDown',' s_payDown'))
        for i in range(0,len(silMinMatrix)):
            print('{:21s} {:10d} {:10d} {:10d} {:10d}'.format(str(ipList[i]), int(silMinMatrix[i][0]), int(silMinMatrix[i][1]), int(minMatrix[i][2]), int(silMinMatrix[i][3])))
            silMinOutFile.write(str(silMinMatrix[i][0]) + ' ' + str(silMinMatrix[i][1]) + ' ' + str(silMinMatrix[i][2]) + ' ' + str(silMinMatrix[i][3]) + '\n')
        silMinOutFile.write('\n')

        print('\n---------- Avg ----------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  npktUp','     payUp','  npktDown','  payDown'))
        for i in range(0,len(avgMatrix)):
            print('{:21s} {:10.2f} {:10.2f} {:10.2f} {:10.2f}'.format(str(ipList[i]), float(avgMatrix[i][0]), float(avgMatrix[i][1]), float(avgMatrix[i][2]), float(avgMatrix[i][3])))
            avgOutFile.write(str(avgMatrix[i][0]) + ' ' + str(avgMatrix[i][1]) + ' ' + str(avgMatrix[i][2]) + ' ' + str(avgMatrix[i][3]) + '\n')
        avgOutFile.write('\n')

        print('\n---------- Sil Avg ----------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  s_npktUp',' s_payUp',' s_npktDown',' s_payDown'))
        for i in range(0,len(silAvgMatrix)):
            print('{:21s} {:10.2f} {:10.2f} {:10.2f} {:10.2f}'.format(str(ipList[i]), float(silAvgMatrix[i][0]), float(silAvgMatrix[i][1]), float(silAvgMatrix[i][2]), float(silAvgMatrix[i][3])))
            silAvgOutFile.write(str(silAvgMatrix[i][0]) + ' ' + str(silAvgMatrix[i][1]) + ' ' + str(silAvgMatrix[i][2]) + ' ' + str(silAvgMatrix[i][3]) + '\n')
        silAvgOutFile.write('\n')

        print('\n-------- Median ---------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  npktUp','     payUp','  npktDown','  payDown'))
        for i in range(0,len(medianMatrix)):
            print('{:21s} {:10.2f} {:10.2f} {:10.2f} {:10.2f}'.format(str(ipList[i]), float(medianMatrix[i][0]), float(medianMatrix[i][1]), float(medianMatrix[i][2]), float(medianMatrix[i][3])))
            medianOutFile.write(str(medianMatrix[i][0]) + ' ' + str(medianMatrix[i][1]) + ' ' + str(medianMatrix[i][2]) + ' ' + str(medianMatrix[i][3]) + '\n')
        medianOutFile.write('\n')

        print('\n--------Sil Median ---------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  s_npktUp',' s_payUp',' s_npktDown',' s_payDown'))
        for i in range(0,len(silMedMatrix)):
            print('{:21s} {:10.2f} {:10.2f} {:10.2f} {:10.2f}'.format(str(ipList[i]), float(silMedMatrix[i][0]), float(silMedMatrix[i][1]), float(silMedMatrix[i][2]), float(silMedMatrix[i][3])))
            silMedianOutFile.write(str(silMedMatrix[i][0]) + ' ' + str(silMedMatrix[i][1]) + ' ' + str(silMedMatrix[i][2]) + ' ' + str(silMedMatrix[i][3]) + '\n')
        silMedianOutFile.write('\n')

        print('\n---------- Std ----------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  s_npktUp',' s_payUp',' s_npktDown',' s_payDown'))
        for i in range(0,len(stdMatrix)):
            print('{:21s} {:10.2f} {:10.2f} {:10.2f} {:10.2f}'.format(str(ipList[i]), float(stdMatrix[i][0]), float(stdMatrix[i][1]), float(stdMatrix[i][2]), float(stdMatrix[i][3])))
            stdOutFile.write(str(stdMatrix[i][0]) + ' ' + str(stdMatrix[i][1]) + ' ' + str(stdMatrix[i][2]) + ' ' + str(stdMatrix[i][3]) + '\n')
        stdOutFile.write('\n')
        
        print('\n----------Sil Std ----------')
        print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  s_npktUp',' s_payUp',' s_npktDown',' s_payDown'))
        for i in range(0,len(silStdMatrix)):
            print('{:21s} {:10.2f} {:10.2f} {:10.2f} {:10.2f}'.format(str(ipList[i]), float(silStdMatrix[i][0]), float(silStdMatrix[i][1]), float(silStdMatrix[i][2]), float(silStdMatrix[i][3])))
            silStdOutFile.write(str(silStdMatrix[i][0]) + ' ' + str(silStdMatrix[i][1]) + ' ' + str(silStdMatrix[i][2]) + ' ' + str(silStdMatrix[i][3]) + '\n')
        silStdOutFile.write('\n')
        print('-------------------------\n\n')
        iobs += 1

    file_vars = [sumOutFile, totalOutFile, percOutFile, maxOutFile, minOutFile, avgOutFile, medianOutFile, stdOutFile, 
                    silSumOutFile, silTotalOutFile, silPercOutFile, silMaxOutFile, silMinOutFile, silAvgOutFile, silMedianOutFile, silStdOutFile]
    for file_var in file_vars:
        file_var.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', nargs='?', required=False, help='input pcap file', default=file)
    parser.add_argument('-c', '--cnet', nargs='+', required=False, help='client network(s)', default=NETClient)
    parser.add_argument('-s', '--snet', nargs='+', required=False, help='service network(s)', default=NETServer)
    args = parser.parse_args()

    cnets = []
    for n in args.cnet:
        try:
            nn = IPNetwork(n)
            cnets.append(nn)
        except:
            print('{} is not a network prefix'.format(n))
    if len(cnets) == 0:
        print('Not valid client network prefixes.')
        sys.exit()
    global scnets
    scnets = IPSet(cnets)

    snets = []
    for n in args.snet:
        try:
            nn = IPNetwork(n)
            snets.append(nn)
        except:
            print('{} is not a network prefix'.format(n))
    if len(snets) == 0:
        print("No valid service network prefixes.")
        sys.exit()
    global ssnets
    ssnets = IPSet(snets)

    fileInput = args.input
    global fileOutput
    fileOutput = ''.join(fileInput.split('.')[:-1])+'_samples'

    global npkts
    global T0
    global outc
    global last_ks
    global ipList
    global samplesMatrices


    npkts = 0
    outc = []
    count = 0
    ipList = []

    outfile = open(fileOutput,'w')

    print('{:6s} {:10s} {:10s} {:10s} {:10s}'.format('IP','\t\t\t  npktUp','     payUp','  npktDown','   payDown'))

    capture = pyshark.FileCapture(fileInput, display_filter='ip')
    q = 0
    for pkt in capture:
        timestamp, srcIP, dstIP, lengthIP = pkt.sniff_timestamp, pkt.ip.src, pkt.ip.dst, pkt.ip.len
        pktHandler(timestamp, srcIP, dstIP, lengthIP, sampDelta, outfile)
        print(q, end='\r')
        q += 1

        # Enquanto n falarmos com o prof geramos assim as features
        # if q >= 84920:
        # if q >= 199786:
        #     break
        # if q >= 6562:
            # break
        
        # seqFile 5850 - 6756
        # brwsg2Wind 6563

    outfile.close()

    ipOutFile = open(''.join(fileInput.split('.')[:-1])+'_ipList', 'w')
    for ip in ipList:
        # print(str(ipList.index(ip)) + ': ' + str(ip))
        ipOutFile.write(str(ipList.index(ip)) + ' ' + str(ip) + '\n')
    ipOutFile.close()

    print()

    matrixSamplesFile = dataIntoMatrices(fileOutput)
    extractFeatures(matrixSamplesFile)

if __name__ == '__main__':
    main()