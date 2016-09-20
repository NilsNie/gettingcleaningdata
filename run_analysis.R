# directory <- "..." # your working directory here!
setwd(directory)
library(dplyr)

dir()
traindata <- read.table("train/X_train.txt")

headings <- read.table("features.txt")
headings <- headings[,2]
names(traindata)<- headings 

testdata <- read.table("test/x_test.txt")
names(testdata)<- headings 

mergeddata <- rbind(traindata, testdata)
rm(testdata, traindata)

relevant <- (c(grep("mean()", headings), grep("std()", headings)))


extract <- mergeddata[,relevant]
rm(mergeddata)
headings <- names(extract) # shows the current names

old <- names(extract)
newnames <- substring(old, 2, nchar(old))
newnames <- gsub('-', '', newnames,)
newnames <- gsub('[Bb]ody', '', newnames,)
newnames <- tolower(newnames)
newnames

names(extract)<- newnames 

final <- apply(extract, 2, mean)
totalfinal <- rbind(final, extract)
write.table(totalfinal, file = "totalfinal.txt", row.names = FALSE)

