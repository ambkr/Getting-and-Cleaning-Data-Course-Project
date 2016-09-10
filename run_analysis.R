# download the data
downloaded_data <- "getdata_dataset.zip"

if (!file.exists(downloaded_data)){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileUrl, downloaded_data, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(downloaded_data) 
}

# load plyr
library(plyr)

# merge training and test sets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_combo <- rbind(x_train, x_test)
y_combo <- rbind(y_train, y_test)
subject_combo <- rbind(subject_train, subject_test)

# read features
features <- read.table("UCI HAR Dataset/features.txt")

# select only mean & std features
select_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset columns and assign names
x_combo <- x_combo[, select_features]
names(x_combo) <- features[select_features, 2]

# read activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

# assign activity labels
y_combo[, 1] <- activity_labels[y_combo[, 1], 2]

# rename activity and subject
names(y_combo) <- "activity"
names(subject_combo) <- "subject"

# combine data
conclusion <- cbind(x_combo, y_combo, subject_combo)

# create a second, indie tidy data set with the average of each variable for each activity and each subject
newest_indie_data <- ddply(conclusion, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(newest_indie_data, "newest_indie_data.txt", row.name=FALSE)