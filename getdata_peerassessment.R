## load the data
dataFolder <- ""
features <- read.table(paste(dataFolder, 'features.txt', sep=""), stringsAsFactors=F)
labels <- read.table(paste(dataFolder, 'activity_labels.txt', sep=""), stringsAsFactors=F)

X_train<-read.table(paste(dataFolder, 'train/X_train.txt', sep=""))
y_train<-read.table(paste(dataFolder, 'train/y_train.txt', sep=""))
subject_train<-read.table(paste(dataFolder, 'train/subject_train.txt', sep=""))
X_test<-read.table(paste(dataFolder, 'test/X_test.txt', sep=""))
y_test<-read.table(paste(dataFolder, 'test/y_test.txt', sep=""))
subject_test<-read.table(paste(dataFolder, 'test/subject_test.txt', sep=""))

## merge the data sets
activity <- rbind(
  cbind(subject_train, y_train, X_train),
  cbind(subject_test, y_test, X_test)
)

## label the data
names(activity) <- c("subject", "activity", features$V2)   # label features
activity <- merge(activity, labels, by.x="activity", by.y="V1", all.x=T) # merge on activity labels
names(activity)[ncol(activity)] <- "activity_label"  # name the activity label column

## extracting ONLY means and standard deviations
activity <- cbind(
  activity[,c("subject","activity_label")],
  activity[,(grepl("mean()", names(activity)) | grepl("std()", names(activity)))]
)

## second data set with means for each activity and each subject
library(plyr)
activityMeans <- ddply (activity, .(subject, activity_label), numcolwise(mean))

## output data as text file
write.table(activityMeans, "activityMeans.txt", row.name=FALSE)
