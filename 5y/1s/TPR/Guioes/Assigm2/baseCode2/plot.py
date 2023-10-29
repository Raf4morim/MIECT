import numpy as np
import matplotlib.pyplot as plt
datFile = 'outFile2.txt'
data=np.loadtxt(datFile,dtype=int)
plt.plot(data[:,0],data[:,1],'k')
plt.show()
plt.plot(data[:,0],data[:,3],'b')
plt.show()
