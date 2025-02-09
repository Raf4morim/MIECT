import numpy as np
from os.path import exists
import matplotlib.pyplot as plt
from sklearn.discriminant_analysis import StandardScaler
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import MaxAbsScaler
from sklearn.model_selection import train_test_split
from sklearn.neighbors import LocalOutlierFactor
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import MaxAbsScaler
from sklearn.decomposition import PCA
from scipy.stats import multivariate_normal
from sklearn.metrics import confusion_matrix
from sklearn.neural_network import MLPClassifier
from sklearn.decomposition import PCA
from sklearn.covariance import EllipticEnvelope
from sklearn.preprocessing import MaxAbsScaler
from sklearn.mixture import GaussianMixture

from sklearn import svm
import seaborn as sns
from sklearn.metrics import f1_score
import sys
import pandas as pd
import os

# def getMatchPredict(actual_labels, predicted_labels):
    # tp = sum(1 for actual, predicted in zip(actual_labels, predicted_labels) if actual == predicted == 1) # A previsão foi de que um evento ocorreria e ele realmente aconteceu.
    # tn = sum(1 for actual, predicted in zip(actual_labels, predicted_labels) if actual == predicted == 0) # A previsão foi de que um evento não ocorreria e ele realmente não aconteceu.
    # fp = sum(1 for actual, predicted in zip(actual_labels, predicted_labels) if actual != predicted and predicted == 1) # A previsão foi de que um evento ocorreria, mas ele não aconteceu
    # fn = sum(1 for actual, predicted in zip(actual_labels, predicted_labels) if actual != predicted and predicted == 0) # A previsão foi de que um evento não ocorreria, mas ele aconteceu.
    # return tn, fp, fn, tp 

def printMetrics(tp, tn, fp, fn, accuracy, precision, recall, f1_score):
    print(f'\nTrue Positives: {tp}, False Negatives: {fn}')
    print(f'False Positives: {fp}, True Negatives: {tn}')
    print(f'Accuracy: {accuracy:.2f}')
    print(f'Precision: {precision:.2f}')
    print(f'Recall: {recall:.2f}')
    print(f'F1-Score: {f1_score:.2f}\n')

def calculate_metrics(tp, tn, fp, fn):
    accuracy = (tp + tn) / (tp + tn + fp + fn) * 100
    precision = tp / (tp + fp) * 100 if (tp + fp) > 0 else 0
    recall = tp / (tp + fn) * 100 if (tp + fn) > 0 else 0
    f1_score = 2 * precision * recall / (precision + recall) if (precision + recall) > 0 else 0
    return accuracy, precision, recall, f1_score

def resultsConfusionMatrix(actual_labels, predicted_labels, results, n_components=None, threshold=None, kernel=None):
    tn, fp, fn, tp = confusion_matrix(actual_labels, predicted_labels).ravel()
    accuracy, precision, recall, f1_score = calculate_metrics(tp, tn, fp, fn)

    if kernel is not None:
        results['Kernel'].append(kernel.capitalize())
    if n_components is not None:
        results['Components'].append(n_components)
    if threshold is not None:
        results['Threshold'].append(threshold)
    results['TP'].append(tp)
    results['FP'].append(fp)
    results['TN'].append(tn)
    results['FN'].append(fn)
    results['Accuracy'].append(accuracy)
    results['Precision'].append(precision)
    results['Recall'].append(recall)
    results['F1 Score'].append(f1_score)
    total = tn + fp + fn + tp
    # Normalize each element of the confusion matrix
    normalized_tn = tn / total
    normalized_fp = fp / total
    normalized_fn = fn / total
    normalized_tp = tp / total
    results['ConfusionMatrix'].append((normalized_tp, normalized_fn, normalized_fp, normalized_tn))
    return results

def distance(c,p):
    s=0
    n=0
    for i in range(len(c)):
        if c[i]>0:
            s+=np.square((p[i]-c[i])/c[i])
            n+=1
    return(np.sqrt(s/n))

def centroids_distances(sil, i2train, o2train, i3test, o3test, bot):
    print("----------------centroids_distances----------------")
    silence = 'Silence' if sil else 'No Silence'
    
    # Scale the training and testing data
    trainScaler = MaxAbsScaler().fit(i2train)
    i2train_scaled = trainScaler.transform(i2train)
    i3test_scaled = trainScaler.transform(i3test)

    # Calculate the centroid for the client class (class = 0)
    centroids = {0: np.mean(i2train_scaled[(o2train == 0).flatten(), :], axis=0)}

    # Actual labels from the test set
    actual_labels = o3test.flatten()

    # Initialize results dictionary
    results = {'Threshold': [], 'TP': [], 'FP': [], 'TN': [], 'FN': [], 'Accuracy': [], 'Precision': [], 'Recall': [], 'F1 Score': [], 'ConfusionMatrix': []}

    # Threshold values to evaluate
    threshold_values = [0.1, 0.2, 0.3, 0.4]

    for threshold in threshold_values:
        # Compute distances for all test samples at once
        distances = np.array([distance(i3test_scaled[i], centroids[0]) for i in range(i3test_scaled.shape[0])])
        # Predict labels based on the threshold
        predicted_labels = (distances > threshold).astype(float)
        # Update results
        results = resultsConfusionMatrix(actual_labels, predicted_labels, results, threshold=threshold)
        print(results)

    df = pd.DataFrame(results)
    best_result = df.loc[df['F1 Score'].idxmax()]
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(best_result['ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 4))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f', xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f"({silence}) Best Confusion Matrix (Centroid-Based, Threshold: {best_result['Threshold']})")
    # plt.show()
   
    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestCentroidsWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestCentroidsWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)

    return results

def centroids_distances_pca(sil, components_to_test, trainFeatures_browsing, o2train, testFeatures_browsing, testFeatures_atck, o3test, bot):
    print("----------------centroids_distances_pca----------------")
    silence = 'Silence' if sil else 'No Silence'
    results = {'Components': [],'Threshold': [],'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}

    for n_components in components_to_test:
        scaler = StandardScaler()
        scaled_train = scaler.fit_transform(trainFeatures_browsing)
        scaled_test = scaler.transform(np.vstack((testFeatures_browsing, testFeatures_atck)))

        pca = PCA(n_components=n_components)
        i2train_pca = pca.fit_transform(np.vstack(scaled_train))
        centroids = np.mean(i2train_pca[(o2train == 0).flatten(), :], axis=0)

        i3Atest_pca = pca.transform(scaled_test)
        actual_labels = o3test.flatten()

        threshold_values = [0.1, 0.2, 0.3, 0.4, 0.5, 1.0, 1.2, 1.1, 1.5, 2.0, 3, 5, 6, 10]

        for threshold in threshold_values:
            distances = np.linalg.norm(i3Atest_pca - centroids, axis=1)
            predicted_labels = (distances > threshold).astype(float) * 1.0  # Anomalies are labeled as 1.0
            results = resultsConfusionMatrix(actual_labels, predicted_labels, results, n_components=n_components, threshold=threshold, kernel=None)

    df = pd.DataFrame(results)
    best_result = df.loc[df['F1 Score'].idxmax()]
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(best_result['ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 4))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f', xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.title(f"({silence}) Best on PCA Centroid-Based is Components: {best_result['Components']}, Threshold: {best_result['Threshold']})")
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    # plt.show()
    
    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestCentroidsWith{best_result['Components']}PCAComponentes.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestCentroidsWith{best_result['Components']}PCAComponentes.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    return results

def oc_svm(data2ensemble_pred, sil, trainFeatures_browsing, testFeatures_browsing, testFeatures_atck, o3test, bot):
    print("----------------oc_svm----------------")
    silence = 'Silence' if sil else 'No Silence'
    results = {'Kernel': [], 'TP': [], 'FP': [], 'TN': [], 'FN': [], 'Accuracy': [], 'Precision': [], 'Recall': [], 'F1 Score': [], 'ConfusionMatrix': []}
    
    i2train = trainFeatures_browsing
    i3test = np.vstack((testFeatures_browsing, testFeatures_atck))

    kernels = ['linear', 'rbf', 'poly']
    svm_models = [svm.OneClassSVM(gamma='scale', kernel=k, nu=0.5, degree=2 if k == 'poly' else 3).fit(i2train) for k in kernels]
    for kernel, model in zip(kernels, svm_models):
        # model.fit(i2train)
        predictions = model.predict(i3test)
        # Convert predictions from -1 (anomaly) and 1 (normal) to 0 (anomaly) and 1 (normal)
        predictions = np.where(predictions == -1, 0, 1)
        data2ensemble_pred.append(predictions.tolist())

        results = resultsConfusionMatrix(o3test.flatten(), predictions, results, kernel=kernel)

    # Find the index of the row with the best F1 score
    df = pd.DataFrame(results)
    best_f1_index = df['F1 Score'].idxmax()

    # Print the best results
    best_result = df.iloc[best_f1_index]
    printMetrics(best_result['TP'], best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])

    # Plot the best confusion matrix
    best_confusion_matrix = np.array(df.loc[best_f1_index, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(best_confusion_matrix,annot=True, cmap='Blues', fmt='.2f', xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted label')
    plt.ylabel('Real label')
    plt.title(f'({silence}) Best Confusion Matrix OC SVM - {df.loc[best_f1_index, "Kernel"].capitalize()} Kernel')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestOCSVMWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestOCSVMWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)

    return results, data2ensemble_pred

def oc_svm_pca(data2ensemble_pred, sil, max_pca_components, trainFeatures_browsing, testFeatures_browsing, testFeatures_atck, o3test, bot):
    print("----------------oc_svm_pca----------------")
    silence = 'Silence' if sil else 'No Silence'
    results = {'Components': [], 'Kernel': [], 'TP': [], 'FP': [], 'TN': [], 'FN': [], 'Accuracy': [], 'Precision': [], 'Recall': [], 'F1 Score': [], 'ConfusionMatrix': []}
    kernels = ['linear', 'rbf', 'poly']
    # Define the range of PCA components
    scaler = MaxAbsScaler()
    scaled_train = scaler.fit_transform(trainFeatures_browsing)
    scaled_test = scaler.transform(np.vstack((testFeatures_browsing, testFeatures_atck)))
    for n_components in max_pca_components:
        # Aplicação da PCA
        pca = PCA(n_components=n_components)
        i2train_pca = pca.fit_transform(scaled_train)
        i3Atest_pca = pca.transform(scaled_test)
        svm_models = [svm.OneClassSVM(gamma='scale', kernel=k, nu=0.5, degree=2 if k == 'poly' else 3).fit(i2train_pca) for k in kernels]
        for kernel, model in zip(kernels, svm_models):
            # model.fit(i2train_pca)
            predictions = model.predict(i3Atest_pca)
            # Convert predictions from -1 (anomaly) and 1 (normal) to 0 (anomaly) and 1 (normal)
            predictions = np.where(predictions == -1, 0, 1)
            data2ensemble_pred.append(predictions.tolist())
            # Use the resultsConfusionMatrix function to calculate and store results
            # print("kernel: ", kernel)
            results = resultsConfusionMatrix(o3test.flatten(), predictions, results, kernel=kernel, n_components=n_components)
            # print(results)

    # Find the index of the row with the best F1 score
    df = pd.DataFrame(results)
    best_f1_index = df['F1 Score'].idxmax()
    best_components = df.loc[best_f1_index, 'Components']

    # Print the best results
    best_result = df.iloc[best_f1_index]
    printMetrics(best_result['TP'], best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])

    # Plot the best confusion matrix
    best_confusion_matrix = np.array(df.loc[best_f1_index, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(best_confusion_matrix,annot=True, cmap='Blues', fmt='.2f', xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted label')
    plt.ylabel('Real label')
    plt.title(f'({silence}) Best Confusion Matrix OC SVM - {df.loc[best_f1_index, "Kernel"].capitalize()} Kernel\nWith {best_components} PCA Components')
    # plt.show()
    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestOCSVMWith{best_components}PCAComponents.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestOCSVMWith{best_components}PCAComponents.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    # print(" data2ensemble:\n",  data2ensemble)
    return results, data2ensemble_pred

def local_outlier_factor(data2ensemble_pred, sil, trainFeatures_browsing, testFeatures_browsing, testFeatures_atck, o3train, o3test, bot):
    print("----------------local outlier factor----------------")
    silence = 'Silence' if sil else 'No Silence'    

    scaled_train_features = trainFeatures_browsing
    scaled_test_features = np.vstack((testFeatures_browsing, testFeatures_atck))

    # Adjust LOF parameters
    lof = LocalOutlierFactor(n_neighbors=15, contamination=0.2, novelty=True)
    lof.fit(scaled_train_features)
    predictions = lof.predict(scaled_test_features)
    predictions = np.where(predictions == -1, 0, 1)  # Convert predictions

    data2ensemble_pred.append(predictions.tolist()) #
    # Initialize results dictionary
    results = {'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}
    results = resultsConfusionMatrix(o3test, predictions, results, n_components=None, threshold=None, kernel=None)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best on LOF without PCA')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestLOFWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestLOFWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    
    return results, data2ensemble_pred

def local_outlier_factor_pca(data2ensemble_pred, sil, pcaComponents, trainFeatures_browsing, testFeatures_browsing, trainFeatures_attack, testFeatures_atck, o3train, o3test, bot):
    print("----------------local_outlier_pca----------------")
    silence = 'Silence' if sil else 'No Silence'   
    results = {'Components': [],'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}

    i2train = np.vstack((trainFeatures_browsing))
    i3Ctest = np.vstack((testFeatures_browsing, testFeatures_atck))
    predictions_dict = {}

    for n_components in pcaComponents:
        pca = PCA(n_components=n_components)
        i2train_pca = pca.fit_transform(i2train)
        i3Ctest_pca = pca.transform(i3Ctest)

        lof = LocalOutlierFactor(n_neighbors=15, contamination=0.2)
        lof.fit(i2train_pca)
        predictions = lof.fit_predict(i3Ctest_pca)
        predictions = np.where(predictions == -1, 0, 1)

        predictions_dict[n_components] = predictions.tolist()

        # data2ensemble_pred.append(predictions.tolist()) #
        results = resultsConfusionMatrix(o3test, predictions, results, n_components=n_components, threshold=None, kernel=None)
        # print(results)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    best_components = df.loc[best_f1_score, 'Components']

    best_Pred = predictions_dict[best_components]
    data2ensemble_pred.append(best_Pred) #
    print("------------------> ", best_Pred)

    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best Confusion Matrix: LOF with {best_components} PCA Components')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestLOFwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestLOFwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    return results, data2ensemble_pred

def robust_covariance(data2ensemble_pred, sil, trainFeatures_browsing, testFeatures_browsing, testFeatures_atck, o3train, o3test, bot):
    print("----------------robust covariance----------------")
    silence = 'Silence' if sil else 'No Silence'    

    scaled_train_features = trainFeatures_browsing
    scaled_test_features = np.vstack((testFeatures_browsing, testFeatures_atck))

    # Adjust EllipticEnvelope parameters
    robust_cov = EllipticEnvelope(contamination=0.2)
    robust_cov.fit(scaled_train_features)
    predictions = robust_cov.predict(scaled_test_features)
    predictions = np.where(predictions == -1, 0, 1)  # Convert predictions

    data2ensemble_pred.append(predictions.tolist()) #
    # Initialize results dictionary
    results = {'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}
    results = resultsConfusionMatrix(o3test, predictions, results, n_components=None, threshold=None, kernel=None)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best on robust covariance without PCA')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestRCWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestRCWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    
    return results, data2ensemble_pred

def robust_covariance_pca(data2ensemble_pred, sil, pcaComponents, trainFeatures_browsing, testFeatures_browsing, trainFeatures_attack, testFeatures_atck, o3train, o3test, bot):
    print("----------------robust covariance_pca----------------")
    silence = 'Silence' if sil else 'No Silence'   
    results = {'Components': [],'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}

    i2train = np.vstack((trainFeatures_browsing))
    i3Ctest = np.vstack((testFeatures_browsing, testFeatures_atck))

    predictions_dict = {}
    for n_components in pcaComponents:
        pca = PCA(n_components=n_components)
        i2train_pca = pca.fit_transform(i2train)
        i3Ctest_pca = pca.transform(i3Ctest)

        robust_cov = EllipticEnvelope(contamination=0.2)
        robust_cov.fit(i2train_pca)
        predictions = robust_cov.predict(i3Ctest_pca)
        predictions = np.where(predictions == -1, 0, 1)

        predictions_dict[n_components] = predictions.tolist()

        # data2ensemble_pred.append(predictions.tolist()) #
        results = resultsConfusionMatrix(o3test, predictions, results, n_components=n_components, threshold=None, kernel=None)
        # print(results)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    best_components = df.loc[best_f1_score, 'Components']

    best_Pred = predictions_dict[best_components]
    data2ensemble_pred.append(best_Pred) #
    print("------------------> ", best_Pred)

    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best Confusion Matrix: robust covariance with {best_components} PCA Components')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestRCwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestRCwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    return results, data2ensemble_pred

def gaussianMix(data2ensemble_pred, sil, trainFeatures_browsing, testFeatures_browsing, testFeatures_atck, o3train, o3test, bot):
    print("----------------gaussianMix----------------")
    silence = 'Silence' if sil else 'No Silence'    

    # Scale features
    scaler = StandardScaler()
    train_features = scaler.fit_transform(np.vstack((trainFeatures_browsing)))
    test_features = scaler.transform(np.vstack((testFeatures_browsing, testFeatures_atck)))

    # Use BIC to select the number of components
    lowest_bic = np.infty
    bic = []
    n_components_range = range(1, 11)  # You can adjust this range
    cv_types = ['spherical', 'tied', 'diag', 'full']
    best_gmm_params = {}
    for cv_type in cv_types:
        for n_components in n_components_range:
            gmm = GaussianMixture(n_components=n_components, covariance_type=cv_type, reg_covar=1e-4, random_state=0)
            gmm.fit(train_features)
            bic_score = gmm.bic(train_features)
            bic.append(bic_score)
            if bic_score < lowest_bic:
                lowest_bic = bic_score
                best_gmm_params = {'n_components': n_components, 'covariance_type': cv_type, 'bic_score': bic_score}

    # Fit the best model
    best_gmm = GaussianMixture(n_components=best_gmm_params['n_components'], covariance_type=best_gmm_params['covariance_type'], reg_covar=1e-4, random_state=0)
    best_gmm.fit(train_features)

    # Predict using the best model
    log_likelihood = best_gmm.score_samples(test_features)
    threshold = np.percentile(log_likelihood, 5)  # Adjusted threshold selection method
    predictions = log_likelihood < threshold
    predictions = np.where(predictions, 0, 1)
    
    # print ("predictions -----> ", predictions)
    data2ensemble_pred.append(predictions.tolist()) #

    # Initialize results dictionary
    results = {'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}
    results = resultsConfusionMatrix(o3test, predictions, results, n_components=None, threshold=None, kernel=None)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best on Gaussian Mixture without PCA')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestGMWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestGMWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    
    return results, data2ensemble_pred

def gaussianMix_pca(data2ensemble_pred, sil, pcaComponents, trainFeatures_browsing, testFeatures_browsing, trainFeatures_attack, testFeatures_atck, o3train, o3test, bot):
    print("----------------gaussianMix_pca----------------")
    silence = 'Silence' if sil else 'No Silence'   
    results = {'Components': [],'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}

    scaler = StandardScaler()
    # Scale features before applying PCA
    train_features_scaled = scaler.fit_transform(np.vstack((trainFeatures_browsing)))
    test_features_scaled = scaler.transform(np.vstack((testFeatures_browsing, testFeatures_atck)))
    predictions_dict = {}
    for n_components in pcaComponents:
        pca = PCA(n_components=n_components)
        train_features_pca = pca.fit_transform(train_features_scaled)
        test_features_pca = pca.transform(test_features_scaled)

        # Use BIC to select the number of components for GMM after applying PCA
        lowest_bic = np.infty
        bic = []
        n_components_range = range(1, 7)
        cv_types = ['spherical', 'tied', 'diag', 'full']
        for cv_type in cv_types:
            for n_components_gmm in n_components_range:
                gmm = GaussianMixture(n_components=n_components_gmm, covariance_type=cv_type, reg_covar=1e-4, random_state=0)
                gmm.fit(train_features_pca)
                bic.append(gmm.bic(train_features_pca))
                if bic[-1] < lowest_bic:
                    lowest_bic = bic[-1]
                    best_gmm = gmm

        # Fit the best GMM model
        gmm = best_gmm.fit(train_features_pca)

        # Predict using the best GMM model
        log_likelihood = gmm.score_samples(test_features_pca)
        threshold = np.percentile(log_likelihood, 5)  # Using the 5th percentile as threshold
        predictions = log_likelihood < threshold
        predictions = np.where(predictions, 0, 1)

        predictions_dict[n_components] = predictions.tolist()

        # data2ensemble_pred.append(predictions.tolist()) #
        results = resultsConfusionMatrix(o3test, predictions, results, n_components=n_components, threshold=None, kernel=None)
        # print(results)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    best_components = df.loc[best_f1_score, 'Components']
    best_Pred = predictions_dict[best_components]
    data2ensemble_pred.append(best_Pred) #
    print("------------------> ", best_Pred)


    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best Confusion Matrix: Gaussian Mixture with {best_components} PCA Components')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestGMwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestGMwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    return results, data2ensemble_pred

def ee(data2ensemble_pred, sil, trainFeatures_browsing, testFeatures_browsing, testFeatures_atck, o3train, o3test, bot):
    print("----------------EllipticEnvelope----------------")
    silence = 'Silence' if sil else 'No Silence'    
    train_features = trainFeatures_browsing
    test_features = np.vstack((testFeatures_browsing, testFeatures_atck))

    # Train Elliptic Envelope model
    ee = EllipticEnvelope(contamination=0.1)
    ee.fit(train_features)
    predictions = ee.predict(test_features)
    predictions = np.where(predictions == -1, 0, 1)  # Outliers are labeled as 0

    data2ensemble_pred.append(predictions.tolist()) #
    # Initialize results dictionary
    results = {'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}
    results = resultsConfusionMatrix(o3test, predictions, results, n_components=None, threshold=None, kernel=None)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best on EllipticEnvelope without PCA')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestEEWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestEEWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    
    return results, data2ensemble_pred

def ee_pca(data2ensemble_pred, sil, pcaComponents, trainFeatures_browsing, testFeatures_browsing, trainFeatures_attack, testFeatures_atck, o3train, o3test, bot):
    print("----------------EllipticEnvelope----------------")
    silence = 'Silence' if sil else 'No Silence'   
    results = {'Components': [],'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}

    i2train = np.vstack((trainFeatures_browsing))
    i3Ctest = np.vstack((testFeatures_browsing, testFeatures_atck))

    for n_components in pcaComponents:
        pca = PCA(n_components=n_components)
        i2train_pca = pca.fit_transform(i2train)
        i3Ctest_pca = pca.transform(i3Ctest)

        # Use EllipticEnvelope for outlier detection on the PCA-transformed data
        ee = EllipticEnvelope(support_fraction=0.994, contamination=0.1)
        ee.fit(i2train_pca)  # Fit the model to the browsing data only
        predictions = ee.predict(i3Ctest_pca)
        # In EllipticEnvelope, -1 is an outlier and 1 is inlier
        predictions = np.where(predictions == -1, 0, 1)

        data2ensemble_pred.append(predictions.tolist()) #
        results = resultsConfusionMatrix(o3test, predictions, results, n_components=n_components, threshold=None, kernel=None)
        # print(results)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    best_components = df.loc[best_f1_score, 'Components']
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best Confusion Matrix: EllipticEnvelope with {best_components} PCA Components')

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestEEwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestEEwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    return results, data2ensemble_pred

def iforest(data2ensemble_pred, sil, trainFeatures_browsing, testFeatures_browsing, testFeatures_atck, o3train, o3test, bot):
    print("----------------Isolation Foreste----------------")
    silence = 'Silence' if sil else 'No Silence'    
    train_features = trainFeatures_browsing
    test_features = np.vstack((testFeatures_browsing, testFeatures_atck))

    # Train Isolation Forest model
    iforest = IsolationForest(contamination=0.1)
    iforest.fit(train_features)
    predictions = iforest.predict(test_features)
    predictions = np.where(predictions == -1, 0, 1)  # Outliers are labeled as 0

    data2ensemble_pred.append(predictions.tolist()) #
    # Initialize results dictionary
    results = {'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}
    results = resultsConfusionMatrix(o3test, predictions, results, n_components=None, threshold=None, kernel=None)
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best on Isolation Forest without PCA')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestIFWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestIFWithoutPCA.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    
    return results, data2ensemble_pred

def iforest_pca(data2ensemble_pred, sil, pcaComponents, trainFeatures_browsing, testFeatures_browsing, trainFeatures_attack, testFeatures_atck, o3train, o3test, bot):
    print("----------------Isolation Foreste----------------")
    silence = 'Silence' if sil else 'No Silence'   
    results = {'Components': [],'TP': [],'FP': [],'TN': [],'FN': [],'Accuracy': [],'Precision': [],'Recall': [],'F1 Score': [],'ConfusionMatrix': []}

    i2train = np.vstack((trainFeatures_browsing))
    i3Ctest = np.vstack((testFeatures_browsing, testFeatures_atck))

    predictions_dict = {}

    for n_components in pcaComponents:
        pca = PCA(n_components=n_components)
        i2train_pca = pca.fit_transform(i2train)
        i3Ctest_pca = pca.transform(i3Ctest)

        # Use Isolation Forest for outlier detection on the PCA-transformed data
        iforest = IsolationForest(contamination=0.1)
        iforest.fit(i2train_pca)  # Fit the model to the browsing data only
        predictions = iforest.predict(i3Ctest_pca)
        predictions = np.where(predictions == -1, 0, 1)

        predictions_dict[n_components] = predictions.tolist()

        # data2ensemble_pred.append(predictions.tolist()) #
        results = resultsConfusionMatrix(o3test, predictions, results, n_components=n_components, threshold=None, kernel=None)
        # print(results)
        
    df = pd.DataFrame(results)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    best_components = df.loc[best_f1_score, 'Components']
    best_Pred = predictions_dict[best_components]
    data2ensemble_pred.append(best_Pred) #
    print("------------------> ", best_Pred)
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best Confusion Matrix: IsolationForest with {best_components} PCA Components')

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})BestIFwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})BestIFwith{best_components}PCA Components.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    return results, data2ensemble_pred

def ensemble(sil, all_data2ensemble_pred, o3test, bot):
    print("----------------ensemble----------------")
    silence = 'Silence' if sil else 'No Silence'   
    final_result = {'TP': [], 'FP': [], 'TN': [], 'FN': [], 'Accuracy': [], 'Precision': [], 'Recall': [], 'F1 Score': [], 'ConfusionMatrix': []}

    results = {'TP': 0, 'FP': 0, 'TN': 0, 'FN': 0}

    print("ALLo3test\n")#40

    if all_data2ensemble_pred and isinstance(all_data2ensemble_pred[0], list):
        for i in range(len(all_data2ensemble_pred[0])):
            final_pred = [sublist[i] for sublist in all_data2ensemble_pred]
            # print("aHHHHHHHHHHHHHHHHHHHHHHHHHHHH", final_pred)
            actual = int(o3test[i])
  
            # imaginando temos um array de 10 -> int(len(final_pred)/2) = 5
            # 0: browsing 1: anomalia
            # print("final_pred.count(1): ",final_pred.count(1))    
            # print("final_pred.count(0): ",final_pred.count(0))    
            # print("actual: ",actual)
            maioria_pred = int(len(final_pred)/2)

            # anomalia prevista e é normal
            if int(final_pred.count(0)) >= maioria_pred and actual==0:
                results['TN']+=1
            # normal previsto e é normal
            if int(final_pred.count(1)) > maioria_pred and actual==0:
                results['FP']+=1
            # anomalia prevista e ataque
            if int(final_pred.count(1)) >= maioria_pred and actual==1:
                results['TP']+=1
            # normal previsto e é ataque
            if int(final_pred.count(0)) > maioria_pred and actual==1:
                results['FN']+=1
    else:
        print("allData2Ensemble is empty or not formatted correctly.")
    tn=results['TN']
    tp=results['TP']
    fn=results['FN']
    fp=results['FP']
    accuracy, precision, recall, f1_score= calculate_metrics(tp,tn,fp,fn)
    # results = resultsConfusionMatrix(actual_array, final_pred, results)
    # print("results:\n",results)

    final_result['TP'].append(tp)
    final_result['FP'].append(fp)
    final_result['TN'].append(tn)
    final_result['FN'].append(fn)
    final_result['Accuracy'].append(accuracy)
    final_result['Precision'].append(precision)
    final_result['Recall'].append(recall)
    final_result['F1 Score'].append(f1_score)
    total = tn + fp + fn + tp
    # Normalize each element of the confusion matrix
    normalized_tn = tn / total
    normalized_fp = fp / total
    normalized_fn = fn / total
    normalized_tp = tp / total
    final_result['ConfusionMatrix'].append((normalized_tp, normalized_fn, normalized_fp, normalized_tn))

    df = pd.DataFrame(final_result)
    best_f1_score = df['F1 Score'].idxmax()
    best_result = df.loc[best_f1_score]
    printMetrics(best_result['TP'],  best_result['TN'], best_result['FP'], best_result['FN'], best_result['Accuracy'], best_result['Precision'], best_result['Recall'], best_result['F1 Score'])
    cm_2x2 = np.array(df.loc[best_f1_score, 'ConfusionMatrix']).reshape(2, 2)
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm_2x2, annot=True, cmap='Blues', fmt='.2f',xticklabels=['Human', bot], yticklabels=['Human', bot])
    plt.xlabel('Predicted')
    plt.ylabel('Real')
    plt.title(f'({silence}) Best Confusion Matrix Ensemble')
    # plt.show()

    if bot == 'Smart Bot':
        namePlot = f"ResultadosPlotSmart/({silence})Ensemble.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    elif bot == 'Sequential Bot':
        namePlot = f"ResultadosPlotSequential/({silence})Ensemble.png"
        os.makedirs(os.path.dirname(namePlot), exist_ok=True)
        plt.savefig(namePlot)
    return final_result