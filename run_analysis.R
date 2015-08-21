#The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

#One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

#Here are the data for the project: 

#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# the data has been unzip into current workspace/directory

# 1. Merges the training and the test sets to create one data set.
X_train_file <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test_file <- read.table("./UCI HAR Dataset/test/X_test.txt")
#row bind both training and test sets for X
X <- rbind(X_train_file, X_test_file)

subject_train_file <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test_file <- read.table("./UCI HAR Dataset/test/subject_test.txt")
#row bind both training and test sets for subject
S <- rbind(subject_train_file, subject_test_file)

Y_train_file <- read.table("./UCI HAR Dataset/train/y_train.txt")
Y_test_file <- read.table("./UCI HAR Dataset/test/y_test.txt")
#row bind both training and test sets for Y
Y <- rbind(Y_train_file, Y_test_file)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./UCI HAR Dataset/features.txt")

# Get the position of features with -mean() and -std() partial words. Escape (\\) the bracket.
index_mean_std <- grep("-mean\\(\\)|-std\\(\\)", features[, 2]) 

# Subset the columns that contain mean and standard deviation data only.
X <- X[, index_mean_std]


# 3. Uses descriptive activity names to name the activities in the data set.
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
Y[, 1] = activities[Y[, 1], 2]
names(Y) <- "activity"


# 4. Appropriately labels the data set with descriptive variable names. 
# Rename the X column names.
names(X) <- features[index_mean_std, 2]

# Remove the open and close bracket
names(X) <- gsub("\\(|\\)", "", names(X)) 


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Rename column name for S
names(S) <- "subject"

# Create final tidy data set
tidyData <- cbind(S, Y, X)

#write the tidy data to data table
library(data.table)
dataDT <- data.table(tidyData)

# Apply mean function to sub-data.table, called '.SD' 
meanData<- dataDT[, lapply(.SD, mean), by=c("subject", "activity")]  

# Write the sorted calculated mean data set to file without row name
write.table(meanData[order(subject,activity),], "tidy_data_average.txt", row.name=FALSE)
