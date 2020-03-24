# Cluster-Analysis-of-Spotify-Genres
I used a dataset of Spotify songs from three genres; Rock, Pop and Acoustic. After examining the Within Sum of Squares and Calinski-Harabasz index I concluded that 2 or 3 distinct clusters would be the most appropriate for this dataset. I then examined these two choices using a silhouette plot. The clustering algorithm featuring K = 3 clusters results in a 23.08% reduction to the average silhouette width. This shows it is a much worse fit to the data than K = 2 algorithm. This 

![Image of framework](https://github.com/jackapbutler/Cluster-Analysis-of-Spotify-Genres/blob/master/Elements/Silhouette_plot.png)

This decision is reinforced when we observe a parallel coordinate plot. We can see below that the purple and blue clusters are very similar, justifying that K = 2 gives a better fit to the dataset.

![Image of framework](https://github.com/jackapbutler/Cluster-Analysis-of-Spotify-Genres/blob/master/Elements/para_coords.png)
