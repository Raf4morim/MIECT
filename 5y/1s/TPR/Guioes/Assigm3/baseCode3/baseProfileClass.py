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
from sklearn.neural_network import MLPClassifier
from scipy.stats import multivariate_normal
from sklearn import svm
import time
import sys
import warnings
warnings.filterwarnings('ignore')


def waitforEnter(fstop=False):
    if fstop:
        if sys.version_info[0] == 2:
            raw_input("Press ENTER to continue.")
        else:
            input("Press ENTER to continue.")
            
## -- 3 -- ##
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
    
## -- 11 -- ##
def distance(c,p):
    s=0
    n=0
    for i in range(len(c)):
        if c[i]>0:
            s+=np.square((p[i]-c[i])/c[i])
            n+=1
    
    return(np.sqrt(s/n))
        
    #return(np.sqrt(np.sum(np.square((p-c)/c))))

Classes = {0: 'Browsing', 1: 'YouTube', 2: 'Mining'}
plt.ion()
nfig = 1


def plotFeatures(features,oClass,f1index=0,f2index=1):
    nObs,nFea=features.shape
    colors=['b','g','r']
    #blue BROWSING
    #green for YOUTUBE
    #RED for Mining

    for i in range(nObs):
        plt.plot(features[i,f1index],features[i,f2index],'o'+colors[int(oClass[i])])

    # Adicionar nomes aos eixos e título
    plt.xlabel(f'Feature {f1index}')
    plt.ylabel(f'Feature {f2index}')
    plt.title(f'Gráfico de Features {f1index} vs {f2index}')

    plt.show()
    waitforEnter()


def clustering_with_kmeans(features, oClass):
    print('\n-- Clustering with K-Means --')
    kmeans = KMeans(n_clusters=3, random_state=0, n_init="auto")
    labels = kmeans.fit_predict(features)

    for i in range(len(labels)):
        print('Obs: {:2} ({}): K-Means Cluster Label: -> {}'.format(i, Classes[oClass[i][0]], labels[i]))


def clustering_with_dbscan(features, oClass):
    print('\n-- Clustering with DBSCAN --')
    features = StandardScaler().fit_transform(features)
    db = DBSCAN(eps=0.5, min_samples=10).fit(features)
    labels = db.labels_

    for i in range(len(labels)):
        print('Obs: {:2} ({}): DBSCAN Cluster Label: -> {}'.format(i, Classes[oClass[i][0]], labels[i]))


def anomaly_detection_with_centroids(features_train, features_test, oClass_test):
    print('\n-- Anomaly Detection based on Centroids Distances --')
    centroids = {}
    for c in range(2):  # Only the first two classes
        pClass = (o2trainClass == c).flatten()
        centroids.update({c: np.mean(features_train[pClass, :], axis=0)})
    print('All Features Centroids:\n', centroids)

    AnomalyThreshold = 10

    nObsTest, nFea = features_test.shape
    for i in range(nObsTest):
        x = features_test[i]
        dists = [distance(x, centroids[0]), distance(x, centroids[1])]
        if min(dists) > AnomalyThreshold:
            result = "Anomaly"
        else:
            result = "OK"

        print(
            'Obs: {:2} ({}): Normalized Distances to Centroids: [{:.4f},{:.4f}] -> Result -> {}'.format(
                i, Classes[oClass_test[i][0]], *dists, result)
        )


def anomaly_detection_with_ocsvm(features_train, features_test, oClass_test):
    print('\n-- Anomaly Detection based on One Class Support Vector Machines --')
    nu = 0.1
    ocsvm = svm.OneClassSVM(gamma='scale', kernel='linear', nu=nu).fit(features_train)
    rbf_ocsvm = svm.OneClassSVM(gamma='scale', kernel='rbf', nu=nu).fit(features_train)
    poly_ocsvm = svm.OneClassSVM(gamma='scale', kernel='poly', nu=nu, degree=2).fit(features_train)

    L1 = ocsvm.predict(features_test)
    L2 = rbf_ocsvm.predict(features_test)
    L3 = poly_ocsvm.predict(features_test)

    AnomResults = {-1: "Anomaly", 1: "OK"}

    nObsTest, nFea = features_test.shape
    for i in range(nObsTest):
        print(
            'Obs: {:2} ({:<8}): Kernel Linear->{:<10} | Kernel RBF->{:<10} | Kernel Poly->{:<10}'.format(
                i, Classes[oClass_test[i][0]], AnomResults[L1[i]], AnomResults[L2[i]], AnomResults[L3[i]]
            )
        )


def classification_with_svm(features_train, features_test, oClass_train, oClass_test):
    print('\n-- Classification based on Support Vector Machines --')
    svc = svm.SVC(kernel='linear').fit(features_train, oClass_train)
    rbf_svc = svm.SVC(kernel='rbf').fit(features_train, oClass_train)
    poly_svc = svm.SVC(kernel='poly', degree=2).fit(features_train, oClass_train)

    L1 = svc.predict(features_test)
    L2 = rbf_svc.predict(features_test)
    L3 = poly_svc.predict(features_test)
    print('\n')

    nObsTest, nFea = features_test.shape
    for i in range(nObsTest):
        print(
            'Obs: {:2} ({:<8}): Kernel Linear->{:<10} | Kernel RBF->{:<10} | Kernel Poly->{:<10}'.format(
                i, Classes[oClass_test[i][0]], Classes[L1[i]], Classes[L2[i]], Classes[L3[i]]
            )
        )


def classification_with_neural_networks(features_train, features_test, oClass_train, oClass_test):
    print('\n-- Classification based on Neural Networks --')
    scaler = MaxAbsScaler().fit(features_train)
    features_train_normalized = scaler.transform(features_train)
    features_test_normalized = scaler.transform(features_test)

    alpha = 1
    max_iter = 100000
    clf = MLPClassifier(solver='lbfgs', alpha=alpha, hidden_layer_sizes=(20,), max_iter=max_iter)
    clf.fit(features_train_normalized, oClass_train)
    LT = clf.predict(features_test_normalized)

    nObsTest, nFea = features_test_normalized.shape
    for i in range(nObsTest):
        print('Obs: {:2} ({:<8}): Classification->{}'.format(i, Classes[oClass_test[i][0]], Classes[LT[i]]))


features_browsing = np.loadtxt("BrowsingAllF.dat")
features_yt = np.loadtxt("YouTubeAllF.dat")
features_mining = np.loadtxt("MiningAllF.dat")

oClass_browsing = np.ones((len(features_browsing), 1)) * 0
oClass_yt = np.ones((len(features_yt), 1)) * 1
oClass_mining = np.ones((len(features_mining), 1)) * 2

features = np.vstack((features_yt, features_browsing, features_mining))
oClass = np.vstack((oClass_yt, oClass_browsing, oClass_mining))

print('Train Silence Features Size:',features.shape)
plt.figure(2)
plotFeatures(features,oClass,4,10)
plt.figure(4)
plotFeatures(features,oClass,2,8)

percentage = 0.5
pB = int(len(features_browsing) * percentage)
trainFeatures_browsing = features_browsing[:pB, :]
pYT = int(len(features_yt) * percentage)
trainFeatures_yt = features_yt[:pYT, :]
pM = int(len(features_mining) * percentage)
trainFeatures_mining = features_mining[:pYT, :]

i2train = np.vstack((trainFeatures_browsing, trainFeatures_yt))
o2trainClass = np.vstack((oClass_browsing[:pB], oClass_yt[:pYT]))

i3Ctrain = np.vstack((trainFeatures_browsing, trainFeatures_yt, trainFeatures_mining))
o3trainClass = np.vstack((oClass_browsing[:pB], oClass_yt[:pYT], oClass_mining[:pM]))

testFeatures_browsing = features_browsing[pB:, :]
testFeatures_yt = features_yt[pYT:, :]
testFeatures_mining = features_mining[pM:, :]

i3Atest = np.vstack((testFeatures_browsing, testFeatures_yt, testFeatures_mining))
o3testClass = np.vstack((oClass_browsing[pB:], oClass_yt[pYT:], oClass_mining[pM:]))

i3train=np.vstack((trainFeatures_browsing,trainFeatures_yt,trainFeatures_mining))
i3Ctest=np.vstack((testFeatures_browsing,testFeatures_yt,testFeatures_mining))

clustering_with_kmeans(i3Ctrain, o3trainClass)
clustering_with_dbscan(i3Ctrain, o3trainClass)
anomaly_detection_with_centroids(i2train, i3Atest, o3testClass)
anomaly_detection_with_ocsvm(i2train, i3Atest, o3testClass)
classification_with_svm(i3train, i3Ctest, o3trainClass, o3testClass)
classification_with_neural_networks(i3train, i3Ctest, o3trainClass, o3testClass)

waitforEnter(fstop=True)