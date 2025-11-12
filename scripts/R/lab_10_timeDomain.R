setwd("/Users/annaspracklin/Documents/GitHub/PhysTher5110/scripts/R")
sr = 30000 #Hz
data=read.table('spinalRecording.txt')

library(ggplot2)
library(tidyverse)
library(patchwork)
t = c(1:nrow(data))
t = t/sr

rectify <- function(x,type){ # hm coulda made that easier
  for (i in 1:length(x)){
    if (x[i]<0){
      if (type=="half"){
        x[i] = 0
      }
      else if (type=="full"){
        x[i] = abs(x[i])
      }
    }
  }
  return(x)
}

rectified_data <- rectify(data$V1, "full")

win = 0.1*sr
filtered_center <- stats::filter(rectified_data, filter = rep(1/win, win), method="convolution", sides = 2)
filtered_lag <- stats::filter(rectified_data, filter = rep(1/win, win), method="convolution",sides = 1)

win1 = 1*sr
filtered_center_win1 <- stats::filter(rectified_data, filter = rep(1/win1, win1), method="convolution",sides = 2)

df = data.frame(t,data,rectified_data,filtered_center,filtered_lag)

p1<-ggplot(data = df, aes(x=t, y=V1)
) + geom_line()

p2 <- ggplot(data=df, aes(x=t,y=rectified_data))+
  geom_line()

p3 <- ggplot(data=df, aes(x=t))+
  geom_line(aes(y=filtered_lag),color='blue')+
  geom_line(aes(y=filtered_center),color='red')+
  geom_line(aes(y=filtered_center_win1),color='pink')

p1/p2/p3

# Problem 2

acf(data, lag.max = 0.5,type = "correlation", plot = TRUE, na.action = na.fail, demean = TRUE)
SR2 = read.table('spinalRecording_chan2.txt')
ccf(data, SR2, lag.max = 0.5, type = "correlation", plot = TRUE, na.action = na.fail, demean=TRUE)
