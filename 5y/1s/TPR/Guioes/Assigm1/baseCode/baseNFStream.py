import argparse
from nfstream import NFStreamer

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('-r', '--readfile', nargs='?',required=True, help='input file')
    parser.add_argument('-w', '--writefile', nargs='?', help='output file')
    args=parser.parse_args()
    
    readfile=args.readfile
    if args.writefile is None:
        writefile=readfile.split('.')[0]+".csv"
    else:
        writefile=args.writefile
        
    print(writefile)
        
    my_streamer = NFStreamer(source=readfile,
                         decode_tunnels=True,
                         bpf_filter=None,
                         promiscuous_mode=True,
                         snapshot_length=1536,
                         idle_timeout=120,
                         active_timeout=1800,
                         accounting_mode=0,
                         udps=None,
                         n_dissections=20,
                         statistical_analysis=False,
                         splt_analysis=0,
                         n_meters=0,
                         performance_report=0)
    my_streamer.to_csv(path=writefile)

if __name__ == '__main__':
    main()
