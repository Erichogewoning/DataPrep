
library(stringr)
library(dplyr)
library(reshape2)

###### Step 1 Merge the training and test data ########

## load test data sets
df_test_subject <- read.table("UCI HAR Dataset\\test\\subject_test.txt", header=FALSE)
df_test_x <- read.table("UCI HAR Dataset\\test\\X_test.txt", header=FALSE)
df_test_y <- read.table("UCI HAR Dataset\\test\\y_test.txt", header=FALSE)

## load train data sets
df_train_subject <- read.table("UCI HAR Dataset\\train\\subject_train.txt", header=FALSE)
df_train_x <- read.table("UCI HAR Dataset\\train\\X_train.txt", header=FALSE)
df_train_y <- read.table("UCI HAR Dataset\\train\\y_train.txt", header=FALSE)

## merge all test data into one test data frame.
df_test <- cbind(df_test_subject, df_test_y, df_test_x)
## merge all train data into one train data frame
df_train <- cbind(df_train_subject, df_train_y, df_train_x)

## merge test and training data frame into one
df_test_train_merged <- rbind(df_test, df_train)
## for readability, rename the first 2 columns
## the rest of the columns (belonging to the feature vector) will be renamed later.
colnames(df_test_train_merged)[1:2] <- c("subject_id", "activity_code")


###### Step 2 Extract only measurements of the mean and std dev ########

## load the features file. This file contains the descriptions for all measurements
## Using this file, we can find which measurements are 'mean' and 'std dev'.
df_features <- read.table("UCI HAR Dataset\\features.txt", header=FALSE)
## add a column that specifies whether the names contains either mean() or std() using a regular expression
## the $select column will have a value > 0 if the text 'mean()' or 'std()' was found.
df_features$select <- unlist(gregexpr("mean()|std()", df_features[,2]))
## get all columnsnumbers that contain either main() or std()
## since we added the subject_nbr and y value in front of the x feature values, 
## we need to shift our column selection by 2 positions
features_column_nbrs <- df_features[df_features$select > 0, 1] +2

## keep only the first 2 columns (activity_code and subject_id) and the columns
## in which the mean() or std() was found
df_merged_selection <- df_test_train_merged[, c(1,2,features_column_nbrs)]

###### Step 3 Uses descriptive activity names to name the activities in the data set ########

## We will replace the integer values for activities in the second column with descriptions
## these are stored in the activity_labels file.
df_activity_label <- read.table("UCI HAR Dataset\\activity_labels.txt", header=FALSE)
## set columns names for this data frame, for ease of merging later.
colnames(df_activity_label) <- c("activity_code", "activity_description")

## add the activity_descriptions to the data frame, joining on the activity_code.
mergeddata = merge(df_activity_label, df_merged_selection, by.y="activity_code", by.x="activity_code")

###### Step 4 Appropriately labels the data set with descriptive variable names ########

## The first 3 columns of our data frame are now 'activity_code', 'activity_description' and 'subject_id'.
## the remaining columns will be the feature vector. So we start to replace at column 4. 
## The names for these columns are taken from the features.txt file, loaded in step 2.
colnames(mergeddata)[4:ncol(mergeddata)] <- as.character(df_features[df_features$select > 0, 2])

###### Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ######

## reshape the data frame in such a way that all feature columns are now stored in one 'variable' column with their value in the value column.
melted <- melt(mergeddata, id.vars=c("subject_id", "activity_code", "activity_description"))

## now calculate the mean per subject, per activity
df_summary <- summarize(group_by(melted, subject_id, activity_code, activity_description, variable), mean(value))
## rename variable column to "feature_name"
colnames(df_summary)[4] <- "feature_name"

## write tidy data frame to file.
write.table(df_summary, file="tidy_data.txt", row.name=FALSE)
