import numpy as np
import scipy.stats as stats
import scipy.signal as signal
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
import time
import sys
import warnings
warnings.filterwarnings('ignore')


def waitforEnter(fstop=True):
	if fstop:
		if sys.version_info[0] == 2:
			raw_input("Press ENTER to continue.")
		else:
			input("Press ENTER to continue.")
			

## -- 1 -- ##
def plot3Classes(data1,name1,data2,name2,data3,name3):
	plt.subplot(3,1,1)
	plt.plot(data1)
	plt.title(name1)
	plt.subplot(3,1,2)
	plt.plot(data2)
	plt.title(name2)
	plt.subplot(3,1,3)
	plt.plot(data3)
	plt.title(name3)
	plt.show()
	waitforEnter()
	
## -- 2 -- ##
def breakTrainTest(data,oWnd=300,trainPerc=0.5):
	nSamp,nCols=data.shape
	nObs=int(nSamp/oWnd)
	data_obs=data.reshape((nObs,oWnd,nCols))
	
	order=np.random.permutation(nObs)
	order=np.arange(nObs)	#Comment out to random split
	
	nTrain=int(nObs*trainPerc)
	
	data_train=data_obs[order[:nTrain],:,:]
	data_test=data_obs[order[nTrain:],:,:]
	
	return(data_train,data_test)

## -- 3 -- ##
def extractFeatures(data,Class=0):
	features=[]
	nObs,nSamp,nCols=data.shape
	oClass=np.ones((nObs,1))*Class
	for i in range(nObs):
		M1=np.mean(data[i,:,:],axis=0)
		#Md1=np.median(data[i,:,:],axis=0)
		Std1=np.std(data[i,:,:],axis=0)
		#S1=stats.skew(data[i,:,:])
		#K1=stats.kurtosis(data[i,:,:])
		p=[75,90,95]
		Pr1=np.array(np.percentile(data[i,:,:],p,axis=0)).T.flatten()
		
		#faux=np.hstack((M1,Md1,Std1,S1,K1,Pr1))
		faux=np.hstack((M1,Std1,Pr1))
		features.append(faux)
		
	return(np.array(features),oClass)

## -- 4 -- ##
def plotFeatures(features,oClass,f1index=0,f2index=1):
	nObs,nFea=features.shape
	colors=['b','g','r']
	for i in range(nObs):
		plt.plot(features[i,f1index],features[i,f2index],'o'+colors[int(oClass[i])])

	plt.show()
	waitforEnter()
	
def logplotFeatures(features,oClass,f1index=0,f2index=1):
	nObs,nFea=features.shape
	colors=['b','g','r']
	for i in range(nObs):
		plt.loglog(features[i,f1index],features[i,f2index],'o'+colors[int(oClass[i])])

	plt.show()
	waitforEnter()

## -- 5 -- ##
def extractSilence(data,threshold=256):
	if(data[0]<=threshold):
		s=[1]
	else:
		s=[]
	for i in range(1,len(data)):
		if(data[i-1]>threshold and data[i]<=threshold):
			s.append(1)
		elif (data[i-1]<=threshold and data[i]<=threshold):
			s[-1]+=1
	
	return(s)
	
def extractFeaturesSilence(data,Class=0):
	features=[]
	nObs,nSamp,nCols=data.shape
	oClass=np.ones((nObs,1))*Class
	for i in range(nObs):
		silence_features=np.array([])
		for c in range(nCols):
			silence=extractSilence(data[i,:,c],threshold=0)
			if len(silence)>0:
				silence_features=np.append(silence_features,[np.mean(silence),np.var(silence)])
			else:
				silence_features=np.append(silence_features,[0,0])
			
			
		features.append(silence_features)
		
	return(np.array(features),oClass)

## -- 7 -- ##

def extractFeaturesWavelet(data,scales=[2,4,8,16,32],Class=0):
	features=[]
	nObs,nSamp,nCols=data.shape
	oClass=np.ones((nObs,1))*Class
	for i in range(nObs):
		scalo_features=np.array([])
		for c in range(nCols):
			#fixed scales->fscales
			scalo,fscales=scalogram.scalogramCWT(data[i,:,c],scales)
			scalo_features=np.append(scalo_features,scalo)
			
		features.append(scalo_features)
		
	return(np.array(features),oClass)
	
## -- 11 -- ##
def distance(c,p):
	return(np.sqrt(np.sum(np.square(p-c))))

########### Main Code #############
Classes={0:'YouTube',1:'Browsing',2:'Mining'}
plt.ion()
nfig=1

## -- 1 -- ##
yt=np.loadtxt('YouTube.dat')
browsing=np.loadtxt('Browsing.dat')
mining=np.loadtxt('Mining.dat')

plt.figure(1)
plot3Classes(yt,'YouTube',browsing,'Browsing',mining,'Mining')


## -- 2 -- ##
yt_train,yt_test=breakTrainTest(yt)
browsing_train,browsing_test=breakTrainTest(browsing)
mining_train,mining_test=breakTrainTest(mining)

plt.figure(2)
plt.subplot(3,1,1)
for i in range(10):
	plt.plot(yt_train[i,:,0],'b')
	plt.plot(yt_train[i,:,1],'g')
plt.title('YouTube')
plt.ylabel('Bytes/sec')
plt.subplot(3,1,2)
for i in range(10):
	plt.plot(browsing_train[i,:,0],'b')
	plt.plot(browsing_train[i,:,1],'g')
plt.title('Browsing')
plt.ylabel('Bytes/sec')
plt.subplot(3,1,3)
for i in range(10):
	plt.plot(mining_train[i,:,0],'b')
	plt.plot(mining_train[i,:,1],'g')
plt.title('Mining')
plt.ylabel('Bytes/sec')
plt.show()
waitforEnter()

## -- 3 -- ##
features_yt,oClass_yt=extractFeatures(yt_train,Class=0)
features_browsing,oClass_browsing=extractFeatures(browsing_train,Class=1)
features_mining,oClass_mining=extractFeatures(mining_train,Class=2)

features=np.vstack((features_yt,features_browsing,features_mining))
oClass=np.vstack((oClass_yt,oClass_browsing,oClass_mining))

print('Train Stats Features Size:',features.shape)

## -- 4 -- ##
plt.figure(4)
plotFeatures(features,oClass,0,1)#0,8

## -- 5 -- ##
features_ytS,oClass_yt=extractFeaturesSilence(yt_train,Class=0)
features_browsingS,oClass_browsing=extractFeaturesSilence(browsing_train,Class=1)
features_miningS,oClass_mining=extractFeaturesSilence(mining_train,Class=2)

featuresS=np.vstack((features_ytS,features_browsingS,features_miningS))
oClass=np.vstack((oClass_yt,oClass_browsing,oClass_mining))

print('Train Silence Features Size:',featuresS.shape)
plt.figure(5)
plotFeatures(featuresS,oClass,0,2)


## -- 6 -- ##
import scalogram
scales=range(2,256)
plt.figure(6)

i=0
data=yt_train[i,:,1]
S,scalesF=scalogram.scalogramCWT(data,scales)
plt.plot(scalesF,S,'b')

nObs,nSamp,nCol=browsing_train.shape
data=browsing_train[i,:,1]
S,scalesF=scalogram.scalogramCWT(data,scales)
plt.plot(scalesF,S,'g')

nObs,nSamp,nCol=mining_train.shape
data=mining_train[i,:,1]
S,scalesF=scalogram.scalogramCWT(data,scales)
plt.plot(scalesF,S,'r')

plt.show()
waitforEnter()

## -- 7 -- ##
scales=[2,4,8,16,32,64,128,256]
features_ytW,oClass_yt=extractFeaturesWavelet(yt_train,scales,Class=0)
features_browsingW,oClass_browsing=extractFeaturesWavelet(browsing_train,scales,Class=1)
features_miningW,oClass_mining=extractFeaturesWavelet(mining_train,scales,Class=2)

featuresW=np.vstack((features_ytW,features_browsingW,features_miningW))
oClass=np.vstack((oClass_yt,oClass_browsing,oClass_mining))

print('Train Wavelet Features Size:',featuresW.shape)
plt.figure(7)
plotFeatures(featuresW,oClass,3,10)

## -- 8 -- ##
from sklearn.decomposition import PCA

pca = PCA(n_components=2, svd_solver='full')
pcaFeatures = pca.fit(features).transform(features)

plt.figure(8)
plotFeatures(pcaFeatures,oClass,0,1)

## -- 9 -- ##
pca = PCA(n_components=2, svd_solver='full')
pcaFeatures = pca.fit(featuresW).transform(featuresW)

plt.figure(9)
plotFeatures(pcaFeatures,oClass,0,1)

## -- 10 -- ##

allFeatures=np.hstack((features,featuresS,featuresW))
print('Train (All) Features Size:',allFeatures.shape)

pca = PCA(n_components=3, svd_solver='full')
pcaFeatures = pca.fit(allFeatures).transform(allFeatures)

plt.figure(9)
plotFeatures(pcaFeatures,oClass,0,1)

## -- 11 -- ##

centroids={}
for c in range(3):
	pClass=(oClass==c).flatten()
	centroids.update({c:np.mean(allFeatures[pClass,:],axis=0)})
print('All Features Centroids:\n',centroids)

testFeatures_yt,oClass_yt=extractFeatures(yt_test,Class=0)
testFeatures_browsing,oClass_browsing=extractFeatures(browsing_test,Class=1)
testFeatures_mining,oClass_mining=extractFeatures(mining_test,Class=2)
testFeatures=np.vstack((testFeatures_yt,testFeatures_browsing,testFeatures_mining))

testFeatures_ytS,oClass_yt=extractFeaturesSilence(yt_test,Class=0)
testFeatures_browsingS,oClass_browsing=extractFeaturesSilence(browsing_test,Class=1)
testFeatures_miningS,oClass_mining=extractFeaturesSilence(mining_test,Class=2)
testFeaturesS=np.vstack((testFeatures_ytS,testFeatures_browsingS,testFeatures_miningS))

testFeatures_ytW,oClass_yt=extractFeaturesWavelet(yt_test,scales,Class=0)
testFeatures_browsingW,oClass_browsing=extractFeaturesWavelet(browsing_test,scales,Class=1)
testFeatures_miningW,oClass_mining=extractFeaturesWavelet(mining_test,scales,Class=2)
testFeaturesW=np.vstack((testFeatures_ytW,testFeatures_browsingW,testFeatures_miningW))

alltestFeatures=np.hstack((testFeatures,testFeaturesS,testFeaturesW))
print('Test Features Size:', alltestFeatures.shape)

testpcaFeatures=pca.transform(alltestFeatures)
print('\n-- Classification based on Distances --')
nObsTest,nFea=alltestFeatures.shape
for i in range(nObsTest):
	x=alltestFeatures[i]
	dists=[distance(x,centroids[0]),distance(x,centroids[1]),distance(x,centroids[2])]
	ndists=dists/np.sum(dists)
	testClass=np.argsort(dists)[0]
	
	print('Obs: {:2}: Normalized Distances to Centroids: [{:.4f},{:.4f},{:.4f}] -> Classification: {} -> {}'.format(i,*ndists,testClass,Classes[testClass]))

## -- 12 -- # 
from scipy.stats import multivariate_normal
print('\n-- Classification based on Multivariate PDF (PCA Features) --')
means={}
for c in range(3):
	pClass=(oClass==c).flatten()
	means.update({c:np.mean(pcaFeatures[pClass,:],axis=0)})
#print(means)

covs={}
for c in range(3):
	pClass=(oClass==c).flatten()
	covs.update({c:np.cov(pcaFeatures[pClass,:],rowvar=0)})
#print(covs)

testpcaFeatures=pca.transform(alltestFeatures)	#uses pca fitted above, only transforms test data
print(testpcaFeatures)
nObsTest,nFea=testpcaFeatures.shape
for i in range(nObsTest):
	x=testpcaFeatures[i,:]
	probs=np.array([multivariate_normal.pdf(x,means[0],covs[0]),multivariate_normal.pdf(x,means[1],covs[1]),multivariate_normal.pdf(x,means[2],covs[2])])
	testClass=np.argsort(probs)[-1]
	
	print('Obs: {:2}: Probabilities: [{:.4e},{:.4e},{:.4e}] -> Classification: {} -> {}'.format(i,*probs,testClass,Classes[testClass]))

## -- 13 -- ##
scaler=StandardScaler()
NormAllFeatures=scaler.fit_transform(allFeatures)

NormAllTestFeatures=scaler.fit_transform(alltestFeatures)

pca = PCA(n_components=3, svd_solver='full')
NormPcaFeatures = pca.fit(NormAllFeatures).transform(NormAllFeatures)

NormTestPcaFeatures = pca.fit(NormAllTestFeatures).transform(NormAllTestFeatures)

##

print('\n-- Classification based on Clustering (Kmeans) --')
from sklearn.cluster import KMeans
#K-means assuming 3 clusters
centroids=np.array([])
for c in range(3):
	pClass=(oClass==c).flatten()
	centroids=np.append(centroids,np.mean(NormPcaFeatures[pClass,:],axis=0))
centroids=centroids.reshape((3,3))
print('PCA (pcaFeatures) Centroids:\n',centroids)

kmeans = KMeans(init=centroids, n_clusters=3)
kmeans.fit(NormPcaFeatures)
labels=kmeans.labels_
print('Labels:',labels)

#Determines and quantifies the presence of each original class observation in each cluster
KMclass=np.zeros((3,3))
for cluster in range(3):
	p=(labels==cluster)
	aux=oClass[p]
	for c in range(3):
		KMclass[cluster,c]=np.sum(aux==c)

probKMclass=KMclass/np.sum(KMclass,axis=1)[:,np.newaxis]
print(probKMclass)
nObsTest,nFea=NormTestPcaFeatures.shape
for i in range(nObsTest):
	x=NormTestPcaFeatures[i,:].reshape((1,nFea))
	label=kmeans.predict(x)
	testClass=100*probKMclass[label,:].flatten()
	print('Obs: {:2}: Probabilities beeing in each class: [{:.2f}%,{:.2f}%,{:.2f}%]'.format(i,*testClass))



## -- 14 -- ##
from sklearn.cluster import DBSCAN
#DBSCAN assuming a neighborhood maximum distance of 1e11
dbscan = DBSCAN(eps=10000)
dbscan.fit(pcaFeatures)
labels=dbscan.labels_
print('Labels:',labels)

## -- 15 -- #
from sklearn import svm
print('\n-- Classification based on Support Vector Machines --')
svc = svm.SVC(kernel='linear').fit(NormAllFeatures, oClass)  
rbf_svc = svm.SVC(kernel='rbf').fit(NormAllFeatures, oClass)  
poly_svc = svm.SVC(kernel='poly',degree=2).fit(NormAllFeatures, oClass)  
lin_svc = svm.LinearSVC().fit(NormAllFeatures, oClass)  

L1=svc.predict(NormAllTestFeatures)
print('class (from test PCA features with SVC):',L1)
L2=rbf_svc.predict(NormAllTestFeatures)
print('class (from test PCA features with Kernel RBF):',L2)
L3=poly_svc.predict(NormAllTestFeatures)
print('class (from test PCA features with Kernel poly):',L3)
L4=lin_svc.predict(NormAllTestFeatures)
print('class (from test PCA features with Linear SVC):',L4)
print('\n')

nObsTest,nFea=NormAllTestFeatures.shape
for i in range(nObsTest):
	print('Obs: {:2}: SVC->{} | Kernel RBF->{} | Kernel Poly->{} | LinearSVC->{}'.format(i,Classes[L1[i]],Classes[L2[i]],Classes[L3[i]],Classes[L4[i]]))

## -- 16 -- #
print('\n-- Classification based on Support Vector Machines  (PCA Features) --')
svc = svm.SVC(kernel='linear').fit(NormPcaFeatures, oClass)  
rbf_svc = svm.SVC(kernel='rbf').fit(NormPcaFeatures, oClass)  
poly_svc = svm.SVC(kernel='poly',degree=2).fit(NormPcaFeatures, oClass)  
lin_svc = svm.LinearSVC().fit(NormPcaFeatures, oClass)  

L1=svc.predict(NormTestPcaFeatures)
print('class (from test PCA features with SVC):',L1)
L2=rbf_svc.predict(NormTestPcaFeatures)
print('class (from test PCA features with Kernel RBF):',L2)
L3=poly_svc.predict(NormTestPcaFeatures)
print('class (from test PCA features with Kernel poly):',L3)
L4=lin_svc.predict(NormTestPcaFeatures)
print('class (from test PCA features with Linear SVC):',L4)
print('\n')

nObsTest,nFea=NormTestPcaFeatures.shape
for i in range(nObsTest):
	print('Obs: {:2}: SVC->{} | Kernel RBF->{} | Kernel Poly->{} | LinearSVC->{}'.format(i,Classes[L1[i]],Classes[L2[i]],Classes[L3[i]],Classes[L4[i]]))

## -- 17 -- ##
from sklearn.neural_network import MLPClassifier
print('\n-- Classification based on Neural Networks --')

alpha=1
max_iter=100000
clf = MLPClassifier(solver='lbfgs',alpha=alpha,hidden_layer_sizes=(100,),max_iter=max_iter)
clf.fit(NormPcaFeatures, oClass) 
LT=clf.predict(NormTestPcaFeatures) 
print('class (from test PCA):',LT)

nObsTest,nFea=NormTestPcaFeatures.shape
for i in range(nObsTest):
	print('Obs: {:2}: Classification->{}'.format(i,Classes[LT[i]]))


