age <- c(25,31,23,52,76,49,26)
height <- c(177,163,190,179,163,183,164)
weight <- c(57,69,83,75,70,83,53)
gender <- c('F','F','M','M','F','M','F')

data.frame <- cbind(age,height,weight,gender)
data.frame

names <- c('Tom','Ted','Kate','Sue','Matt','Maria','Henry')
.rowNamesDF(data.frame, make.names=FALSE) <- names
data.frame

data.frame$gender[data.frame$gender == 'F']<-'O'
data.frame$gender[data.frame$gender == 'M']<-'F'
data.frame$gender[data.frame$gender == 'O']<-'M'
data.frame

pets<-read.csv("pets.csv")
specie <- pets$pet
specie
fspecie<-factor(specie)
fspecie

pets$pet[pets$pet == 'dog']<-'thistle2'
pets$pet[pets$pet == 'cat']<-'purple'
pets$pet[pets$pet == 'ferret']<-'lightblue'

plot(pets$age,pets$weight,
     xlab = "Age",
     ylab = "Weight", main = "Pets",
     pch = 16, col = pets$pet)
