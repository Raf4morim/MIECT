from snimpy.manager import Manager as M
from snimpy.manager import load
from snimpy import mib
import time
import re
import argparse

def IPfromOctetString(t,s):
    if t==1 or t==3:    #IPv4 global, non-global
        return '.'.join([str(x) for x in s])
    elif t==2 or t==4:    #IPv6 global, non-global
        a=':'.join(['{:02X}{:02X}'.format(s[i],s[i+1]) for i in range(0,16,2)])
        return re.sub(':{1,}:','::',re.sub(':0*',':',a))

def main():
    #mib.path(mib.path()+":/usr/share/mibs/cisco")
    mib.path("./mibs/cisco/:./mibs/iana/:./mibs/ietf/")
    load("SNMPv2-MIB")
    load("IF-MIB")
    load("IP-MIB")
    load("RFC1213-MIB")
    load("CISCO-QUEUE-MIB")
    #Requires MIB RFC-1212 (add to /usr/share/mibs/ietf/)

    parser = argparse.ArgumentParser()
    parser.add_argument('-r', '--router', nargs='?',required=True, help='address of router to monitor')
    parser.add_argument('-s', '--sinterval', type=int, help='sampling interval (seconds)',default=5)
    args=parser.parse_args()

    print(args)

    #Creates SNMP manager for router with address args.router
    m=M(args.router,'private',3, secname='uDDR',authprotocol="MD5", authpassword="authpass",privprotocol="AES", privpassword="privpass")

    print(m.sysDescr)    #Gets sysDescr from SNMPv2-MIB

    print("===")

    print(list(m.ifDescr.items())) #Lists (order, name) interfaces in ifDescr from IF-MIB

    ifNames={}    #Stores (order: if name) of all interfaces
    for i, name in m.ifDescr.items():
        ifNames.update({i:name})
        print("Interface order {}: {}".format(i, name))
    print(ifNames)
    
    print("===")

    print(list(m.ipAddressIfIndex.items())) #Lists ((adr.type,adr),order) interfaces in ipAddressIfIndex from IP-MIB

    ifAddr={};    #Stores (order: first adr.) of all interfaces
    for addr, i in m.ipAddressIfIndex.items():
        if not i in ifAddr:
            ifAddr.update({i:IPfromOctetString(addr[0],addr[1])})
        print('{}, Interface order: {}, {}'.format(IPfromOctetString(addr[0],addr[1]),i,m.ifDescr[i]))

    print(ifAddr)

    print("===")
    try:
        while True:
            bytesOutIf=m.ifHCOutOctets
            print(list(bytesOutIf.items()))
            ifBytes={}
            for i, count in bytesOutIf.items():
                ifBytes.update({i:count})    #Stores (order: byte count) of all interfaces
            print(ifBytes)    
            
            for i in ifAddr:
                print("\t{}: {} Bytes Out: {}".format(ifNames[i],ifAddr[i],ifBytes[i]))
            time.sleep(5)
    except KeyboardInterrupt:
        print("\nEnd")
    
    

if __name__ == "__main__":
    main()
