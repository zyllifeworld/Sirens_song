setwd("E:/data_yourself_data_the_world/data_world/ycspaper/R/")
ycsdata<-read.csv(file='ycsdata.txt',header = T,sep ='\t')
jninfor<-read.csv(file = 'JournalHomeGrid.csv',header = T,sep = ',')
library('dplyr')
jninfor$Full.Journal.Title<-toupper(jninfor$Full.Journal.Title)
test<-left_join(ycsdata,jninfor,by=c("journal" = "Full.Journal.Title"))
#sum(is.na(test$Journal.Impact.Factor))
ycs_1<-test[!is.na(test$Journal.Impact.Factor),]
ycs_1$Journal.Impact.Factor<-as.numeric(as.character(ycs_1$Journal.Impact.Factor))
#elimate the unmatched records
ycs_2<-summarise(group_by(ycs_1,Author,year),Number=n(),meanIF=mean(Journal.Impact.Factor)
                 ,medianIF=median(Journal.Impact.Factor),sdIF=sd(Journal.Impact.Factor))
ycs_3<-ycs_2[as.numeric(as.character(ycs_2$year))>=2010,]#selecet range from 2009-2017
PI<-summarise(group_by(ycs_3,Author),all=sum(Number))
PI<-arrange(PI,desc(all))
selePI<-PI$Author[PI$all>=15]
index<-is.element(ycs_3$Author,selePI);
ycs_good<-ycs_3[index,]
write.csv(ycs_good, file = "ycs_good.csv", row.names = F, quote = F)

journal<-summarise(group_by(ycsdata,journal,records),all=n())
journal_1<-summarise(group_by(journal,journal),all=n())
