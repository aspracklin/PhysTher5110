library(tidyverse);
# By treating this workshop as an R project, we can use relative file paths that
# allow you to open the data anywhere on any computer, provided you have downloaded 
# the whole workshop folder.
getwd()


## 1.0 Plotting Discrete Data --------------------------------------------------
# Anscombe's Quartet and the Importance of Checking Assumptions
#DAT1 <- read.csv("./data/data_ANSCOMBE.csv", header = TRUE, sep = ",")
#head(DAT1)


## Regression Coefficients ---- 
#COEFS<-DAT1 %>%
#  group_by(group) %>%
#  summarise(Intercept=lm(yVal~xVal, data=DAT1)$coefficients[1],
#            Slope=lm(yVal~xVal, data=DAT1)$coefficients[2],
#            MeanY=mean(yVal),
#            SDY = sd(yVal),
#            MeanX=mean(xVal),
#            SDX = sd(xVal))
#COEFS


# Visualizing All the Data
#ggplot(DAT1, aes(x = xVal, y = yVal)) +
#  geom_point(aes(fill=as.factor(group)), pch=21, color="black", size=2)+
#  stat_smooth(aes(col=as.factor(group)), method="lm", se=FALSE, lwd=1)+
#  facet_wrap(~group, ncol=2)+
#  scale_x_continuous(name = "X Values") +
#  scale_y_continuous(name = "Y Values") +
#  theme(axis.text=element_text(size=16, color="black"), 
#        axis.title=element_text(size=16, face="bold"),
#        plot.title=element_text(size=16, face="bold", hjust=0.5),
#        panel.grid.minor = element_blank(),
        #axis.text.y=element_blank(),
        #axis.title.y=element_blank(),
        #axis.ticks.y=element_blank(),
#        legend.position = "none")

#head(DATA)


## Disctrete Categorical Data
DAT2 <- read.csv("./data/data_FINAL_RATINGS.csv", header = TRUE, sep = ",")
head(DAT2)

MEANS<-DAT2 %>%
  group_by(Elevation, Speed) %>%
  summarise(ave_Effort=mean(Effort),
            N = length(Effort),
            SD = sd(Effort))

MEANS

# Plot all data
ggplot(DAT2, aes(x = Elevation, y = Effort)) +
  geom_point(aes(fill=Elevation), pch=21, size=2,
             position=position_jitter(w=0.2, h=0))+
  geom_boxplot(fill="white", col="black",
               alpha=0.4, width=0.5)+
  scale_fill_manual(values=c("#d95f02", "#7570b3"))+
  scale_color_manual(values=c("#d95f02", "#7570b3"))+ 
  scale_y_continuous(name = "Effort (%)", limits = c(0,100)) +
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "none")

# Boxplots
ggplot(DAT2, aes(x = Elevation, y = Effort)) +
  geom_point(aes(fill=Elevation), pch=21, size=2,
             position=position_jitter(w=0.2, h=0))+
  geom_boxplot(fill="white", col="black", outlier.shape = "na",
               alpha=0.4, width=0.5)+
  facet_wrap(~Speed) +
  scale_fill_manual(values=c("#d95f02", "#7570b3"))+
  scale_color_manual(values=c("#d95f02", "#7570b3"))+  
  scale_y_continuous(name = "Effort (%)", limits = c(0,100)) +
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "none")

# Continuous Data
MOTION_DAT <- read.csv("./data/gait_example_data/motion_data.csv")
head(MOTION_DAT)
MOTION_DAT <- MOTION_DAT %>% select(`DDH25.RICAL_X`, 
                                    `DDH25.RICAL_Y`,
                                    `DDH25.RICAL_Z`, 
                                    `DDH25.RLKNE_X`, 
                                    `DDH25.RLKNE_Y`,
                                    `DDH25.RLKNE_Z`) %>%
  rename(right_heel_x = `DDH25.RICAL_X`, 
         right_heel_y = `DDH25.RICAL_Y`,
         right_heel_z = `DDH25.RICAL_Z`,
         right_lat_knee_x = `DDH25.RLKNE_X`, 
         right_lat_knee_y = `DDH25.RLKNE_Y`,
         right_lat_knee_z = `DDH25.RLKNE_Z`) %>%
  rownames_to_column(var="sample") %>%
  mutate(sample = as.numeric(sample)-3) # To start the samples at 1

# Create the scatter plot
ggplot(data = MOTION_DAT, aes(x = right_heel_x, y = right_lat_knee_x)) +
  geom_point(color="#1b9e77") +
  ggtitle("R heel vs R knee position during running") +
  xlab("Right Heel Position") +
  ylab("Right Knee Position") +
  scale_fill_manual(values=c("#1b9e77")) +
  scale_color_manual(values=c("#1b9e77"))+
  geom_smooth(method = "lm", se = TRUE,color="black")

# Bin the data
dataRange = max(MOTION_DAT$right_heel_x)-min(MOTION_DAT$right_heel_x)
cut_points = c(min(MOTION_DAT$right_heel_x),
               min(MOTION_DAT$right_heel_x)+(dataRange/4),
               min(MOTION_DAT$right_heel_x)+(dataRange/2),
               min(MOTION_DAT$right_heel_x)+(3*(dataRange/4)),
               max(MOTION_DAT$right_heel_x))
#bin1 <- MOTION_DAT %>% filter(MOTION_DAT$right_heel_x<cut_points[2])
#bin2 <- MOTION_DAT %>% filter(MOTION_DAT$right_heel_x>cut_points[2]&MOTION_DAT$right_heel_x<cut_points[3])
#bin3 <- MOTION_DAT %>% filter(MOTION_DAT$right_heel_x>cut_points[3]&MOTION_DAT$right_heel_x<cut_points[4])
#bin4 <- MOTION_DAT %>% filter(MOTION_DAT$right_heel_x>cut_points[4]&MOTION_DAT$right_heel_x<cut_points[5])

MOTION_DAT$bin = rep(0,nrow(MOTION_DAT))
for (i in 1:nrow(MOTION_DAT)) {
  if(MOTION_DAT$right_heel_x[i]<=cut_points[2]){
    MOTION_DAT$bin[i] = 1
  }
  if(MOTION_DAT$right_heel_x[i]>cut_points[2]&MOTION_DAT$right_heel_x[i]<=cut_points[3]){
    MOTION_DAT$bin[i] = 2
  }
  if(MOTION_DAT$right_heel_x[i]>cut_points[3]&MOTION_DAT$right_heel_x[i]<=cut_points[4]){
    MOTION_DAT$bin[i] = 3
  }
  if(MOTION_DAT$right_heel_x[i]>cut_points[4]&MOTION_DAT$right_heel_x[i]<=cut_points[5]){
    MOTION_DAT$bin[i] = 4
  }
}
MOTION_DAT$bin = as.factor(MOTION_DAT$bin)

# Boxplots
ggplot(MOTION_DAT, aes(x = bin, y = right_lat_knee_x)) +
  geom_point(aes(fill=bin), pch=21, size=2,
             position=position_jitter(w=0.2, h=0))+
  geom_boxplot(fill="white", col="black",
               alpha=0.4, width=0.5)+
  scale_fill_manual(values=c("#a6cee3", "#1f78b4","#b2df8a","#33a02c"))+
  scale_color_manual(values=c("#a6cee3", "#1f78b4","#b2df8a","#33a02c"))+  
  scale_y_continuous(name = "R knee Position", limits = c(460,530)) +
  theme(axis.text=element_text(size=16, color="black"), 
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "none")

# Connect the dots
#head(DAT2)
#DAT3 <- DAT2 %>% 
#  group_by(Elevation, Speed) %>%
#  summarise(Effort=mean(Effort))
#head(DAT3)

#ggplot(DAT2, aes(x = Elevation, y = Effort)) +
#  geom_point(aes(fill=Elevation), pch=21, size=2)+
#  geom_line(aes(group=SUBJ, lty=Speed), col="grey40")+
#  facet_wrap(~Speed) +
#  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
#  scale_color_manual(values=c("#E69F00", "#56B4E9"))+
#  scale_y_continuous(name = "Effort (%)", limits = c(0,100)) +
#  theme(axis.text=element_text(size=16, color="black"), 
#        axis.title=element_text(size=16, face="bold"),
#        plot.title=element_text(size=16, face="bold", hjust=0.5),
#        panel.grid.minor = element_blank(),
#        strip.text = element_text(size=16, face="bold"),
#        legend.position = "none") +
#  stat_smooth(aes(group=Speed, lty=Speed), col="black", lwd=2, se=FALSE)+
#  geom_point(data=DAT3, aes(fill=Elevation), shape=22, size=5)







# 2.0 Visualizing Continuous Data ----------------------------------------------
# Acquisition Data -------------------------------------------------------------
list.files()
ACQ<-read.csv("./data_CI_ERRORS.csv", header = TRUE, sep=",",  
              na.strings=c("NA","NaN"," ",""))
head(ACQ)
ACQ$subID<-factor(ACQ$subID)
ACQ$target_nom<-factor(ACQ$target)

# Removing Outliers
ACQ <- subset(ACQ, absolute_error < 1000)

head(ACQ)

ggplot(data=ACQ, aes(x=target+constant_error))+
  geom_density(aes(col=target_nom, fill=target_nom), alpha=0.4)+
  facet_wrap(~group)+
  scale_fill_manual(values=c("#000000","#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#000000", "#E69F00", "#56B4E9"))+
  scale_x_continuous(name="Time Produced (ms)")+
  scale_y_continuous(name = "Density", limits = c(0,0.003)) +  
  labs(fill = "Target (ms)", col="Target (ms)")+
  theme(axis.text=element_text(size=12, color="black"), 
        legend.text=element_text(size=16, color="black"),
        legend.title=element_text(size=16, face="bold"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"))


# Post-Test Data ---------------------------------------------------------------
POST<-read.csv("./Post Data_Long Form.csv", header=TRUE)
head(POST)

POST$Participant<-factor(POST$Participant)
POST$target_nom<-factor(POST$Target.Time)
POST<-subset(POST, Absolute.Error < 1000)


# Subsetting into retention and transfer
RET <- subset(POST, Target.Time == 1500|Target.Time == 1700|Target.Time == 1900)

# Retention Data
ggplot(data=RET, aes(x=target_nom, y=Absolute.Error))+
  scale_fill_manual(values=c("#000000","#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#000000", "#E69F00", "#56B4E9"))+
  geom_jitter(aes(group=Group, fill=target_nom), pch=21, position=position_jitterdodge(dodge.width=0.8))+
  geom_boxplot(aes(lty=Group, col=target_nom), fill="white", 
               alpha=0.4, outlier.shape = NA)

ggplot(data=RET, aes(x=Target.Time+Constant.Error))+
  geom_density(aes(col=target_nom, fill=target_nom), alpha=0.4)+
  facet_wrap(~Group) +
  scale_fill_manual(values=c("#000000","#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#000000", "#E69F00", "#56B4E9"))+
  scale_x_continuous(name="Time Produced (ms)")+
  scale_y_continuous(name = "Density", limits = c(0,0.003)) +
  labs(fill = "Target (ms)", col="Target (ms)")+
  theme(axis.text=element_text(size=12, color="black"), 
        legend.text=element_text(size=16, color="black"),
        legend.title=element_text(size=16, face="bold"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"))


# Longitudinal Plots of Practice Data ------------------------------------------
# Aggregate Practice Data into Blocks
head(ACQ)

ACQ_AVE<-ACQ %>%
  group_by(subID, group, block) %>%
  summarise(CE_AVE = mean(constant_error, na.rm=TRUE),
            AE_AVE = mean(absolute_error, na.rm=TRUE))

head(ACQ_AVE)

sd(ACQ_AVE$CE_AVE)

ACQ_GROUP_AVE<-ACQ_AVE %>%
  group_by(group, block) %>%
  summarise(CE = mean(CE_AVE, na.rm=TRUE),
            CE_sd = sd(CE_AVE, na.rm=TRUE),
            AE = mean(AE_AVE, na.rm=TRUE),
            AE_sd = sd(AE_AVE, na.rm=TRUE),
            N=length(AE_AVE))

head(ACQ_GROUP_AVE)

# More traditional plot averaging across trials ----
ggplot(ACQ_GROUP_AVE, aes(x = block, y = AE)) +
  geom_line(aes(col=group), lwd=1)+
  geom_errorbar(aes(ymin = AE-AE_sd/sqrt(N), ymax=AE+AE_sd/sqrt(N)),
                width = 0.1)+
  geom_point(aes(fill=group), shape=21, size=2)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+
  scale_x_continuous(name = "Block", breaks = c(1,2,3)) +
  scale_y_continuous(name = "Absolute Error (ms)", limits = c(0,250)) +
  labs(fill = "Group", col="Group")+
  theme(axis.text=element_text(size=16, color="black"), 
        legend.text=element_text(size=16, color="black"),
        legend.title=element_text(size=16, face="bold"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "top")


head(ACQ)
ggplot(ACQ, aes(x = trial_total, y = absolute_error , group=subID)) +
  geom_line(aes(col=group), lwd=1)+
  geom_point(aes(fill=group), shape=21, size=2)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+  
  scale_x_continuous(name = "Trial") +
  scale_y_continuous(name = "Absolute Error (ms)") +
  facet_wrap(~target, ncol=1)+
  labs(fill = "Group", col="Group")+
  theme(axis.text=element_text(size=16, color="black"), 
        legend.text=element_text(size=16, color="black"),
        legend.title=element_text(size=16, face="bold"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=16, face="bold"),
        legend.position = "top")

ggplot(ACQ, aes(x = trial_total, y = absolute_error)) +
  geom_point(aes(fill=group), shape=21, size=1, alpha=0.3)+
  stat_smooth(aes(group=group, lty=group), col="black", fill="white",
              method="loess", lwd=1, se=TRUE)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+  
  scale_x_continuous(name = "Trial") +
  scale_y_continuous(name = "Absolute Error (ms)") +
  facet_grid(~group+target)+
  labs(fill = "Group", lty="Group")+
  theme(axis.text.x = element_text(size=10, color="black"),
        axis.text.y=element_text(size=14, color="black"), 
        legend.text=element_text(size=14, color="black"),
        legend.title=element_text(size=14, face="bold"),
        axis.title=element_text(size=14, face="bold"),
        plot.title=element_text(size=14, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=14, face="bold"),
        legend.position = "none")


head(ACQ_AVE)

ACQ_BLOCK_AVE<-ACQ %>%
  group_by(subID, group, block, target) %>%
  summarise(CE = mean(constant_error, na.rm=TRUE),
            AE = mean(absolute_error, na.rm=TRUE))

head(ACQ_BLOCK_AVE)
head(ACQ_GROUP_AVE)

ggplot(ACQ_BLOCK_AVE, aes(x = block, y = AE)) +
  geom_point(aes(fill=group), col="black", 
             shape=21, size=2, alpha=0.5)+
  #geom_line(aes(group=subID), size=1, alpha=0.5)+
  geom_line(data=ACQ_GROUP_AVE, aes(col=group), lwd=1)+
  geom_point(data=ACQ_GROUP_AVE, aes(fill=group),
             col="black", shape=21, size=5, alpha=0.5)+
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+
  scale_x_continuous(name = "Block", breaks=c(1,2,3)) +
  scale_y_continuous(name = "Absolute Error (ms)") +
  facet_grid(~target)+
  labs(fill = "Group", col="Group")+
  theme(axis.text.x = element_text(size=14, color="black"),
        axis.text.y=element_text(size=14, color="black"), 
        legend.text=element_text(size=14, color="black"),
        legend.title=element_text(size=14, face="bold"),
        axis.title=element_text(size=14, face="bold"),
        plot.title=element_text(size=14, face="bold", hjust=0.5),
        panel.grid.minor = element_blank(),
        strip.text = element_text(size=14, face="bold"),
        legend.position = "top")


