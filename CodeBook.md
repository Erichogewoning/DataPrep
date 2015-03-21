##Code Book

This project aims to prepare and tidy the data collected from the accelerometers from the Samsung Galaxy S smartphone.
This code book describes the transformation from source data to a tidy data set and a description of the data.

### Source data
-------------------

Source data is available here: [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
for more information on the source files themselves, please refer to the README.txt of the unzipped source files.

The following files from the zip file are used:

* `features.txt`: List of all features.
* `activity_labels.txt`: Links the class labels with their activity name.
* `train/X_train.txt`: Training set.
* `train/y_train.txt`: Training labels.
* `test/X_test.txt`: Test set.
* `test/y_test.txt`: Test labels.

### Transformation

The script run_analysis.R is used to create a tidy data set.
Please note that the comments in this script provide even more details about the transformation.

#### Step 1 Merge the training and test data

* load test and train data sets as separate files.
* merge all test data into one *test* data frame.
* merge all train data into one *train* data frame
* merge test and training data frame into one
* for readability, rename the first 2 columns

#### Step 2 Extract only measurements of the mean and std dev

* load the features file. This file contains the descriptions for all measurements
* Using this file, we can find which measurements are 'mean' and 'std dev'.
* add a column that specifies whether the names contains either mean() or std() using a regular expression
* get all columnsnumbers that contain either main() or std() in their description
* keep only the first 2 columns (activity_code and subject_id) and the columns in which the mean() or std() was found

#### Step 3 Uses descriptive activity names to name the activities in the data set

* We will replace the integer values for activities in the second column with descriptions
* these are stored in the 'activity_labels' file.
* add the activity_descriptions to the data frame, joining on the activity_code.

#### Step 4 Appropriately labels the data set with descriptive variable names

The first 3 columns of our data frame are now 'activity_code', 'activity_description' and 'subject_id'.
The remaining columns will be the feature vector. So we start to replace at column 4. 
* The names for these columns are taken from the features.txt file, loaded in step 2.

#### Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. ######

* reshape the data frame in such a way that all feature columns are now stored in one 'variable' column with their value in the value column.
* now calculate the mean per subject, per activity
* write tidy data frame to file. and DONE!


## Tidy data set description


### Variables


* 'subject_id': *numeric* an identifier of the subject who carried out the experiment. Its range is from 1 to 30.
* 'activity_code':  a *numeric* code for describing the activity. These are the original values from y_test and y_train. Values between 1 and 6.
* 'activity description': an activity label for the activity_code *factor*: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
* 'feature_name': *character* name for the feature measure. In the original data set, each measure had its own column. This has been reshaped, so that each type of measure is now a (key, value) pair. For more details about the features, please visit the section below.
* 'mean(value)': *numeric* mean value for the feature in the previous column. Values are in the range [-1,1]

#### Feature_name

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt' in the original zip file.
