rm(list=ls())
#这一部分用来读入数据
ycs2016<-read.table("E:/data_yourself_data_the_world/博士生入学遗传所个人数据可视化/bsycs.txt",sep="\t",header=T,stringsAsFactor=F)
#这一部分用来绘制毕业前的生源地
home=c()
for (i in 1:dim(ycs2016)[[1]]) home =append(home,ycs2016$通讯地址[[i]])
library(baidumap)
home=getCoordinate(home, formatted=T)
home=na.omit(home)
plotdata=data.frame(lon=home[,1],
                    lat=home[,2],
                    city=ycs2016$姓名,
                    gender=ycs2016$类别)
library(leaflet)
#用来绘制上学前大家的位置
m<-leaflet(data = plotdata) %>% addTiles() %>%addCircleMarkers(~lon, ~lat,popup = ~city)
m
#用来绘制上学前大家的位置
leaflet(data = plotdataw) %>% addTiles() %>% addMarkers(~lon, ~lat, popup = ~city)
#用来绘制
m<-leaflet(plotdataw) %>% addTiles() %>% addMarkers(clusterOptions = markerClusterOptions()) %>% addMarkers(~lon, ~lat, popup = ~city)
#m<-m%>%addPolylines(lng=~lon,lat=~lat,data=plotdata,color = "white", weight = 2)
#m
m
