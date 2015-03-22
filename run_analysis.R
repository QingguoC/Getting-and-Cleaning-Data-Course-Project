#getdata assignment
#save current work directory and change it to UCI HAR Dataset
cwd<-getwd()
setwd(paste0(cwd, "/UCI HAR Dataset"))
#Load dataset
features <- read.table("features.txt",header=FALSE, colClass="character")
activitylabel<-read.table("activity_labels.txt", header = FALSE)
xtrain<-read.table("train/x_train.txt", header = FALSE)
ytrain<-read.table("train/y_train.txt", header = FALSE)
subjecttrain<-read.table("train/subject_train.txt", header = FALSE)
xtest<-read.table("test/x_test.txt", header = FALSE)
ytest<-read.table("test/y_test.txt", header = FALSE)
subjecttest<-read.table("test/subject_test.txt", header = FALSE)

#generate whole train data and test data, then combine them to full dataset
train<-cbind(subjecttrain, cbind(ytrain, xtrain))
test<-cbind(subjecttest, cbind(ytest, xtest))
total<-rbind(train, test)

#name the columns
colnames<-c("volunteerid", "activityid", features[,2])
names(total)<-colnames
names(activitylabel) = c("activityid", "activitytype")

#extract mean and std features
extract<-grepl("volunteerid",colnames)|grepl("activityid",colnames)|(grepl("mean()",colnames)&!grepl("meanFreq()",colnames))|grepl("std()", colnames)
final<-total[extract]

#Uses descriptive activity names to name the activities in the data set
finaldata<-merge(activitylabel,final,by="activityid",all=TRUE)
#Appropriately labels the data set with descriptive variable names
colname<-tolower(names(finaldata))
colname<-gsub("-","",colname)
names(finaldata)<-gsub("\\()","",colname)
#Creat tidydata with the average of each variable for each activity and each subject

tidydata<-aggregate(finaldata[,4:69],by=list(finaldata$activitytype,finaldata$volunteerid), mean)
colnames(tidydata)[c(1,2)]<-c("activitytype","volunteerid")
write.table(tidydata,file="tidydata.txt",row.name=FALSE)

#setwd back to saved path
setwd(cwd)
