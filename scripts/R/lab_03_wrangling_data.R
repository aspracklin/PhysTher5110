library(tidyverse) # data formatting and graphing tools


# 2.0. Wrangling Data 
setwd("../") # back out from EEG_sub_file to data file
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
DATA_prob13 <- DATA
DATA_prob13$Frontal = (DATA_prob13$F3 + DATA_prob13$F7 + DATA_prob13$Fz + DATA_prob13$F4 + DATA_prob13$F8)/5
DATA_prob13$Central = (DATA_prob13$C3 + DATA_prob13$C4 + DATA_prob13$Cz)/3
DATA_prob13$Parietal = (DATA_prob13$P3 + DATA_prob13$P7 + DATA_prob13$Pz + DATA_prob13$P4 + DATA_prob13$P8)/5
DATA_prob13$Occipital = (DATA_prob13$O1 + DATA_prob13$O2 + DATA_prob13$Oz)/3





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
