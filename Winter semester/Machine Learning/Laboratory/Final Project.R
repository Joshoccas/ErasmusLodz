# JOSÉ ALBERTO HOCES CASTRO

# EXERCISE 1

# I have chosen XGBoost as my ensemble learning model
# We are going to work on the Hotel Reservations.csv 
# dataset to predict whether it will be cancelled or not

# 1. We transform the set hr into numeric form

hr<-read.csv("Hotel Reservations.csv", stringsAsFactors = T)

# We delete the IDs

hr=hr[-1]

# Target variable must be binary (0 and 1)

hr$booking_status <- factor(hr$booking_status, levels = c("Not_Canceled", "Canceled"))
hr$booking_status <- ifelse(hr$booking_status == "Not_Canceled", 0, 1)

library(caret)
hr.dv <- dummyVars("~ .",hr[-18], fullRank = F)
hr.d = as.data.frame(predict(hr.dv, newdata=hr[-19]))
hr.d=cbind(hr.d,hr[18])
str(hr.d)
summary(hr.d)

# 2. We split the data into the training set and test set

library(caTools)
set.seed(12345)
split = sample.split(hr.d$booking_status, SplitRatio = 0.7)
hr.d.Train <- subset(hr.d, split == TRUE)
hr.d.Test <- subset(hr.d, split == FALSE)

# 3. We transform these sets into matrix form (needed for XGBoost)

library(Matrix)

mat.train <- as.matrix(hr.d.Train[,-31])
m.train <- as(mat.train,"dgCMatrix")
mat.test<- as.matrix(hr.d.Test[,-31])
m.test <- as(mat.test,"dgCMatrix")

# 4. We use the xgboost function to create our ensemble learning model

library(xgboost)
hr.xgb <- xgboost(data=m.train,label=hr.d.Train$booking_status,
                  nrounds = 500,objective="binary:logistic",
                  eval_metric = "logloss")

# 5. We use the model to predict the target variable on the test set

xgb.predict <- predict(hr.xgb, m.test)
xgb.pred.class = ifelse(xgb.predict > 0.5, 1, 0)

# 6. We evaluate our model with the confusion matrix, accuracy and 
# the ROC function

acc <- function(y.true, y.pred) { sum(y.pred==y.true)/length(y.true) }

library(ROCR)
roc.function<-function(y_pred,testY){
  pred <- prediction(as.numeric(y_pred), as.numeric(testY))
  perf.auc <- performance(pred, measure = "auc")
  auc<-round(unlist(perf.auc@y.values),2)
  perf <- performance(pred,"tpr","fpr")
  plot(perf,main=paste("ROC curve and AUC=",auc),colorize=TRUE, lwd = 3)
  abline(a = 0, b = 1, lwd = 2, lty = 2) 
}

table(xgb.pred.class,hr.d.Test$booking_status)

# FP = 668, FN = 456, RP = 2897, RN = 6861. These values are quite good

acc(xgb.pred.class,hr.d.Test$booking_status)

# acc = 0.8967102 (The accuracy is reallt high)

xgb.roc = roc.function(xgb.pred.class,hr.d.Test$booking_status)

# AUC (Area under the curve) = 0.88

# ------------------------------------------------------------------

# EXERCISE 2

# We will use the dataset "income.csv". The target variable will be
# the income (<= 50K or > 50K)

# We will need the following function later

normalize <- function(x) {
  return((x - min(x)) / (max(x) - min(x)))
}

# 1. Reading and preparing the data

inc<-read.csv("income.csv", stringsAsFactors = T)
summary(inc)
str(inc)

inc$income <- factor(inc$income, levels = c(" <=50K", " >50K"))
inc$income <- ifelse(inc$income == " <=50K", 0, 1)

# 2. We transform the set inc into numeric form using
# dummy variables

library(caret)
inc.dv <- dummyVars("~ .",inc[-12], fullRank = F)
incd = as.data.frame(predict(inc.dv, newdata=inc[-12]))
summary(incd)

inc.d<- as.data.frame(lapply(incd, normalize))
inc.d=cbind(inc.d,inc[12])
str(inc.d)

# 3. We split the data into the training set and test set

library(caTools)
set.seed(123)
split = sample.split(inc.d$income, SplitRatio = 0.7)
inc.d.Train <- subset(inc.d, split == TRUE)
inc.d.Test <- subset(inc.d, split == FALSE)

# 4. We start with our Support Vector Machine

library(e1071)

model = svm(income~., data = inc.d.Train, kernel="radial", cost=1,
            gamma = 1/ncol(inc.d.Train))

# 5. We use the model to predict the target variable on the test set

svm.pred = predict(model, inc.d.Test)

library(pROC)
gbm.roc = roc(inc.d.Test$income, svm.pred)
x=plot(gbm.roc)
x # Area under the curve is 0.8465
coords(gbm.roc, "best") # Threshold = 0.05538251
svm.pred.class = ifelse(svm.pred > 0.05538251, 1, 0)

# Finally, we calculate the confusion matrix and the accuracy

svm.table=table(svm.pred.class, inc.d.Test$income)
svm.table

# Confusion matrix: svm.pred.class    0    1
#                                 0 5526  474
#                                 1 1890 1878

acc <- function(y.true, y.pred) { sum(y.pred==y.true)/length(y.true) }
acc(svm.pred.class, inc.d.Test$income)

# Accuracy is equal to 0.7579853

# Now, we are going to generate several models, tuning different
# hyperparameters in order to determine which one has the 
# best performance

# 1. Linear kernel with different costs

set.seed(123)
linear.tune <- tune.svm(income~., data = inc.d.Train,
                        kernel = "linear",
                        cost = c(0.001, 0.01, 0.1, 1, 5, 10))
summary(linear.tune)

# Now we select the cost value which gave the best result

best.linear <- linear.tune$best.model
tune.test <- predict(best.linear, newdata = inc.d.Test)

# Finally, we evaluate model with the roc function

gbm.roc = roc(inc.d.Test$income, tune.test )
x=plot(gbm.roc)
x
linAUC <- coords(gbm.roc, "best")
prog<-coords(gbm.roc, "best")

# We also study the confusion matrix and the accuracy

tune.test.class = ifelse(tune.test > prog$threshold, 1, 0)
table(tune.test.class, inc.d.Test$income)
linACC <- acc(tune.test.class, inc.d.Test$income)

# 2. Polynomial kernel with different degrees and coefficients

set.seed(123)
poly.tune <- tune.svm(income~., data = inc.d.Train,
                      kernel = "polynomial",
                      degree = c(3, 4, 5),
                      coef0 = c(0.1, 0.5, 1, 2, 3, 4))
summary(poly.tune)

# Now we select the combination degree-coef value which gave 
# the best result

best.poly <- poly.tune$best.model
poly.test <- predict(best.poly, newdata = inc.d.Test)

# Finally, we evaluate model with the roc function

gbm.roc = roc(inc.d.Test$income, poly.test)
x=plot(gbm.roc)
x
polyAUC <- coords(gbm.roc, "best")
prog <- coords(gbm.roc, "best")

# We also study the confusion matrix and the accuracy

poly.test.class = ifelse(poly.test > prog$threshold, 1, 0)
table(poly.test.class, inc.d.Test$income)
polyACC <- acc(poly.test.class, inc.d.Test$income)

# 3. Gaussian radial basis kernel with different values of gamma

set.seed(123)
rbf.tune <- tune.svm(income~., data = inc.d.Train,
                     kernel = "radial",
                     gamma = c(0.001,0.01, 0.1, 0.5, 1, 2))
summary(rbf.tune)

# Now we select the gamma value which gave the best result

best.rbf <- rbf.tune$best.model
rbf.test <- predict(best.rbf, newdata = inc.d.Test)

# Finally, we evaluate model with the roc function

gbm.roc = roc(inc.d.Test$income, rbf.test )
x=plot(gbm.roc)
x
gaussAUC <- coords(gbm.roc, "best")
prog<-coords(gbm.roc, "best")

# We also study the confusion matrix and the accuracy

rbf.test.class = ifelse(rbf.test > prog$threshold, 1, 0)
table(rbf.test.class, inc.d.Test$income)
gaussAUC <- acc(rbf.test.class, inc.d.Test$income)

# 4. Sigmoid kernel with different gamma and coefficients

set.seed(432)
sigmoid.tune <- tune.svm(income~., data = inc.d.Train,
                         kernel = "sigmoid",
                         gamma = c(0.1, 0.5, 1, 2, 3, 4),
                         coef0 = c(0.1, 0.5, 1, 2, 3, 4))
summary(sigmoid.tune)

# Now we select the combination gamma-coef value which gave 
# the best result

best.sigmoid <- sigmoid.tune$best.model
sigmoid.test <- predict(best.sigmoid, newdata = inc.d.Test)

# Finally, we evaluate model with the roc function

gbm.roc = roc(inc.d.Test$income, sigmoid.test )
x=plot(gbm.roc)
x
sigmAUC <- coords(gbm.roc, "best")
prog<-coords(gbm.roc, "best")

# We also study the confusion matrix and the accuracy

sigmoid.test.class = ifelse(sigmoid.test > prog$threshold, 1, 0)
table(sigmoid.test.class, inc.d.Test$income)
acc(sigmoid.test.class, inc.d.Test$income)

# Finally, we compare the best-performing options of each kernel.
# We want the one with the highest AUC and accuracy values

kernels <- c("linear", "polynomial", "gaussian radial", "sigmoidal")
valuesAUC <- c(linAUC, polyAUC, gaussAUC, sigmAUC)
valuesACC <- c(linACC, polyACC, gaussACC, sigmACC)

# Comparison of accuracy:

plot(x=kernels,y=valuesACC,col="slateblue", pch=19, main="Accuracy")

# Comparison of AUC:

plot(x=kernels,y=valuesAUC,col="salmon1", pch=19, main="AUC")