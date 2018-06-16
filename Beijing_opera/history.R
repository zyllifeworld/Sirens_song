setwd(dir = 'D:/京剧/history/')
brith<-read.csv('bdata.csv',header = T,stringsAsFactors = F)
death<-read.csv('ddata.csv',header = T,stringsAsFactors = F)
bio<-read.csv('bio.csv',header = T,stringsAsFactors = F)
library(stringr)
brith<-brith[str_detect(brith$role,"京剧"),]
death<-death[str_detect(death$role,"京剧"),]
bio<-bio[str_detect(bio$role_x,"京剧"),]
bio$age=bio$death-bio$born
library(dplyr)
all<-full_join(brith,death,by='name')
all$role.x[is.na(all$role.x)]<-all$role.y[is.na(all$role.x)]#role regiven
#barplot for all record
v = as.data.frame(ftable(all$role.x));v<-v[order(-v[,2]),]
v<-v[1:10,]
library(ggplot2)
myLabel = as.vector(v$Var1)   
myLabel = paste(myLabel, "(", round(v$Freq/sum(v$Freq)*100,2),"%)", sep = "")
p = ggplot(v, aes(x = reorder(Var1,-Freq), y = Freq, fill = Var1)) + 
  geom_bar(stat = "identity", width = 1)+
  xlab("行当")+ylab("人数")+guides(fill=F)+
  ggtitle("行当与有记载人数分布条形图")+
  theme(plot.title = element_text(hjust = 0.5))
p


