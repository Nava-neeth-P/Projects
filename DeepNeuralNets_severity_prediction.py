# -*- coding: utf-8 -*-
"""
Created on Sat Sept  9 12:15:20 2020

@author: Nava
"""

# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# Importing the libraries
import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
from sklearn.compose import ColumnTransformer

# Importing the dataset
dataset = pd.read_excel('New_Diagnosis_data.xls')
#upper bound is excluded
X = dataset.iloc[:, 3:11].values
y = dataset.iloc[:, [10]].values
M = y
M[M[:,0] == 'Off'] = 20
M[M[:,0] == 'SystemState_A'] = 16
M[M[:,0] == 'SystemState_B'] = 1
M[M[:,0] == 'SystemState_C'] = 13
M[M[:,0] == 'SystemState_D'] = 4
M[M[:,0] == 'SystemState_E'] = 14
M[M[:,0] == 'SystemState_F'] = 11
M[M[:,0] == 'SystemState_G'] = 15
M[M[:,0] == 'SystemState_H'] = 6
M[M[:,0] == 'SystemState_I'] = 12
y = M
N = X
X = X.astype(str)
"""#...............Labelencoding......................#"""

#Encode Category
labelencoder_X_0 = LabelEncoder()
X[:, 0] = labelencoder_X_0.fit_transform(X[:, 0])

#Encode Cycle
labelencoder_X_1 = LabelEncoder()
X[:, 1] = labelencoder_X_1.fit_transform(X[:, 1])

#Encode curability
labelencoder_X_2 = LabelEncoder()
X[:, 2] = labelencoder_X_2.fit_transform(X[:, 2])

#Encode task_cy
labelencoder_X_3 = LabelEncoder()
X[:, 3] = labelencoder_X_3.fit_transform(X[:, 3])

#Encode cusf_lvl
labelencoder_X_4 = LabelEncoder()
X[:, 4] = labelencoder_X_4.fit_transform(X[:, 4])

#SFB time not used anymore

#Encode class
labelencoder_X_5 = LabelEncoder()
X[:, 5] = labelencoder_X_5.fit_transform(X[:, 5])

#Encode SWGroup
labelencoder_X_6 = LabelEncoder()
X[:, 6] = labelencoder_X_6.fit_transform(X[:, 6])
"""................................................"""

""".............As passing y to ANN does not work.................."""
#Encoding the output
labelencoder_y_0 = LabelEncoder()
X[:, 7] = labelencoder_y_0.fit_transform(X[:, 7])

#Onehotencoding the Dependant variable y
columnTransformer = ColumnTransformer([('encoder', OneHotEncoder(), [7])], remainder='passthrough')
X = np.array(columnTransformer.fit_transform(X), dtype = np.str)
#y = X[:, 0:10]   #Avoiding dummy variable trap by not taking one column
X = X[:, 10:17]


#..............OnehotEncoding...................#
#Category
ct0 = ColumnTransformer([('encoder', OneHotEncoder(), [0])], remainder='passthrough')
X = np.array(ct0.fit_transform(X), dtype = np.str)

#Cycle
ct1 = ColumnTransformer([('encoder', OneHotEncoder(), [7])], remainder='passthrough')
X = np.array(ct1.fit_transform(X), dtype = np.str)

#Curability: one hot encoding not needed as only 2 values are present (yes/no)

#task_cy : considered a string due to Init being present in data
ct2 = ColumnTransformer([('encoder', OneHotEncoder(), [11])], remainder='passthrough')
X = np.array(ct2.fit_transform(X), dtype = np.str)

#cusf_lvl
ct3 = ColumnTransformer([('encoder', OneHotEncoder(), [21])], remainder='passthrough')
X = np.array(ct3.fit_transform(X), dtype = np.str)

#FW class: one hot encoding not needed as only 2 values are present

#SWGroup
ct4 = ColumnTransformer([('encoder', OneHotEncoder(), [59])], remainder='passthrough')
X = np.array(ct4.fit_transform(X), dtype = np.str)

#Saving the encoder objects: classes_ can only be used for LabelEncoder
np.save('LE_0.npy', labelencoder_X_0.classes_)
np.save('LE_1.npy', labelencoder_X_1.classes_)
np.save('LE_2.npy', labelencoder_X_2.classes_)
np.save('LE_3.npy', labelencoder_X_3.classes_)
np.save('LE_4.npy', labelencoder_X_4.classes_)
np.save('LE_5.npy', labelencoder_X_5.classes_)
np.save('LE_6.npy', labelencoder_X_6.classes_)
import pickle
pickle.dump(ct0, open('OHE_0.pickle', 'wb'))
pickle.dump(ct1, open('OHE_1.pickle', 'wb'))
pickle.dump(ct2, open('OHE_2.pickle', 'wb'))
pickle.dump(ct3, open('OHE_3.pickle', 'wb'))
pickle.dump(ct4, open('OHE_4.pickle', 'wb'))
X = X[:, 1:]


# Split to Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)


# Feature Scaling
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import MinMaxScaler
sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)
sc1 = MinMaxScaler()
#y_train[:,0] = y_train[:,0]/20
#y_train[y_train[:,0] == 1] = 0.99
y_train = sc1.fit_transform(y_train)
#y_test = sc1.transform(y_test)
pickle.dump(sc, open('StandardScaler.pickle', 'wb'))



# Importing the Keras lib and packages
import keras
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Dropout



#.............The model..............#
# Initialising the ANN
classifier = Sequential()

# Input and first hidden layer: input_dim = 128 the columns in X
classifier.add(Dense(units = 12, kernel_initializer = 'uniform', activation = 'relu', input_dim = 128))
classifier.add(Dropout(p = 0.1))

# Second hidden layer
classifier.add(Dense(units = 12, kernel_initializer = 'uniform', activation = 'relu'))
classifier.add(Dropout(p = 0.1))

# Extra Hidden Layer
classifier.add(Dense(units = 12, kernel_initializer = 'uniform', activation = 'relu'))

# Output layer
classifier.add(Dense(units = 1, kernel_initializer = 'uniform', activation = 'sigmoid'))

# Compiling the ANN
classifier.compile(optimizer = 'adam', loss = 'mse', metrics = ['accuracy'])

# Fitting to Training set
classifier.fit(X_train, y_train, batch_size = 25, epochs = 100)


# Part 3 - Predictions

# Predicting the Test set results
y_pred = classifier.predict(X_test)
y_pred = y_pred * 20
M = []
def Get_deg_values(M, num_column):
    for i in range(0,num_column):
        if(0<= M[i,0] <=1):
            M[i,0] = 1
        if(1< M[i,0] <=2):
            M[i,0] = 1
        if(2< M[i,0] <=4):
            M[i,0] = 4
        if(4< M[i,0] <=6):
            M[i,0] = 6
        if(6< M[i,0] <=11):
            M[i,0] = 11
        if(11< M[i,0] <=12):
            M[i,0] = 12
        if(12< M[i,0] <=13):
            M[i,0] = 13
        if(13< M[i,0] <=14):
            M[i,0] = 14
        if(14< M[i,0] <=15):
            M[i,0] = 15
        if(15< M[i,0] <=16):
            M[i,0] = 16
        if(16< M[i,0] <=20):
            M[i,0] = 20
    return M

y_pred = Get_deg_values(y_pred, 199)  # num_column = 340, the number of rows in y_pred
#Creating the confusion matrix
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test.astype(float), y_pred)


"""
# Tuning the ANN
from keras.wrappers.scikit_learn import KerasClassifier
from sklearn.model_selection import GridSearchCV
from keras.models import Sequential
from keras.layers import Dense
def build_classifier(optimizer):
    classifier = Sequential()
    classifier.add(Dense(units = 12, kernel_initializer = 'uniform', activation = 'relu', input_dim = 24))
    classifier.add(Dropout(p = 0.1))
    classifier.add(Dense(units = 12, kernel_initializer = 'uniform', activation = 'relu'))
    classifier.add(Dropout(p = 0.1))
    classifier.add(Dense(units = 12, kernel_initializer = 'uniform', activation = 'relu'))
    classifier.add(Dense(units = 1, kernel_initializer = 'uniform', activation = 'sigmoid'))
    classifier.compile(optimizer = optimizer, loss = 'mse', metrics = ['accuracy'])
    classifier.fit(X_train, y_train, batch_size = 25, epochs = 500) 
    return classifier


classifier = KerasClassifier(build_fn = build_classifier)
parameters = {'batch_size': [20, 25, 32, 40],
              'epochs': [15, 50, 100, 500],
              'optimizer': ['adam', 'rmsprop']}
grid_search = GridSearchCV(estimator = classifier,
                           param_grid = parameters,
                           scoring = 'accuracy',
                           cv = 10)
grid_search = grid_search.fit(X_train, y_train)
best_parameters = grid_search.best_params_
best_accuracy = grid_search.best_score_
"""

# Preparing input to fit correctly into ANN for making new predictions
X_new = np.array([['Ext_fault', 'Igcyc', 'YES', 'Proc_time', 'sas', 'Clear state', 'Scl']])


#Label encoding the new dataset with the same objects used to enocde the training data
X_new[:, 0] = labelencoder_X_0.transform(X_new[:, 0])
X_new[:, 1] = labelencoder_X_1.transform(X_new[:, 1])
X_new[:, 2] = labelencoder_X_2.transform(X_new[:, 2])
X_new[:, 3] = labelencoder_X_3.transform(X_new[:, 3])
X_new[:, 4] = labelencoder_X_4.transform(X_new[:, 4])
X_new[:, 5] = labelencoder_X_5.transform(X_new[:, 5])
X_new[:, 6] = labelencoder_X_6.transform(X_new[:, 6])
#Onehotencoding using the same objects as used earlier on X
X_new = np.array(ct0.transform(X_new), dtype = np.str)
X_new = np.array(ct1.transform(X_new), dtype = np.str)
X_new = np.array(ct2.transform(X_new), dtype = np.str)
X_new = np.array(ct3.transform(X_new), dtype = np.str)
X_new = np.array(ct4.transform(X_new), dtype = np.str)
X_new = X_new[:, 1:]

#Make a single new prediction
new_prediction = classifier.predict(sc.transform(X_new))
new_prediction = np.round(new_prediction, 2)
new_prediction = new_prediction * 20
new_prediction = Get_deg_values(new_prediction, 1)
Predicted_Degradation = []
if(new_prediction == 20):
    Predicted_Degradation = ['Off']
if(new_prediction == 16):
    Predicted_Degradation = ['SystemState_A']
if(new_prediction == 1):
    Predicted_Degradation = ['SystemState_B']
if(new_prediction == 13):
    Predicted_Degradation = ['SystemState_C']
if(new_prediction == 4):
    Predicted_Degradation = ['SystemState_D']
if(new_prediction == 14):
    Predicted_Degradation = ['SystemState_E']
if(new_prediction == 11):
    Predicted_Degradation = ['SystemState_F']
if(new_prediction == 15):
    Predicted_Degradation = ['SystemState_G']
if(new_prediction == 6):
    Predicted_Degradation = ['SystemState_H']
if(new_prediction == 12):
    Predicted_Degradation = ['SystemState_I']



#To save the trained model
from keras.models import save_model
save_model(classifier,'trained_ann_prediction.h5')