#Step 1 - Merge the training and test sets to create one data set

##Reading the training data sets
setwd("/Users/AnirudhS/Dropbox/Coursera/Getting and Cleaning Data/Course Project/UCI HAR Dataset/train/")
x_training <- read.table("X_train.txt")
y_training <- read.table("y_train.txt")
subject_training <- read.table("subject_train.txt")

Training <- cbind(subject_training,y_training,x_training)

##Reading the test data sets
setwd("/Users/AnirudhS/Dropbox/Coursera/Getting and Cleaning Data/Course Project/UCI HAR Dataset/test/")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

Test <- cbind(subject_test,y_test,x_test)

#combining both the test and training into rows

CombinedData <- rbind(Training,Test)
colnames(CombinedData)[1] <- "Subjects"
colnames(CombinedData)[2] <- "Activity"

#Creating a temporary subset
Temp <- CombinedData[,c(1,2)]
CombinedData$Subjects <- NULL
CombinedData$Activity <- NULL

setwd("/Users/AnirudhS/Dropbox/Coursera/Getting and Cleaning Data/Course Project/UCI HAR Dataset/")
f_temp <- read.table("features.txt", head=FALSE)
names(CombinedData) <- f_temp$V2

CombinedData <- cbind(Temp,CombinedData)

##Step2 - Extracts only the measurements on the mean and standard deviation for each measurement.

setwd("/Users/AnirudhS/Dropbox/Coursera/Getting and Cleaning Data/Course Project/UCI HAR Dataset/")
#reading the features table for identifying columns with mean and std deviation

f <- read.table("features.txt")
sub_f <- grep("-(mean|std)\\(\\)", f[, 2]) #This gives us the column numbers which we need to subset
#But we added 2 columns before this numbering, this we need to add 2 to each of the values of this list
sub_f <- sub_f + 2
sub_f <- c(1,2,sub_f)

#Subsetting the columns which indicate mean or standard deviation value:

Sub_CombinedData <- subset(CombinedData,select = sub_f)
  
##Step3 - Uses descriptive activity names to name the activities in the data set
#Reading the activity label file
setwd("/Users/AnirudhS/Dropbox/Coursera/Getting and Cleaning Data/Course Project/UCI HAR Dataset/")
a <- read.table("activity_labels.txt")
Sub_CombinedData[, 2] <- a[Sub_CombinedData[, 2], 2]

##Step4 - Appropriately labels the data set with descriptive variable names.
#Getting the column names from features table
# The data is already having proper column names and variable names

##Step5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Tidy_Data <- aggregate(. ~Subjects + Activity, Sub_CombinedData, mean)

#Tidy_Data is the required table that we require
setwd("/Users/AnirudhS/Dropbox/Coursera/Getting and Cleaning Data/Course Project/")
write.table(Tidy_Data, file = "tidy_data.txt",row.name=FALSE)
