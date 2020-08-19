library(data.table)
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./UCI HAR Dataset.zip")){
    download.file(fileurl,"./UCI HAR Dataset.zip",mode = "wb")
    unzip("UCI HAR Dataset.zip",exdir = getwd())
}

skil<-read.csv("./UCI HAR Dataset/features.txt",header = FALSE,sep = " ")
skil<-as.character(skil[,2])

data.train.x<-read.table("./UCI HAR Dataset/train/X_train.txt")
data.train.activity<-read.csv("./UCI HAR Dataset/train/y_train.txt",header = FALSE,sep = " ")
data.train.subject<-read.csv("./UCI HAR Dataset/train/subject_train.txt",header = FALSE ,sep = " ")

data.train <- data.frame(data.train.subject,data.train.activity,data.train.x)
names(data.train)<-c(c("subject" , "activity"),skil)

data.test.x<-read.table("./UCI HAR Dataset/test/X_test.txt")
data.test.activity<-read.csv("./UCI HAR Dataset/test/y_test.txt",header = FALSE,sep = " ")
data.test.subject<-read.csv("./UCI HAR Dataset/test/subject_test.txt",header = FALSE , sep = " ")

data.test<-data.frame(data.test.subject,data.test.activity,data.test.x)
names(data.test)<-c(c("subject","activity"),skil)

data.all <- rbind(data.train, data.test)

mean_std.select<- grep("mean|std",skil)
datSub<- data.all[,c(1,2,mean_std.select +2)]

activtity.labels <-read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE)
activtity.labels <- as.character(activtity.labels[,2])
datSub$activity <- activtity.labels[datSub$activity]

name.new<-names(datSub)
name.new<-gsub("[(][)]","",name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(datSub)<-name.new

dataTidy <- aggregate(datSub[,3:81], by = list(activity = datSub$activity, subject = datSub$subject),FUN = mean)
write.table(x = dataTidy, file = "data_tidy.txt", row.names = FALSE)
