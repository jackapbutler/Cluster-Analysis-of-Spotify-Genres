# Cluster-Analysis-of-Spotify-Genres
I used a dataset of Spotify songs from three genres; Rock, Pop and Acoustic. After examining the Within Sum of Squares and Calinski-Harabasz index I concluded that 2 or 3 distinct clusters would be the most appropriate for this dataset. I then examined these two choices using a silhouette plot. The clustering algorithm featuring K = 3 clusters results in a 23.08% reduction to the average silhouette width. This shows it is a much worse fit to the data than K = 2 algorithm.  

![Image of framework](https://github.com/jackapbutler/Cluster-Analysis-of-Spotify-Genres/blob/master/Elements/Silhouette_plot.png)

This decision is reinforced when we observe a parallel coordinate plot. We can see below that the purple and blue clusters are very similar, justifying that K = 2 gives a better fit to the dataset.

![Image of framework](https://github.com/jackapbutler/Cluster-Analysis-of-Spotify-Genres/blob/master/Elements/para_coords.png)

After determining that K = 2 results in an overall better fit to the data I decided to visualise the clusters. Before this possible we need to reduce the number of dimensions. Using principal component analysis, we can analyse the variables and determine which are contributing significantly to the variance. I found that the first three components contributed to the large majority of the variance. Therefore I could plot the clusters in 3-D as seen below.

![Image of framework](https://github.com/jackapbutler/Cluster-Analysis-of-Spotify-Genres/blob/master/Elements/3D_picture.png)
