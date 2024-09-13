pets <- read.csv("C:/Users/Alberto/Downloads/pets.csv")
library(dplyr)
pets %>% group_by(pet) %>% summarise(av.age=mean(age, na.rm=T), av.weight=mean(weight, na.rm=T), h.grade=max(score))

pets %>% group_by(country) %>% summarise(number=n())

library(ggplot2)
ggplot(pets)+
  aes(age,weight,color=pet)+
  geom_point()+
  theme_classic()+
  ggtitle("Species") +
  xlab("Age") +
  ylab("Weight")
