import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

import numpy as np
from numpy.linalg import inv

dataset=pd.read_csv('forestfires.csv')
dataset.head()


fire_area=dataset.iloc[:,12:]

all_features=dataset.iloc[:,:12]
features_1=dataset.iloc[:,4:11]


#Linear Regression
features_1.head()

training_features_1=features_1.iloc[:400,:]
training_fire_area=fire_area.iloc[:400]

test_features_1=features_1.iloc[400:,:]
testing_fire_area=fire_area[400:]


# Linear Regression implementation using Algebra

#Include a column of 1's with the feature matrix
ones = np.ones([training_features_1.shape[0],1])
tf_algebra=np.concatenate((ones,training_features_1),axis=1)

coeffs = inv(tf_algebra.transpose().dot(tf_algebra)).dot(tf_algebra.transpose()).dot(training_fire_area)
algebra_intercept=coeffs[0]
algebra_coefficients_features=coeffs[1:]

print("Intercept from Matrix algebra : ",algebra_intercept)
print("Coefficients for features from Matrix algebra : ",algebra_coefficients_features)




#****************************************************************************
#Linear Regression using Scikit learn

regression=LinearRegression()
regression.fit(training_features_1,training_fire_area)
print("Coefficients from linear regression : ",regression.coef_)

#Evaluating the model using Mean Squared Error
from sklearn import metrics
pred=regression.predict(test_features_1)
MSE_regression_1=metrics.mean_squared_error(testing_fire_area, pred)
print('MSE from this model:',MSE_regression_1 )


#*******************************Model 2 *****************************************
regression_2=LinearRegression()
features_2=features_1.iloc[:,:4]
training_features_2=features_2[:400]
test_features_2=features_2[400:]

regression_2.fit(training_features_2,training_fire_area)
print("Coefficients from linear regression : ",regression_2.coef_)
print("Intercept from linear regression :",regression_2.intercept_)


pred_2=regression_2.predict(test_features_2)
MSE_regression_2=metrics.mean_squared_error(testing_fire_area, pred_2)
print('MSE from second model:',MSE_regression_2 )



#************************Model 3************************************************
# REGRESSION WITH Last 6 features

regression_3=LinearRegression()
features_3=features_1.iloc[:,1:]
training_features_3=features_3[:400]
test_features_3=features_3[400:]

regression_3.fit(training_features_3,training_fire_area)
print("Coefficients from linear regression : ",regression_3.coef_)
print("Intercept from linear regression :",regression_3.intercept_)


pred_3=regression_3.predict(test_features_3)
MSE_regression_3=metrics.mean_squared_error(testing_fire_area, pred_3)
print('MSE from the third model:',MSE_regression_3 )


#Improving the model with the suggestion - Removing the 0 eleemnts for area

dataset_2=dataset.copy()
dataset_2=dataset.loc[dataset_2['area']!=0]
dataset_2 = dataset_2.reset_index(drop=True)
new_features=dataset_2.iloc[:,4:11]

new_features.head()
new_fire_area=dataset_2.iloc[:,12:]
new_fire_area.head()

new_regression=LinearRegression()


new_training_features=new_features[:210]
new_test_features=new_features[210:]

new_training_fire_area=new_fire_area[:210]
new_test_fire_area=new_fire_area[210:]



new_regression.fit(new_training_features,new_training_fire_area)
print("Coefficients from linear regression : ",new_regression.coef_)
print("Intercept from linear regression :",new_regression.intercept_)


new_pred=new_regression.predict(new_test_features)
MSE_regression_new=metrics.mean_squared_error(new_test_fire_area, new_pred)
print('MSE from the new model:',MSE_regression_new )



#Plotting the MSE from first 3 models before improvement


models_3only=['regression1','regression2','regression3']
mse_3only=[MSE_regression_1,MSE_regression_2,MSE_regression_3]


table_3models=pd.DataFrame({'Regression':models_3only,
                   'MSE':mse_3only
                   })
				   

plot=table_3models.plot.bar(x='Regression',y='MSE',legend=False)
plot.set_xlabel("Regression model")
plot.set_ylabel("Mean Squared Error")
plot.set_ylim(5000,5800)
plot.set_title(" First 3 Regression Models and the corresponding MSE's")
plt.show()


#*********************************************************************************

#PLOTTING THE MSE's from all 4 models

models=['regression1','regression2','regression3','regression_new']
mse=[MSE_regression_1,MSE_regression_2,MSE_regression_3,MSE_regression_new]

plot_table=pd.DataFrame({'Regression':models,
                   'MSE':mse
                   })
				   

plot=plot_table.plot.bar(x='Regression',y='MSE',legend=False)
plot.set_xlabel("Regression model")
plot.set_ylabel("Mean Squared Error")
plot.set_ylim(1500,5900)
plot.set_title(" All Regression Models and the corresponding MSE's")
plt.show()








