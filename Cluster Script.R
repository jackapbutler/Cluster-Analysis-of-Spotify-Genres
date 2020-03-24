# Load the rda file and necessary libaries
load(file = "data_spotify_songs.rda")

library(easypackages)
my_packages <- c("dplyr", "MASS", "cluster", "rgl", "corrplot", "e1071")
libraries(my_packages)

# Initial view of Data
summary(spotify)

# View Duplicate Song Names 
filter(spotify, spotify$song_name =='Sex on Fire')
filter(spotify, spotify$song_name =='Use Somebody')

# Remove the 'pop versions' duplicates of these two songs (subjective choice) 
spotify <- spotify[!(spotify$song_name=="Use Somebody" & spotify$genre=='pop'),]
spotify <- spotify[!(spotify$song_name=="Sex on Fire" & spotify$genre=='pop'),]

# Create numerical variables array for scatterplot
numerical_vars <- scale(spotify[-c(1,2,3)])
num_cor_mat <- round(cor(numerical_vars), 2)

# Plotting numerical variable correlations
pval_matrix <- cor.mtest(num_cor_mat)$p
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
par(mfrow = c(1,1))
corrplot(num_cor_mat, method="color", col=col(200),  
         type="upper", order="hclust",
         # Add coefficient of correlation
         addCoef.col = "black", 
         #Text label color and rotation
         tl.col="black", tl.srt=45, 
         # Combine with significance level 0.1
         p.mat = pval_matrix, sig.level = 0.1, insig = "blank", 
         # hide correlation coefficient on the principal diagonal
         diag=FALSE)

# Choosing correct K by plotting WSS against K, low WSS is good
train_data <- numerical_vars
wss <- bss <- ch <- (nrow(train_data)-1)*sum(apply(train_data,2,var))

for (i in 2:12) 
  wss[i] <- sum(kmeans(train_data, centers=i)$withinss)

plot(wss, type="b",
     xlab="Number of Clusters",
     ylab="Within Sum of Squares")

# Choosing correct K for clusters by plotting CH against K, large CH is good
# Elbow plot, steep decline indicates arrived at correct number
N <- nrow(train_data) 
ch[1] <- 0

for (i in 2:12){ 
  bss[i] <- sum(kmeans(train_data, centers=i)$betweenss)
  ch[i] <- (bss[i]/(i-1)) / (wss/(N-i))}

plot(1:12, ch[1:12], type="b", 
     xlab="Number of Clusters",
     ylab="Calinski-Harabasz index")

# K equal to 2 or 3 both seem plausible
fit2 <- kmeans(train_data, centers = 2, nstart = 1000) 
fit3 <- kmeans(train_data, centers = 3, nstart = 1000)
col <- c("darkorange2", "deepskyblue3", "magenta3")

# Construct a distance matrix using squared Euclidean distance 
d <- dist(train_data, method = "euclidean")^2
sil2 <- silhouette(fit2$cluster, d) 
sil3 <- silhouette(fit3$cluster, d)

# Produce the two silhouette plots 
# We can see K = 2 is better
par(mfrow = c(1,2))
col <- c("darkorange2", "deepskyblue3", "magenta3") 
plot(sil2, col = adjustcolor(col[1:2], 0.3), main = "Spotify data - K = 2", border=NA) 
plot(sil3, col = adjustcolor(col, 0.3), main = "Spotify - K = 3", border=NA)

# Cross tabulation between the two partitions, Rand Index
# Choose K = 3 as higher rand index
genre <- spotify$genre
tab2 <- table(fit2$cluster, genre) 
tab3 <- table(fit3$cluster, genre)

classAgreement(tab2)$rand
classAgreement(tab2)$crand
classAgreement(tab3)$rand
classAgreement(tab3)$crand

# Show ARI as a Table
ARI_table <- matrix(
  c(round(classAgreement(tab2)$crand,4), round(classAgreement(tab3)$crand,4)),
    ncol=1,byrow=TRUE)
rownames(ARI_table) <- c("K = 2","K = 3")
colnames(ARI_table) <- c("Adjusted Rand Index")

# Parallel coordinates graph, k = 3, review different classes
colourvector <- c("magenta3", "deepskyblue2", "darkorange3") 
colour0 <- colourvector[fit3$cluster]
K <- length(colourvector)
par(mfrow = c(K, 1))

for (k in 1:K) { 
  cols <- colour0
  cols[cols != colourvector[k]] <- adjustcolor("gray", 0) 
  parcoord(numerical_vars, col = cols, var.label = TRUE)}

# PCA Analysis helps with cluster Visualisation
# We observe first three components capture majority of variance
par(mfrow = c(1, 1))
pcs <- princomp(numerical_vars)
plot(pcs, main = "PCA Analysis of Variables")
summary(pcs)
loadings(pcs)

# 3D plot
pc <- prcomp(numerical_vars)
comp <- data.frame(pc$x[,1:3])
Comp_1 <- comp$PC1
Comp_2 <- comp$PC2
Comp_3 <- comp$PC3

plot3d(Comp_1, Comp_2, Comp_3, 
       col = fit2$cluster, type = 'p')

