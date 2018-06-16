setwd(dir = 'D:/京剧/test/')
jm<-read.csv('jm.csv',header = T,stringsAsFactors = F)
jm<-as.data.frame(jm)
jm<-jm[,-24];bs<-as.matrix(jm[,2:23])
s<-as.data.frame(apply(bs,2,sum));s$bans<-rownames(s);
s<-s[order(-s[,1]),]
library(ggplot2)
myLabel = as.vector(v$Var1)   
myLabel = paste(myLabel, "(", round(v$Freq/sum(v$Freq)*100,2),"%)", sep = "")
p = ggplot(s, aes(x = reorder(bans,-s), y = s, fill = bans)) + 
  geom_bar(stat = "identity", width = 1)+
  xlab("板式")+ylab("数目")+guides(fill=F)+
  ggtitle("463出剧目板式频数分布图")+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(axis.text.x = element_text(angle = 90))
p
#canculator the cor 
library(corrplot)
corr_eh<-cor(jm[,2:22])
corrplot(corr = corr_eh,cl.ratio=0.2, cl.align="r",tl.cex=0.7,mar=c(1,4,1,2))
