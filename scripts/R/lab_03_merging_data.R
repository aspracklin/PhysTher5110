library(tidyverse) # data formatting and graphing tools


# 1.0. Importing, merging, and relabeling, the data. 
# setting working directories
setwd("./Documents/GitHub/PhysTher5110/")
list.files()

list.files("./data")
list.files("./data/EEG_sub_files/")

#setwd("~/GitHub/PhysTher5110/data/EEG_sub_files/")
setwd('./data/EEG_sub_files/')
# Testing out importing data with 1 subject:
test <- read.csv("./oa01_ec.csv",
                    header=TRUE, 
                    stringsAsFactors = TRUE)

#loading all file names
file_names <- list.files()
#Print all file names
for (name in file_names) {
  print(name)
}

# check if the first file is "oa01_ec.csv"
file_names[1] == "oa01_ec.csv"

# for-loop to concatenate data from each file
allData = data.frame() # initialize a data frame to save each file to
for (name in file_names){ #loop across all file names 
  subjectData = read.csv(name, # read file
                         header=TRUE, stringsAsFactors = TRUE)
  subjectData$file_ID = name #add file ID to the data
  allData = rbind(allData,subjectData) # concatenate data across subjects (add data from each iteration of the loop to the data set from previous subjects)
  rm(subjectData) # remove the subjectData to write over it next iteration, especially because it won't have the same dimensions initially.
}

# Reading in the individual subjects and merging into a master file

# Putting an if else statement inside of our for-lopp
#for(name in file_names) { # looping across all file names
#  print(name) # print name for the iteration
#  subject <- read.csv(name, #read the data file
#                      header=TRUE, 
#                      stringsAsFactors = TRUE)
#  
#  if (!exists("MASTER")){ # check to see if there is already a data frame to save to. If not, continue to next line. 
#    MASTER <- data.frame(subject) # create data frame for the first subject
#    MASTER$file_id <- name # add fileID to data frame
#    
#    
#  } else { # if there already is a data frame to save to
#    temp_dataset <- data.frame(subject) # create a temporary data set so we can add file ID as a variable
#    temp_dataset$file_id <-  name # add file ID as a variable
#    
#    MASTER<-rbind(MASTER, temp_dataset) #concatenate rows with previous iterations of MASTER data frame
#    
#    rm(temp_dataset)
#  }
#}


head(allData)

#move the file_id variable to the front of the dataset
allData <- allData%>% relocate(file_ID)

# remove X
allData <- allData %>% select(-X)

head(allData)

# What class is  file_ID
class(allData$file_ID)

# split the file ID into subject and condition
str_split(allData$file_ID, "_")[[1]] # splits at the underscore

# Save the subject ID and the condition as new factors in the data frame
allData$subID <- factor(map_chr(str_split(allData$file_ID, "_"), 1))
allData$condition <- factor(map_chr(str_split(allData$file_ID, "_"), 2))

# Extract the age group
str_split(allData$file_ID, "a")[[1]] # split at the a, o indicates older adult, y indicates younger adult
allData$ageGroup <- factor(map_chr(str_split(allData$file_ID, "a"), 1))

allData <- allData %>% relocate(file_ID, subID, condition,ageGroup)
head(allData)

# Write file as CSV
write.csv(allData,file="../MASTER_EO_and_EC_EEG.csv")


# Export the cleaned PSD data
#getwd()
#
#setwd("~/Instrumentation/data/")
#write.csv(MASTER, "MASTER_EO_and_EC_EEG.csv")