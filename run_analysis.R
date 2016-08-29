# load data.table library

library(data.table)

# download the data

downloaded_data <- "getdata_dataset.zip"

if (!file.exists(downloaded_data)){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileUrl, downloaded_data, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(downloaded_data) 
}

# combine test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
final_test <- cbind(subject_test, y_test, x_test)
test_data <- cbind(a = 1, final_test)

# combine train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
final_train <- cbind(subject_train, y_train, x_train)
train_data <- cbind(a = 2, final_train)

# combine test and train data
pt1data <- rbind(test_data, train_data)

# finding mean
mean_subset <- pt1data[, 4:564]
rowmeans <- rowMeans(mean_subset, na.rm = FALSE)

# finding standard deviation
rowsd <- apply(mean_subset, 1, sd)



#creating new table with assigned cohort, subject number, activity, measurement mean, measurement sd
combofirsthalf <- pt1data[, 1:3]
finishedcombo <- cbind(combofirsthalf, rowmeans, rowsd)

#adding descriptive labeling to variable names (columns) and to categories for assigned cohort and activity
colnames(finishedcombo) <- c("assigned_cohort", "subject_number", "activity", "measurement_mean", "measurement_sd")
finishedcombo[,1] <- ifelse(finishedcombo[,1] == 1, "TEST", "TRAIN")
finishedcombo[,3] <- ifelse(finishedcombo[,3] == 1, "WALKING", ifelse(finishedcombo[,3] == 2, "WALKING_UPSTAIRS", ifelse(finishedcombo[,3] == 3, "WALKING_DOWNSTAIRS", ifelse(finishedcombo[,3] == 4, "SITTING", ifelse(finishedcombo[,3] == 5, "STANDING","LAYING")))))

#data set in "step 4" (finishedcombo) now complete.
#now creating a second, independent tidy data set with the average of each variable for each activity and each subject

tidy_indie_data <- aggregate(finishedcombo[,4:5], by = list(finishedcombo$subject_number, finishedcombo$activity), FUN = mean)
colnames(tidy_indie_data) <- c("subject_number", "activity", "measurement_mean", "measurement_sd")
write.table(tidy_indie_data, file="tidy_indie_data.txt", row.names = FALSE)