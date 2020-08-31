
# Read the table data for features and activities 
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Read train data 
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(train) <- features$V2 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") 
train$activity <- y_train$V1
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 
train$subject <- factor(subject_train$V1)


# Read test data
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(test) <- features$V2
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
test$activity <- y_test$V1
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test$subject <- factor(subject_test$V1)

# Combine test and train data 
dataset <- rbind(test, train) 

# Filter column labels
column.names <- colnames(dataset)
column.names.filtered <- grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
dataset.filtered <- dataset[, column.names.filtered] 

# Include desctiptive values
dataset.filtered$activitylabel <- factor(dataset.filtered$activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

# a tidy dataset with mean values
features.colnames = grep("std\\(\\)|mean\\(\\)", column.names, value=TRUE)
dataset.melt <-melt(dataset.filtered, id = c('activitylabel', 'subject'), measure.vars = features.colnames)
dataset.tidy <- dcast(dataset.melt, activitylabel + subject ~ variable, mean)
                                         
# Save tidy dataset
write.table(dataset.tidy, file = "tidy_dataset.txt" row.names = FALSE)
