# JOSE ALBERTO HOCES CASTRO

# For a set of bank_data.csv, build a decision tree model. 
# Evaluate this model.

# First, we read the data and delete the first column (the IDs)
dataset = read.csv("bank_data.csv")
dataset = dataset[-1]

# In my case, I am going to build a decision tree model where
# the target variable is the marital and the predictor variables
# are all the other ones

dataset$marital=as.factor(dataset$marital)

# We divide the full set into a training set and a test set.
# We place 70% of the observations in the training set and 30%
# of all observations in the test set.

library(caTools)
set.seed(123)
split = sample.split(dataset$marital, SplitRatio = 0.7)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Now, we use the rpart algorithm to build our decision tree model.

library(rpart)
model= rpart(formula = marital ~ ., data = training_set)

# And now, we visualize the tree

rpart.plot(model)

# Let's make predictions about our test_set

y_pred = predict(model, newdata = test_set, type = 'class')

# And finally, we evaluate our model using a confusion matrix
# and also calculating the accuracy

table(test_set$marital, y_pred)

acc<-sum(test_set$marital==y_pred)/length(y_pred)
acc

# Our model is not very good since it doesn't predict any 
# divorced person as divorced and the accuracy is 0.67.