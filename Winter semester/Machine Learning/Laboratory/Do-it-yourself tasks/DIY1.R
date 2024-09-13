# Create a random vector v of 30 integers numbers from the interval [-100,100].

x <- sample(-100:100,30)

# Check if zero has been drawn in v

which(x==0)

# how many positive and negative numbers were drawn?

length(x[x<0])

length(x[x>0])

# for the negative values od v find the minimum and maximum, and their location.

neg.x <- x[x<0]
min(neg.x)
max(neg.x)
which.min(neg.x)
which.max(neg.x)

# at position 5,10,22 generate missing values

x[c(5,10,22)]<-NA
x

# find the sum and median for the negative values of v

sum(neg.x)
median(neg.x)

# find the product of v

prod(x,na.rm = TRUE)