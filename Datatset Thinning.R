# Install and load the spThin package
if (!require('spThin')) {
  install.packages('spThin')
}
library(spThin)

# Load your elephant occurrence data
# Assuming your data is in a CSV file named 'elephant_occurrences.csv'
elephant_data <- read.csv("D:\\CLARK ASSIGNMENTS\\1st Sem\\Advanced Raster GIS\\FInal project\\loation.csv")

# Perform spatial thinning
thinned_data <- thin(loc.data = elephant_data,
                     lat.col = 'latitude',
                     long.col = 'longitude',
                     spec.col = 'species',
                     thin.par = 1,  # 1 km thinning distance
                     reps = 100,
                     write.files = FALSE,
                     locs.thinned.list.return = TRUE)
thin()

# Get the thinned dataset with the maximum number of occurrences
max_thinned_data <- thinned_data[[which.max(sapply(thinned_data, nrow))]]

# Print the number of occurrences before and after thinning
cat("Original number of occurrences:", nrow(elephant_data), "\n")
cat("Number of occurrences after thinning:", nrow(max_thinned_data), "\n")

# Save the thinned data to a new CSV file
write.csv(max_thinned_data, 'thinned_elephant_occurrences.csv', row.names = FALSE)

getwd()