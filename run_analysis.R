#Merges the training and the test sets to create one data set.
col_name <- read.table("features.txt")
test <- read.table("test/X_test.txt", col.names=col_name[,2])
train <- read.table("train/X_train.txt", col.names=col_name[,2])
merged <- rbind(test, train)
#Extracts only the measurements on the mean and standard deviation for each measurement. 
Extraction <- col_name[grep("(mean|std)\\(", col_name[,2]),]
mean_std <- merged[,Extration[,1]]
#Uses descriptive activity names to name the activities in the data set
y_test <- read.table("test/y_test.txt", col.names = "activity")
y_train <- read.table("train/y_train.txt", col.names = "activity")
y <- rbind(y_test, y_train)
activity_l <- read.table("activity_l.txt")
#as describe in http://stackoverflow.com/questions/22475400/r-replace-values-in-data-frame-using-lookup-table
for (i in 1:nrow(activity_l)) {
  naming <- as.character(activity_l[i, 2])
  code <- as.numeric(activity_l[i, 1])

  y[y$activity == code, ] <- naming
}
#Appropriately labels the data set with descriptive variable names. 

X_with_labels <- cbind(y, X)
mean_std_labeled <- cbind(y, mean_std)

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
subject_test <- read.table("test/subject_test.txt", col.names = "subject"
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
subject <- rbind(subject_test, subject_train)
means <- aggregate(X, by = list(activity = y[,1], subject = subject[,1]), mean)

#display tiny data
write.table(means, file="final.txt",row.names=FALSE)
