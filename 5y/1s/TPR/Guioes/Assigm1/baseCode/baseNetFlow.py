import sys
import socket
import struct
import argparse
from netaddr import IPNetwork, IPAddress

def int_to_ipv4(addr):
    return "{}.{}.{}.{}".format(addr >> 24 & 0xff, addr >> 16 & 0xff, addr >> 8 & 0xff, addr & 0xff)

def getNetFlowData(data):
    sdata=struct.unpack("!H", data[:2])
    version = sdata[0]
    
    if version==1:
        print("NetFlow version {}:".format(version))
        hformat="!HHIII" 
        # ! - network (= big-endian), H - C unsigned short (2 bytes), I - C unsigned int (4 bytes)
        hlen = struct.calcsize(hformat)
        if len(data) < hlen:
            print("Truncated packet (header)")
            return 0,0
        sheader= struct.unpack(hformat, data[:hlen])
        version = sheader[0]
        num_flows = sheader[1]
        #more header
        
        print(num_flows)
        fformat="!IIIHHIIIIHHHBBBBBBI"
        # B - C unsigned char (1 byte)
        flen=struct.calcsize(fformat)
        
        if len(data) - hlen != num_flows * flen:
            print("Packet truncated (flows data)")
            return 0,0
        
        flows={}
        for n in range(num_flows):
            flow={}
            offset = hlen + flen*n
            fdata = data[offset:offset + flen]
            sflow=struct.unpack(fformat, fdata)
            flow.update({'src_addr':int_to_ipv4(sflow[0])})
            #more flow
            flows.update({n:flow})
    else:
        print("NetFlow version {} not supported!".format(version))
    
    out=version,flows
    return out

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('-p', '--port', nargs='?',type=int,help='listening UDP port',default=9996)
    parser.add_argument('-n', '--net', nargs='+',required=True, help='networks')
    parser.add_argument('-r', '--router', nargs='+',required=True, help='IP address(es) of NetFlow router(s)')
    args=parser.parse_args()

    nets=[]
    for n in args.net:
        try:
            nn=IPNetwork(n)
            nets.append(nn)
        except:
            print('{} is not a network prefix'.format(n))
    print(nets)
    if len(nets)==0:
        print("No valid network prefixes.")
        sys.exit()

    router=[]
    for r in args.router:
        try:
            rr=IPAddress(r)
            router.append(rr)
        except:
            print('{} is not an IP address'.format(r))
    print(router)
    if len(router)==0:
        print("No valid router IP address.")
        sys.exit()
        
    udp_port=args.port
    sock = socket.socket(socket.AF_INET,socket.SOCK_DGRAM) # UDP
    sock.bind(('0.0.0.0', udp_port))
    print("listening on '0.0.0.0':{}".format(udp_port)) 

    try: 
        while 1:
            data, addr = sock.recvfrom(8192)        # buffer size is 8192 bytes
            version,flows=getNetFlowData(data)        #version=0 reports an error!
            print('Version: {}'.format(version))
            print(flows)
    except KeyboardInterrupt:
        sock.close()
        print("\nDone!")

if __name__ == "__main__":
    main()
