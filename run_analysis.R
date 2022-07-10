install.packages(tidyverse)
install.packages(knitr)
install.packages(rmarkdown)

library(knitr)
library(tidyverse)
library(rmarkdown)
    
#loading features (aka variable names)

features <- read.delim('./UCI HAR Dataset/features.txt', header=FALSE)

#converting features to vector

features_char <- unlist(features[['V1']], use.names = FALSE)

#loading and merging of test and train subjects

subject_test <- read.delim('./UCI HAR Dataset/test/subject_test.txt', header=FALSE, col.names = "Subject")
subject_train <- read.delim('./UCI HAR Dataset/train/subject_train.txt', header=FALSE, col.names = "Subject")
merged_subjects <- rbind(subject_test, subject_train)

#loading and merging of test and train activities

y_test <- read.delim('./UCI HAR Dataset/test/y_test.txt', header=FALSE, col.names = "Activity")
y_train <- read.delim('./UCI HAR Dataset/train/y_train.txt', header=FALSE, col.names = "Activity")
Merged_activities <- rbind(y_test,y_train)
activity_labels <- read.delim('./UCI HAR Dataset/activity_labels.txt', header=FALSE)
activity_labels <- cbind(activity_labels, do.call(rbind, strsplit(activity_labels$V1, "( +)")))
names(activity_labels) = c('V1', 'Activity', 'V2')
activity_labels <- mutate(activity_labels, Activity= as.numeric(activity_labels$Activity))
Merged_activities <- left_join(Merged_activities, activity_labels, by=('Activity'))
Merged_activities <- Merged_activities[3]
names(Merged_activities) <- 'Activity'

#loading and merging of test and training datasets

X_test <- read.delim('./UCI HAR Dataset/test/X_test.txt', header=FALSE)
X_train <- read.delim('./UCI HAR Dataset/train/X_train.txt', header=FALSE)
Merged_data <- rbind(X_test,X_train)


#Splitting data from vector form to different columns

Merged_data_split <- cbind(Merged_data, do.call(rbind, strsplit(Merged_data$V1, "( +)")))


#Removing columns 1 and 2

Merged_data_split <- Merged_data_split[c(3:563)]

#Converting from Scientific format to numeric

Merged_data_split[] <- sapply(Merged_data_split, as.numeric)


#Renaming columns based on features

names(Merged_data_split) <- features_char

#Selecting the columns representing means and standard deviations

mean_stdev_loc <- grep("mean|std",names(Merged_data_split))

Merged_data_mean_stdev <- Merged_data_split[mean_stdev_loc]

#Tidying column names

names(Merged_data_mean_stdev) <- sub("[0-9]*[ ]*f","frequency",names(Merged_data_mean_stdev))
names(Merged_data_mean_stdev) <- sub("[0-9]*[ ]*t","time",names(Merged_data_mean_stdev))
names(Merged_data_mean_stdev) <- sub("[0-9]*[ ]*","",names(Merged_data_mean_stdev))
names(Merged_data_mean_stdev) <- sub("\\(\\)","",names(Merged_data_mean_stdev))
names(Merged_data_mean_stdev) <- tolower(names(Merged_data_mean_stdev))

#Merging all

merged_all <- cbind(merged_subjects, Merged_activities, Merged_data_mean_stdev)

#Getting the average of each variable for each activity and each subject

merged_all <- merged_all %>% group_by(Subject, Activity) %>%
              summarize(across(everything(),mean))

#Output

write_csv(merged_all, './Tidy_Data_Set.csv')
write.table(merged_all, file='./Tidy_Data_Set.txt', row.name=FALSE)
