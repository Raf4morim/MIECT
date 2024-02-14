# objetivo de calcular o tráfego de upload e download entre 
# uma rede de clientes (client network) 
# e uma rede de serviço (service network).

import sys
import argparse
import datetime
from netaddr import IPNetwork, IPAddress, IPSet # biblioteca que lida com endereços IP e redes IP
import pyshark                                  # biblioteca para análise de tráfego de rede

def pktHandler(timestamp,srcIP,dstIP,lengthIP,sampDelta,outfile):
    global scnets
    global ssnets
    global npkts    # n de pacotes
    global T0
    global outc     # dados de saida
    global last_ks  # ultimo intervalo de amostragem
    
    # verificar se o par de endereços IP está contido 
    # nas redes de clientes (scnets) e de serviço (ssnets).
    if (IPAddress(srcIP) in scnets and IPAddress(dstIP) in ssnets) or (IPAddress(srcIP) in ssnets and IPAddress(dstIP) in scnets):
        if npkts==0:
            T0=float(timestamp)
            last_ks=0
            
        # calculo do "intervalo de amostragem" (ks) com base no tempo decorrido 
        # desde o início (T0) e o intervalo de amostragem configurado.
        ks=int((float(timestamp)-T0)/sampDelta)
        
        if ks>last_ks:
            outfile.write('{} {} {} {}\n'.format(*outc))    # escrevemos se for maior que o anterior
            print('{} {} {} {}'.format(*outc))
            outc=[0,0,0,0]                                  # reset
            
        if ks>last_ks+1:
            for j in range(last_ks+1,ks):
                outfile.write('{} {} {} {}\n'.format(*outc))
                print('{} {} {} {}'.format(*outc))
                  
        if IPAddress(srcIP) in scnets: #Upload quando o source está nas redes de clientes
            outc[0]=outc[0]+1
            outc[1]=outc[1]+int(lengthIP)

        if IPAddress(dstIP) in scnets: #Download quando o destination está nas redes de clientes
            outc[2]=outc[2]+1
            outc[3]=outc[3]+int(lengthIP)
        
        last_ks=ks
        npkts=npkts+1


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('-i', '--input', nargs='?',required=True, help='input file')
    parser.add_argument('-o', '--output', nargs='?',required=False, help='output file')
    parser.add_argument('-f', '--format', nargs='?',required=True, help='format',default=1)
    parser.add_argument('-d', '--delta', nargs='?',required=False, help='samplig delta interval')
    parser.add_argument('-c', '--cnet', nargs='+',required=True, help='client network(s)')
    parser.add_argument('-s', '--snet', nargs='+',required=True, help='service network(s)')
    
    args=parser.parse_args()
    
    if args.delta is None:
        sampDelta=1
    else:
        sampDelta=float(args.delta)
    
    cnets=[]
    for n in args.cnet:
        try:
            nn=IPNetwork(n)
            cnets.append(nn)
        except:
            print('{} is not a network prefix'.format(n))
    #print(cnets)
    if len(cnets)==0:
        print("No valid client network prefixes.")
        sys.exit()
    global scnets
    scnets=IPSet(cnets)

    snets=[]
    for n in args.snet:
        try:
            nn=IPNetwork(n)
            snets.append(nn)
        except:
            print('{} is not a network prefix'.format(n))
    #print(snets)
    if len(snets)==0:
        print("No valid service network prefixes.")
        sys.exit()
        
    global ssnets
    ssnets=IPSet(snets)
        
    fileInput=args.input
    fileFormat=int(args.format)
    
    if args.output is None:
        fileOutput=fileInput+"_d"+str(sampDelta)+".dat"
    else:
        fileOutput=args.output
        
    global npkts
    global T0
    global outc
    global last_ks

    npkts=0
    outc=[0,0,0,0]
    #print('Sampling interval: {} second'.format(sampDelta))

    outfile = open(fileOutput,'w') 

    if fileFormat in [1,2]:
        infile = open(fileInput,'r') 
        for line in file: 
            pktData=line.split()
            if fileFormat==1 and len(pktData)==9: #script format
                timestamp,srcIP,dstIP,lengthIP=pktData[0],pktData[4],pktData[6],pktData[8]
                pktHandler(timestamp,srcIP,dstIP,lengthIP,sampDelta,outfile)
            elif fileFormat==2 and len(pktData)==4: # tshark format "-T fileds -e frame.time_relative -e ip.src -e ip.dst -e ip.len"
                timestamp,srcIP,dstIP,lengthIP=pktData[0],pktData[1],pktData[2],pktData[3]
                pktHandler(timestamp,srcIP,dstIP,lengthIP,sampDelta,outfile)
        infile.close()
    elif fileFormat==3: #pcap format
        capture = pyshark.FileCapture(fileInput,display_filter='ip')
        for pkt in capture:
            timestamp,srcIP,dstIP,lengthIP=pkt.sniff_timestamp,pkt.ip.src,pkt.ip.dst,pkt.ip.len
            pktHandler(timestamp,srcIP,dstIP,lengthIP,sampDelta,outfile)
    
    outfile.close()


if __name__ == '__main__':
    main()
