# ASL_Signs_Prediction
In this project a model has been trained to predict a set of ASL signs

This project contais 4 phases:-

Phase-1 (Data Collection):
From the given set of ASL signs, each sign has been performed over multiple times and the data from different sensors has been collected.
The sensors used are Accelerometer, Gyroscope, Orientation and EMG sensors. 

Phase-2 (Data preprocessing, Feature extraction and selection):
Data Preprocessing:
The data collected from phase1 has been used to remove null values, noise data and then the resultant data has been segmented into separate
class for each sign.
Feature Extraction:
In this step, we used the following feature extraction methods Mean, FFT, Range, Standard Deviation and RMS.
Feature Selection:
From the extracted features, a feature matrix has been constructed and PCA has been used to select the features.

Phase-3 (User Dependent Analysis):
For each user(Team), the new set of features has been divided into training and test data. 60%-Training & 40%-Test-data. Then a model has 
been constructed and trained using 3 different machines like Decision Trees, SVM and Neural Networks.
For each machine, different accuracy metrics like Precision, Recall and F1 scores has been calcualted.

Phase-4 (User Independent Analysis):
In this phase, we considered data from 10 users as Training and remainig 27 users as testing. Then trained with same machines as in phase-3
and reported the same accuracy metrics. 
