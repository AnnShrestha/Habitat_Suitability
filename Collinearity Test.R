install.packages("usdm")


# Load required libraries
library(terra)
library(usdm)
library(dplyr)

# Step 1: Load your thinned occurrence data
thinned_occurrences <- read.csv("C:\\Users\\shres\\OneDrive\\Desktop\\ASDFG\\without bias\\thinned_elephant_occurrences.csv")

# Step 2: Load environmental variables
# Bioclimatic variables
bio1 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio1.tif")
bio2 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio2.tif")
bio3 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio3.tif")
bio4 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio4.tif")
bio5 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio5.tif")
bio6 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio6.tif")
bio7 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio7.tif")
bio8 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio8.tif")
bio9 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio9.tif")
bio10 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio10.tif")
bio11 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio11.tif")
bio12 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio12.tif")
bio13 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio13.tif")
bio14 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio14.tif")
bio15 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio15.tif")
bio16 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio16.tif")
bio17 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio17.tif")
bio18 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio18.tif")
bio19 <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Bio19.tif")

# Additional environmental variables
road_distance <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Road_dist.tif")
river_distance <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\River_dist.tif")
settlement_distance <-rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\Settlement_dist.tif")
elevation <- rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\elevation.tif")
slope <-rast("C:\\Users\\shres\\OneDrive\\Desktop\\Rasterfiles\\fiNAL_TRY\\slope.tif")

# Combine all rasters into a single stack
env_stack <- c(bio1, bio2, bio3, bio4, bio5, bio6, bio7, bio8, bio9, bio10, bio11, bio12, bio13, bio14, bio15, bio16, bio17, bio18, bio19, settlement_distance, river_distance, road_distance)

# Step 3: Extract environmental values for occurrence points
env_values <- terra::extract(env_stack, thinned_occurrences[, c("longitude", "latitude")])

# Combine occurrence data with extracted environmental values
env_data <- cbind(thinned_occurrences, env_values)

# Remove any rows with NA values
env_data <- na.omit(env_data)

# Step 4: Perform VIF analysis
# Select all environmental variables for VIF analysis
env_vars <- env_data %>% select(-species, -longitude, -latitude)

# Perform initial VIF analysis
vif_results <- vif(env_vars)
print("Initial VIF results:")
print(vif_results)

# Systematically remove variables with VIF > 5
vif_step <- vifstep(env_vars, th = 5)
print("VIF step results:")
print(vif_step)

# Get names of variables to keep (VIF <= 5)
vars_to_keep <- vif_step@results$Variables

# Create a new dataframe with only non-collinear variables
non_collinear_data <- env_data %>% select(species, longitude, latitude, all_of(vars_to_keep))

# Print the retained variables
print(paste("Retained variables:", paste(vars_to_keep, collapse = ", ")))

# Save the final non-collinear dataset
write.csv(non_collinear_data, "non_collinear_elephant_data.csv", row.names = FALSE)

cat("Collinearity analysis complete. Non-collinear data saved to 'non_collinear_elephant_data.csv'\n")
getwd()