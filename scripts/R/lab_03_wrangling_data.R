library(tidyverse) # data formatting and graphing tools


# 2.0. Wrangling Data 
if (getwd()=='/Users'){
  setwd('annaspracklin/Documents/GitHub/PhysTher5110/data')
}
# setwd("../") # back out from EEG_sub_file to data file
list.files()


DATA <- read.csv("MASTER_EO_and_EC_EEG.csv",
                    header=TRUE, 
                    stringsAsFactors = TRUE)

# Show only rows for older adult subject 2
?dplyr::filter
DATA_subj2 <- DATA %>% filter(subID=="oa02")

# show rows for OA02 and OA03, but only for frequencies < 5 Hz
DATA_prob12 <- DATA %>% filter(subID=="oa02" | subID=="oa03")
DATA_prob12 <- DATA_prob12 %>% filter(Hz<5)

# Create new variables to calculate avg power at each frequency in Frontal, Central, Parietal, and Occipital Regions
df13<- data.frame(matrix(ncol = 2, nrow = 512)) # initialize a data frame
names(df13) = c("Hz","Frontal") # set variable names
Frontal <- DATA %>%
  group_by(Hz) %>% # group by frequency to take mean across people
  summarise(mean_value = mean(c(F3, F7, Fz, F4, F8), na.rm = TRUE)) %>% # take mean
  ungroup()
df13$Frontal <- Frontal$mean_value # assign to data frame
df13$Hz <- Frontal$Hz # assign frequencies for future plotting
# Repeat for central, parietal, and occipital regions
Central <- DATA %>% 
  group_by(Hz) %>%
  summarise(mean_value = mean(c(C3, C4, Cz), na.rm = TRUE)) %>%
  ungroup()
df13$Central <- Central$mean_value
Parietal <- DATA %>%
  group_by(Hz) %>%
  summarise(mean_value = mean(c(P3, P7, Pz, P4, P8), na.rm = TRUE)) %>%
  ungroup()
df13$Parietal <- Parietal$mean_value
Occipital <- DATA %>%
  group_by(Hz) %>%
  summarise(mean_value = mean(c(O1, O2, Oz), na.rm = TRUE)) %>%
  ungroup()
df13$Occipital <- Occipital$mean_value

# Create new variables that reflect the natural log of power in the Frontal, Central, 
# Parietal, and Occipital regions. Also create a new variable for the natural log 
# transform of frequency so that you can look at the data in both “original” space 
# (Power ~ Hz) and log-log space (ln(Power) ~ ln(Hz). Save your new data frame in the 
# “data” folder with the name “data_processed_EEG”. 

df13$logFrontal = log(df13$Frontal)
df13$logCentral = log(df13$Central)
df13$logParietal = log(df13$Parietal)
df13$logOccipital = log(df13$Occipital)
df13$logHz = log(df13$Hz)

write.csv(df13,file="data_processed_EEG.csv")

plot(df13$logHz,df13$logFrontal,'l',
     main = "Frontal Region", xlab = "log frequency", ylab = "log power")
plot(df13$logHz,df13$logCentral,'l',
     main = "Central Region", xlab = "log frequency", ylab = "log power")
plot(df13$logHz,df13$logParietal,'l',
     main = "Parietal Region", xlab = "log frequency", ylab = "log power")
plot(df13$logHz,df13$logOccipital,'l',
     main = "Occipital Region", xlab = "log frequency", ylab = "log power")

# Filter out <30 Hz
df16 <- df13 %>% filter(Hz<=30)
# Plot
plot(df16$logHz,df16$logFrontal,'l',
     main = "Frontal Region", xlab = "log frequency", ylab = "log power")
plot(df16$logHz,df16$logCentral,'l',
     main = "Central Region", xlab = "log frequency", ylab = "log power")
plot(df16$logHz,df16$logParietal,'l',
     main = "Parietal Region", xlab = "log frequency", ylab = "log power")
plot(df16$logHz,df16$logOccipital,'l',
     main = "Occipital Region", xlab = "log frequency", ylab = "log power")

#### written own code above, provided code below ####
# selecting specific columns
head(DATA)

DATA %>% select(subID, condition, Hz, Fz)
select(.data=DATA, subID, condition, Hz, Fz)

DATA %>% select(subID:F3) # subjectID to F3 column

DATA %>% select(-X) # show everything but X

DAT2 <- DATA %>% select(-X, -file_ID)
head(DAT2)

# filtering specific rows
head(DAT2)
?dplyr::filter
DAT3 <- DAT2 %>% filter(subID=="oa02")

DAT3<- DAT2 %>% filter(subID=="oa01" | subID=="oa02")

DAT3 <- DAT2 %>% filter(subID=="oa01" & Hz==0.997)
DAT3

summary(unique(DAT2$Hz))
hist(unique(DAT2$Hz))

DAT3 <- DAT2 %>% filter(Hz<=30)
summary(unique(DAT3$Hz))
hist(unique(DAT3$Hz))


# computing new variables
head(DAT3)

DAT3$Frontal <- (DAT3$F3 + DAT3$F7 + DAT3$Fz + DAT3$F4 + DAT3$F8)/5

?dplyr::mutate()
?dplyr::transmute()

?dplyr::rowwise
DAT3 <- DAT3 %>% rowwise %>%
  mutate(frontal = mean(c(F3, F7, Fz, F4, F8), na.rm=TRUE),
         central = mean(c(C3, Cz, C4), na.rm=TRUE),
         parietal = mean(c(P3, P7, Pz, P4, P8), na.rm=TRUE),
         occipital = mean(c(O1, Oz, O2), na.rm=TRUE)
  )

head(DAT3)
plot(DAT3$Frontal, DAT3$frontal)
cor(DAT3$Frontal, DAT3$frontal, use = "complete.obs")



# Selecting only the columns we want
head(DAT3)
DAT4 <- DAT3 %>% select(subID, condition, Hz,
                        frontal, central, parietal, occipital) %>%
  mutate(ln_Hz = log(Hz),
         ln_frontal = log(frontal),
         ln_central = log(central),
         ln_parietal = log(parietal),
         ln_occipital = log(occipital))

head(DAT4)

setwd("~/GitHub/ReproRehab/data/")
write.csv(DAT4, "data_PROCESSED_EEG.csv")
