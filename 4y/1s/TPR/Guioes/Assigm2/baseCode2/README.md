```bash
sudo tshark -i 1 -w test.pcap -F pcap -a duration:300
```
```bash
python3 basePktSampling.py -i test.pcap -f 3 -d 0.1 -c 192.168.1.0/25 -s 0.0.0.0/0
```
```bash
python3 basePktSampling.py -i test.pcap -f 3 -d 1 -c 192.168.1.0/25 -s 0.0.0.0/0 -o outFile.txt
```
-----------------------------------------------------

```bash
sudo pip3 install numpy
```
```bash
sudo pip3 install scipy
```
```bash
sudo pip3 install matplotlib
```
```bash
sudo apt install plotutils
```
```bash
python3 basePktFeaturesExt.py -i outFile.txt -m 1 -w 10
```


