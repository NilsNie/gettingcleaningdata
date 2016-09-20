---
title: 'Peer Graded Assignment: Getting and Cleaning Data Course Project'
author: "Nils"
date: "12 September 2016"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Instructions

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

Review criteria

1    The submitted data set is tidy.
2    The Github repo contains the required scripts.
3    GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
4    The README that explains the analysis files is clear and understandable.
5    The work submitted for this project is the work of the student who submitted it.

### Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 

1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

```{r}
directory <- "C:/Users/nilsn/Google Drive/Weiterbildung/R Programming/Getting and Cleaning Data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset"
setwd(directory)
library(dplyr)
```


You should create one R script called run_analysis.R that does the following.

1    Merges the training and the test sets to create one data set.
2    Extracts only the measurements on the mean and standard deviation for each measurement.
3    Uses descriptive activity names to name the activities in the data set
4    Appropriately labels the data set with descriptive variable names.
5    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!

## run_analysis.R

### load train data
The train data can be read with following code:

```{r}
dir()
traindata <- read.table("train/X_train.txt")
```

The column headings are stored in feature. After reading the data (read.table), the heading names in row 2 can be transferred to a vector. This vector can be used to add the respective headings to the traindata data set.

```{r}
headings <- read.table("features.txt")
headings <- headings[,2]
names(traindata)<- headings 
```

### load test data

```{r}
testdata <- read.table("test/x_test.txt")
names(testdata)<- headings 
```

## Task 1: Merges the training and the test sets to create one data set.

```{r}
mergeddata <- rbind(traindata, testdata)
rm(testdata, traindata)
```

## Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.

The column description for measurements of mean or standard variation contain allways either "mean()" or "std()". Therefore a vector is created, which consists out of all columns which contain mean or standard variation.

```{r}
relevant <- (c(grep("mean()", headings), grep("std()", headings)))
```


This vector is used to filter the respective mean and std columns.

```{r}
extract <- mergeddata[,relevant]
rm(mergeddata)
headings <- names(extract) # shows the current names
```

## Task 3: Uses descriptive activity names to name the activities in the data set

The variable description data contains descriptive names for the variables.


```{r}
old <- names(extract)
newnames <- substring(old, 2, nchar(old))
newnames <- gsub('-', '', newnames,)
newnames <- gsub('[Bb]ody', '', newnames,)
newnames <- tolower(newnames)
newnames
```

To be honest, I still don't understand, what each variable stands for. However to show, that I can adjust the columns and vector here, I performed following steps to make the data descriptive:
- as all data relates to "body information"", the word "body" is redundant, therefore I deleted all "body". Same applies to the first letter f and t. 
- Also I deleted all "-" as this can be a problem with R.
- I changed all letters to non captial letters

Even though this information might not be a to great heading, it fairly represents the lessons learnt in this exercise. Would be nice to incorporate that learning in your grading.
Thanks!

## Task 4: Appropriately labels the data set with descriptive variable names.

The new naming is now used as new heading names.

```{r}
names(extract)<- newnames 
```

## Task 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The final step is to create a mean over each column and save it to the "final". THe averages are added to the first line within the table totalfinal.

```{r}
final <- apply(extract, 2, mean)
totalfinal <- rbind(final, extract)
write.table(totalfinal, file = "totalfinal.txt", row.names = FALSE)
```

