# JOSE ALBERTO HOCES CASTRO

# 1. Build and evaluate a random forest model using the Heart.csv dataset 
# (AHD - target var.). Apply cross-validation to this model.

dataset = read.csv("Heart.csv")
dataset = dataset[-1]
dataset.v2 <- na.omit(dataset)
dataset.v2$AHD=as.factor(dataset.v2$AHD)

library(caTools)
set.seed(123)

# We divide the full set into a training set and a test set. 
# We place 70% of the observations in the training set and 30% 
# of all observations in the test set.

split = sample.split(dataset.v2$AHD, SplitRatio = 0.7)
train = subset(dataset.v2, split == TRUE)
test = subset(dataset.v2, split == FALSE)

prop.table(table(dataset.v2$AHD))
prop.table(table(train$AHD))
prop.table(table(test$AHD))

library(randomForest)

rf.heart = randomForest(AHD~., data=train)
plot(rf.heart)

# Predictions and evaluation of the model

rf.heart.pred <- predict(rf.heart, newdata= test)
table(rf.heart.pred, test$AHD)
library(caret)
confusionMatrix(rf.heart.pred, test$AHD)

# After building our random forest, we define two functions that will
# help us determine how good the model is

acc<-function(y1,y2){
  sum(y1==y2)/length(y1)
}

library(ROCR)

roc.function<-function(y_pred,testY){
  pred <- prediction(as.numeric(y_pred), as.numeric(testY))
  perf.auc <- performance(pred, measure = "auc")
  auc<-round(unlist(perf.auc@y.values),2)
  perf <- performance(pred,"tpr","fpr")
  plot(perf,main=paste("ROC curve and AUC=",auc),colorize=TRUE, lwd = 3)
  abline(a = 0, b = 1, lwd = 2, lty = 2) 
}

acc(rf.heart.pred,test$AHD)
roc.function(rf.heart.pred,test$AHD)

# The results are accuracy = 0.8426966 and 
# ROC curve and AUC = 0.84

# Finally, let's apply cross validation to this model

library(caret)
control = trainControl(method="cv", number=10)
model.caret = train(AHD~ .,data=train, method="rf", trControl=control)
model.caret
model.caret$resample$Accuracy

cv.y_pred = predict(model.caret, newdata = test, type = 'raw')
table(cv.y_pred,test$AHD)
acc(cv.y_pred,test$AHD)
roc.function(cv.y_pred, test$AHD)

# The results are accuracy = 0.8202247 and 
# ROC curve and AUC = 0.82

# 2. Build and evaluate a tree model on the same set.

library(rpart)
model= rpart(formula = AHD ~ ., data = train)

library(rattle)
fancyRpartPlot(model)

# Predictions and evaluation of the model

y_pred = predict(model, newdata = test, type = 'class')
table(test$AHD, y_pred)
confusionMatrix(y_pred, test$AHD)


acc(y_pred, test$AHD)
roc.function(y_pred,test$AHD)

# The results are accuracy = 0.7752809 and 
# ROC curve and AUC = 0.77

# 3. Compare these two models.

# The RF has better accuracy and ROC function than
# the tree model