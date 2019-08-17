#Downloading the file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./getdata_projectfiles_UCI HAR Dataset.zip", method="curl")

# Unzip dataSet to /data directory
unzip(zipfile="./getdata_projectfiles_UCI HAR Dataset.zip",exdir="./data")

#define the path where the new folder has been unziped
pathdata <- file.path("./Data","UCI HAR Dataset")
#create a file which has the list of 28 file names
files <- list.files(pathdata, recursive=TRUE)

#Reading training tables - xtrain / ytrain, subject train
xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "Y_train.txt"),header = FALSE)
Subjecttrain = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)

#Reading the testing tables
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "Y_test.txt"),header = FALSE)
subjecttest = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)

#Read the features data
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)

#Read activity labels data
activityLabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#Create Sanity and Column Values to the Train Data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(Subjecttest) = "subjectId"

#Create Sanity and Column Values to the Test Data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subjecttest) = "subjectId"

#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')

#Merging the train and test data
mrg_train = cbind(ytrain, Subjecttrain, xtrain)
mrg_test = cbind(ytest, subjecttest, xtest)

#Create the main data table merging both table tables - this is the solution for the 1st
setAllInOne = rbind(mrg_train, mrg_test)

#read all the values that are available
colNames = colnames(setAllInOne)

#Subset of all the mean and standards and the corresponding activityID and subjectID - Solution for the 2nd
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
setWithActivityNames <- merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

# New tidy set has to be created 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#The last step is to write the ouput to a text file 
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)