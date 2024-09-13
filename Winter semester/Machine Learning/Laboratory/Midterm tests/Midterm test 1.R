# change the variable weekday into a factor type, where the labels will be the names of the days of the week c("Mon", "Tue", "Wen", "Thu","Fri", "Sat", "Sun").

dataset <- read.csv("day.csv")
dataset$weekday <- as.factor(dataset$weekday)
levels(dataset$weekday) <- c("Mon","Tue","Wen","Thu","Fri","Sat","Sun")
dataset$weekday

# the variable cnt contains the number of bikes hired. Find the average value of the variable cnt for each day of the week.

library(dplyr)
dataset %>% group_by(weekday) %>% summarise(av.cnt = mean(cnt))

# draw a graph of the relationship of the variable temp to cnt, by workingday. (preferably in ggplot2) 

library(ggplot2)

ggplot(dataset)+
  aes(temp,cnt,color=workingday)+
  geom_point()+
  theme_classic()+
  ggtitle("") +
  xlab("Temp") +
  ylab("Cnt")

# Create a random vector v of 300 integers numbers from the interval [-100,100].

v <- sample(-100:100,300,replace = TRUE)

# Compute how many positive values are in the sequence. Calculate their sum.

length(v[v>0])
pos.v <- v[v>0]
sum(pos.v)