# -*- coding: utf-8 -*-
"""
Created on Sat May 27 09:46:08 2017

@author: zyl91
"""
import os
import urllib.request
from urllib.request import urlopen,quote
from bs4 import BeautifulSoup
from urllib.error import HTTPError
from pandas import Series, DataFrame
import pandas as pd 
os.chdir("D:\\京剧\\history")
#define the function of crawling(downloading the html file of the website )
def download(url,user_agent="wswp",num_retries=2):
	print('Downloading:',url)
	headers = {'User-agent': user_agent}
	request =urllib.request.Request(url,headers=headers)
	try:
		html = urlopen(request).read()
	except HTTPError as e :
		print('Downloading error:',e.reason)
		html=None
		if num_retries > 0 :
			if hasattr(e,'code') and 500 <= e.code <600:
				return download(url,user_agent,num_retries-1)
	return BeautifulSoup(html,"lxml")

born=list();deathdate=list();role_b=list();name_b=list();role_d=list();name_d=list()
yue=['正','二','三','四','五','六','七','八','九','十','冬','腊','闰正','闰二','闰三','闰四','闰五','闰六','闰七','闰八','闰九','闰十','闰冬']
for y in yue:
    opera="http://history.xikao.com/history/lunar/%s" % quote(y)
    operaB=download(opera)
    article=operaB.findAll(id="article")
    brith=operaB.table.find_all("tr",recursive=False)[1].find_all("td",recursive=False)[0].ul
    if brith is None:
        print('此处无记录\n')
    else:
            brith=brith.find_all("li",recursive=False)
            for i in range(len(brith)-1) :
                unit=brith[i].get_text()
                if len(unit.split('：')[1].split('，')) < 2:#判断如果没有人物的职业介绍，则跳过，不采集这条记录
                      continue
                else:
                     born.append(int(unit.split('：')[0].split('，')[0].replace('年','')))
                     name_b.append(unit.split('：')[1].split('，')[0])
                     role_b.append(unit.split('：')[1].split('，')[1].split('、')[0])#only the first role
                            
    death=operaB.table.find_all("tr",recursive=False)[1].find_all("td",recursive=False)[1].ul
    if death is None:
        print('此处无记录\n')
    else:
        death=death.find_all("li",recursive=False)
        for i in range(len(death)-1) :
            unit=death[i].get_text()
            if len(unit.split('：')[1].split('，')) < 2:#判断如果没有人物的职业介绍，则跳过，不采集这条记录
                 continue
            else:
                 deathdate.append(int(unit.split('：')[0].split('，')[0].replace('年','')))
                 name_d.append(unit.split('：')[1].split('，')[0])
                 role_d.append(unit.split('：')[1].split('，')[1].split('、')[0])#only the first role        
    #提取人物的信息
brith_data={'born':born,'name':name_b,'role':role_b}
death_data={'death':deathdate,'name':name_d,'role':role_d}
bdata=DataFrame(brith_data)
ddata=DataFrame(death_data)
bio=pd.merge(bdata,ddata,on="name")
del bio['role_y']
bdata.to_csv('bdata.csv',index=False,sep=',');ddata.to_csv('ddata.csv',index=False,sep=',');bio.to_csv('bio.csv',index=False,sep=',')
#mm.to_csv(path_or_buf='/home/zyl/文档/ycs_final.csv',sep=',')
