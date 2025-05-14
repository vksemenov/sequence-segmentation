import numpy as np
import pandas as pd
import tensorflow as tf

tf.__version__



data = pd.read_excel('data_val.txt')
X = data.iloc[:, :-1].values
y = data.iloc[:, -1].values


from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 0)



ann = tf.keras.models.Sequential()



ann.add(tf.keras.layers.Dense(units=8, activation='relu'))



ann.add(tf.keras.layers.Dense(units=8, activation='relu'))



ann.add(tf.keras.layers.Dense(units=1))



ann.compile(optimizer = 'adam', loss = 'mean_squared_error')



ann.fit(X_train, y_train, batch_size = 32, epochs = 100)



y_pred = ann.predict(X_test)
np.set_printoptions(precision=2)
print(np.concatenate((y_pred.reshape(len(y_pred),1), y_test.reshape(len(y_test),1)),1))

from sklearn.metrics import r2_score

r2 = r2_score(y_test, y_pred)
print("R^2 Score:", r2)