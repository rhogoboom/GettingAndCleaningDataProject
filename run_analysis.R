##Getting and Cleaning Data Course Project R Script
##Packages Needed for this Script
library(dplyr)

##Please note that for this script to run the data files must be removed from their subfolders and put in to your working directory. Thank you!


##Part 1: Merging Data
##From a Base Working directory, load files in to R
xtestdata <- read.table('X_test.txt')
xtraindata <- read.table('X_train.txt')
ytestdata <- read.table('y_test.txt')
ytraindata <- read.table('y_train.txt')
testsubjects <- read.table('subject_test.txt') ## Test Group Labels
trainsubjects <- read.table('subject_train.txt') ## Train Group Labels
featurelabels <- read.table('features.txt') ## Column Labels

## Adding Subject Number, Activity Number, and Sample type to data
testfactor <- rep(0, times = length(ytestdata[,1])) ## These two lines create a factor variable to add to applicable data
trainfactor <- rep(1, times = length(ytraindata[,1]))

testdata <- cbind(testsubjects, ytestdata, testfactor, xtestdata) ## Merging each of the components for each set.
traindata <- cbind(trainsubjects, ytraindata, trainfactor, xtraindata)

## Prepping the labels
featurelabels <- as.character(featurelabels[,2]) ## Adding Labels for use below
featurelabels <- append(c('Subject Number','Activity','Sample'), featurelabels)

##Add Base Feature Names to Data
colnames(traindata) <- featurelabels
colnames(testdata) <- featurelabels

##Combine the data sets using rbind()
alldata <- rbind(traindata,testdata) ##Went for a "wide" approach to the data.

##Remove other data for cleanup
rm(xtestdata,xtraindata,ytestdata,ytraindata,testsubjects,trainsubjects,featurelabels,
   testfactor, trainfactor, traindata, testdata)

##Replace Activity Number with Name
activityname <- read.table('activity_labels.txt')
activityname[,2] <- gsub("_","", activityname[,2]) ##Tidy data in columns, removing the bars and making lower case
activityname[,2] <- tolower(activityname[,2])
for(activity in activityname[,1]){
  alldata$Activity[(which(alldata$Activity == activity))] = activityname[activity,2]
}

##Convert to factors (Sample already is factored)
alldata$Activity <- as.factor(alldata$Activity)
alldata$`Subject Number` <- as.factor(alldata$`Subject Number`)

## Subsetting for Means and Standard Deviations
validcols <- make.names(names = names(alldata), unique = T, allow_ = T)
names(alldata) <- validcols ## This step needed due to an error w/ column names being duplicated. 
statdata <- select(alldata, Subject.Number, Activity, Sample, matches('[Mm]ean|std()')) ##searches for any column with mean or std in the name. 

##Make the Names Pretty
newnames <- colnames(statdata)
newnames <- gsub('\\.\\.+','.', newnames)
newnames <- gsub('t([A-Z])','Raw.\\1', newnames)
newnames <- gsub('f([A-Z])','FFT.\\1', newnames)
newnames <- gsub('meanFreq','Mean.Frequency', newnames)
newnames <- gsub('mean\\.([X|Y|Z])','Mean.\\1.Axis', newnames)
newnames <- gsub('std\\.([X|Y|Z])','Standard.Dev.\\1.Axis', newnames)
newnames <- gsub('Body','Body.', newnames)
newnames <- gsub('Gravity','Gravity.',newnames)
newnames <- gsub('Gyro','Gyroscope.', newnames)
newnames <- gsub('Acc','Accelerometer.', newnames)
newnames <- gsub('Jerk','Jerk.Signal.', newnames)
newnames <- gsub('Mag','Magnitude.', newnames)
newnames <- gsub('std','Standard.Dev', newnames)
newnames <- gsub('mean','Mean', newnames)
newnames <- gsub('^a','A', newnames)
newnames <- gsub('gravity','Gravity.', newnames)
newnames <- gsub('Body\\.Body','Whole.Body', newnames)
newnames <- gsub('Angle\\.([X|Y|Z])','Angle.\\1.Axis', newnames)
newnames <- gsub('\\.\\.+','.', newnames)
newnames <- gsub('([X|Y|Z])$','\\1.Axis',newnames)
newnames <- sub('[[:punct:]]$','', newnames)

##Apply Names to Dataset
names(statdata) <- newnames

##Group by Subject and Activity
## I interpreted this as we want to show a table w/ 1 row per Subject/Activity, so in all there should be 180 observerations after cleaning. 
groupeddata <- group_by(statdata,Subject.Number,Activity)
summaryset <- summarize_all(groupeddata,funs(mean))
summaryset$Sample <- factor(summaryset$Sample, levels = c(0,1), labels = c('test', 'train')) ## Originally did this above, but lost the label when doing the summarization,
                                                                                             ## So factorized after. 

## Clean Up
rm(activityname,alldata,groupeddata,statdata,activity,newnames,validcols)

##Write Table to working directory
write.table(summaryset,'tidydataset.txt')
