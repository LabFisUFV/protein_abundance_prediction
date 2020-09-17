import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
from tpot import TPOTRegressor

data = pd.read_csv("./ALL_trainingdata.csv", sep='\t')

col = []
for column in data.columns:
    col.append(column)

target_col = col[2]
features = col[3:len(col)]

X = data[features].values
y = data[target_col].values
y = np.log1p(y)
y = np.reshape(y, (-1,1))

X_train, X_valid, y_train, y_valid = train_test_split(X, y, test_size=0.25)

automl = TPOTRegressor(generations = 1000,
                       population_size = 250,
                       scoring = 'neg_mean_squared_error',
                       cv = 10,
                       n_jobs = 63,
                       random_state = 9,
                       verbosity = 2,
                       warm_start = False)

automl.fit(X_train, y_train.ravel())
automl.score(X_valid, y_valid.ravel())
automl.export('./TPOT_exported_pipeline.py')
