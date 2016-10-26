# setwd(directory)
library(dplyr)
dir()

# Traindata
traindata <- read.table("train/X_train.txt")
# reads the traindata table
activity_train <- read.table("train/y_train.txt")
# reads the activities per train data
names(activity_train) <- "activity"
# new column name for activity data
headings <- read.table("features.txt")
headings <- headings[,2]
names(traindata)<- headings 
#loads the traindata headings and adds them to the traindata
traindata <- cbind(traindata, activity_train)
#adds the column activity
traindata$subject <- "train"
# adds a column "subject" and defines the data as "train"

# Testdata
# following code does the same steps for the Testdata as for the Traindata
testdata <- read.table("test/x_test.txt")
names(testdata)<- headings 
activity_test <- read.table("test/y_test.txt")
names(activity_test) <- "activity"
testdata <- cbind(testdata, activity_test)
testdata$subject <- "test"

# Merges Data
mergeddata <- rbind(traindata, testdata)
# deletes all files, which are not required any longer
rm(testdata, traindata, activity_test, activity_train)

# identification of a vector (81 items) containing all mean, std columns and the activity & subject columns
relevant <- (c(grep("mean()", headings), grep("std()", headings), 562, 563))

# subsetting the mergeddata to only the relevant 81 columns
extract <- mergeddata[,relevant]
rm(mergeddata, relevant)
headings <- names(extract) # shows the current names

# change column 80 activities to descriptive activity naming
activities <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
for(i in 1:6){
  extract$activity <- gsub(i,activities[i],extract$activity)
}

# change namings
old <- names(extract)
newnames <- substring(old, 2, nchar(old))
newnames <- gsub('-', '', newnames,) # discard "-"
newnames <- gsub('[Bb]ody', '', newnames,) # delete Body, as it is redundant
newnames <- tolower(newnames) #change all to lower
newnames[80] <- "activity" #rename activity
newnames[81] <- "subject" # rename subject
names(extract)<- newnames # use newnames as headings
rm(old, newnames, i, headings) # discard items which are not needed any longer

# From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
final <- aggregate(.~subject+activity, data = extract, mean) 
write.table(final, file = "final.txt", row.names = TRUE)
