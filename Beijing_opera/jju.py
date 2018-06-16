# -*- coding: utf-8 -*-
"""
Created on Fri May 26 23:13:31 2017

@author: zyl91
"""

import os
import pandas as pd
import numpy as np
path="D:\\京剧\\test"
os.chdir("D:\\京剧\\test")
files= os.listdir(path)#file is a list object
eh=['二黄原板','二黄慢板','二黄导板','二黄散板','二黄摇板','二黄平板']
feh=['反二黄原板','反二黄慢板','反二黄导板','反二黄散板','反二黄摇板']
xp=['西皮原板','西皮慢板','西皮导板','西皮散板','西皮摇板','西皮快三眼','西皮二六','西皮流水','西皮快板']
fxp=['反西皮二六','反西皮散板','反西皮摇板']
banshi=eh+feh+xp+fxp
files[3].split('_')[1][:-4]
test=open('01005014.txt')
str=test.read()
col=['剧目']+banshi
all=pd.DataFrame(columns=col)
i=0
#jum=test.readline().split('（')[0]
#str.count(banshi[1])
for file in files:  
     if not os.path.isdir(file): #判断是否是文件夹，不是文件夹才打开  
          f = open(file); #打开文件  
          jum=f.readline().split('（')[0].replace('中国京剧戏考','')
          all.loc[i,'剧目']=jum
          str=f.read()
          for j in range(len(banshi)-1):
              all.loc[i,banshi[j]]=str.count(banshi[j])
     i=i+1
all.to_csv('jm.csv',index=False,sep=',')
