import numpy as np
import matplotlib.pyplot as plt
datFile = 'outFile_result_test_basePktSampling_1seg.dat'
data=np.loadtxt(datFile,dtype=int)
plt.plot(data[:,0],data[:,1],'k')
plt.show()
plt.plot(data[:,0],data[:,3],'b')
plt.show()
