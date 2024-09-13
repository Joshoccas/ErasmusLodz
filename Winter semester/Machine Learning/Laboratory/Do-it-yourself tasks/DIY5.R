# For the Country-data.csv dataset
# 1. determine the number of clusters in the set

df <- read.csv("Country-data.csv")


df.scaled <- scale(df[-1])

row.names(df.scaled)<-df$country

NbClust(df.scaled, distance="euclidean", min.nc=2, max.nc=10,
        method="kmeans", index="all")

# The best number of clusters is 3

# 2. apply k-means

kmeanscluster <- kmeans(df.scaled, centers = 3, nstart = 25)

kmeanscluster$cluster
kmeanscluster$centers
kmeanscluster$size
kmeanscluster$withinss

country2<-cbind(df,kmeanscluster$cluster)
aggregate(country2, by=list(cluster = kmeanscluster$cluster), mean)

# 3. apply hierarchical methods

# Complete method

m.dist <- dist(df[-1])
tree.country<-hclust(m.dist,method="complete")
fviz_dend(tree.country, cex = 0.5 , main = "Country dataset tree - complete")
fviz_dend(tree.country, k=3, cex = 0.5 , main = "Country dataset tree - complete")

# And now we check how good this clustering is

c.h.eclust<-eclust(df[-1], "hclust", k = 3, stand = TRUE, hc_method="complete")
fviz_silhouette(c.h.eclust)



# There are some items with negative silhouette, this indicates that they shouldn't
# belong to the cluster assigned by this method

# Single method

tree.country2<-hclust(m.dist,method="single")
fviz_dend(tree.country, cex = 0.5 , main = "Country dataset tree - complete")
fviz_dend(tree.country, k=3, cex = 0.5 , main = "Country dataset tree - complete")

# And now we check how good this clustering is

c.h.eclust2<-eclust(df[-1], "hclust", k = 3, stand = TRUE, hc_method="single")
fviz_silhouette(c.h.eclust2)

# In this case, the clustering is better than the previous one because there are less
# items with negative silhouette


# 4. print model's clusters

# First way (using cluster package)

clusplot(df.scaled, kmeanscluster$cluster, color=TRUE, shade=TRUE,
         labels=2, lines=0)

# Second way (using factoextra package)

fviz_cluster(kmeanscluster, data = df.scaled,geom = c("point", "text"),repel = TRUE, 
             ellipse.type = "confidence", ellipse.level = 0.95, main = "Clusters in Country")

# 5. print the silhouette plot for a given clustering

# first way to plot silhouette of the clustering made by kmeans

kms = silhouette(kmeanscluster$cluster,dist(df.scaled))
summary(kms)
plot(kms)

# second way to plot silhouette of the clustering made by kmeans
# we have to re-do kmeans with the function eclust...

c.eclust<- eclust(df[-1], "kmeans", k = 3, stand = TRUE, nstart = 25, graph = FALSE)
fviz_silhouette(c.eclust)


# 6. describe the resulting clustersget
'''
From what we saw in exercise 2,  the statistics show that the cluster 1 is the one
with developed wealthy and healthy countries, the cluster 2 is the one with countries
with some socioeconomic disadvantages and the third cluster is the one with the poorest
countries which have high mortality, short life expectancy, etc.