### Set working directory

setwd("C:/Users/miair/datasciencecoursera/exdata_2Fdata%2Fhousehold_power_consumption")

### Read features and activity labels

features        <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

### Switch directory to the train sample directory and read train data (X, y and subject)

setwd("C:/Users/miair/datasciencecoursera/exdata_2Fdata%2Fhousehold_power_consumption/train")

X_train           <- read.table("X_train.txt")
colnames(X_train) <- features$V2  # Here we assign features names to the columns
y_train           <- read.table("y_train.txt")
subject_train     <- read.table("subject_train.txt")

### Switch directory to 'Inertial Signals' directory and read all data there

setwd("C:/Users/miair/datasciencecoursera/exdata_2Fdata%2Fhousehold_power_consumption/train/Inertial Signals")
train.files <- list.files()  # List of all files in this directory

for(i in 1:length(train.files)) 
        {
                assign(train.files[i], read.table(train.files[i]))
        }
rm(train.files, i)  ## Remove unnecessary objects

### Now we do exactly the same with the test data

setwd("C:/Users/miair/datasciencecoursera/exdata_2Fdata%2Fhousehold_power_consumption/test")
X_test<-read.table("X_test.txt")
colnames(X_test)<-features$V2

y_test<-read.table("y_test.txt")
subject_test<-read.table("subject_test.txt")

setwd("C:/Users/miair/datasciencecoursera/exdata_2Fdata%2Fhousehold_power_consumption/test/Inertial Signals")
test.files<-list.files()

for(i in 1:length(test.files)) 
        {
                assign(test.files[i],read.table(test.files[i]))
        }
rm(test.files, i)


### Bind data to create one sample

subject     <- rbind(subject_test, subject_train)
X           <- rbind(X_test      , X_train      ) 
y           <- rbind(y_test      , y_train      )

bind_inertial_signals <- function(f) # Function for binding data in 'Inertial signals' folders
        {
                rbind(get(paste(f, "_test.txt", sep="")), get(paste(f, "_train.txt", sep="")))
        }

body_acc_x  <- bind_inertial_signals("body_acc_x" )
body_acc_y  <- bind_inertial_signals("body_acc_y" )
body_acc_z  <- bind_inertial_signals("body_acc_z" )
total_acc_x <- bind_inertial_signals("total_acc_x")
total_acc_y <- bind_inertial_signals("total_acc_y")
total_acc_z <- bind_inertial_signals("total_acc_z")
body_gyro_x <- bind_inertial_signals("body_gyro_x")
body_gyro_y <- bind_inertial_signals("body_gyro_y")
body_gyro_z <- bind_inertial_signals("body_gyro_z")

rm(list = ls()[grep("train", ls())])  # Remove unnecessary data
rm(list = ls()[grep("test" , ls())])
rm(bind_inertial_signals)

### Name activities in our dataset

y$V1         <- factor(y$V1)
levels(y$V1) <- activity_labels$V2 

### Bind subject, activities and core data

z<-cbind(subject = subject$V1, activity_labels = y$V1, X)

### Get mean and std features

features_mean<-as.character(features$V2[grep("\\bmean()\\b", features$V2)])
features_std <-as.character(features$V2[grep("\\bstd()\\b" , features$V2)])

### Here we create tidy dataset for step 4 in the assignment

final_tidy_data<-z[, c("subject", "activity_labels", features_mean, features_std)]

### Creates a tidy data set with the average of each variable for each activity and each subject.

average_final_tidy_data<-aggregate(final_tidy_data[, 3:68], 
                                   list(final_tidy_data$subject, 
                                        final_tidy_data$activity_labels), 
                                   mean)

colnames(average_final_tidy_data)[1:2] <- c("subject", "activity_labels")

### Set back the working directory and write final dataset into csv file

setwd("C:/Users/miair/datasciencecoursera/exdata_2Fdata%2Fhousehold_power_consumption")
write.table(average_final_tidy_data, 
           file="average_final_tidy_data.txt",
           row.name=FALSE)
r<-read.table("average_final_tidy_data.txt", header = TRUE)

