##################################################################################
# Date:  Sat Jun 16 2018
# Author: Yuliang Zhang
# E-mail: zyl@genetics.ac.cn
# Permission given to modify the code as long as you keep this
# declaration at the top
##################################################################################
library(magrittr)
library(tidyverse)

CBDB <- src_sqlite('M:/CBDB/20170424.db',create = F)

######################################
# extract some database (may needed) #
######################################


dynasty <- tbl(CBDB,"DYNASTIES") %>% as.tibble()
biog_main <- tbl(CBDB,"BIOG_MAIN") %>% as.tibble()
kinship_code <- tbl(CBDB,"KINSHIP_CODES") %>% as.tibble()
kin_data <- tbl(CBDB,"KIN_DATA") %>% as.tibble()

# retrieve the tang and shui dynasty data
tang_biog <- biog_main[biog_main$c_dy == 6,]
shui_biog <- biog_main[biog_main$c_dy == 5,]

#tang_biog[tang_biog$c_surname == 'Li',]

###################################################################
# I think remove the data without particular source will be better#
###################################################################

# Section one: data clean                                                        #
#                                                                                #
##################################################################################

####### keep the data with reliable source
kin_data_clean <- kin_data %>% drop_na(c_source) %>% filter(c_source != 0)

###### keep the people of tang dynasty (and maybe someone's partents are in shui dynasty,aslo keep them)

tang_kin <- kin_data_clean[kin_data_clean$c_personid %in% tang_biog$c_personid | kin_data_clean$c_personid %in% shui_biog$c_personid,]

tang_kin_rela <- tang_kin[tang_kin$c_kin_code %in% c(75,111),]# code_75:father code_111:mother

############ OK,OK I surrender, there are still some people with multiple partent

tang_kin_rela %<>% group_by(c_kin_id) %>% mutate(freq = n()) %>% arrange(desc(freq)) %>% ungroup()

tang_ped <- tang_kin_rela %>% select(c_personid,c_kin_id,
                           c_kin_code,freq) %>% distinct(c_personid,c_kin_code,.keep_all = T) %>% spread(key = c_kin_code,
                           value = c_kin_id) %>% select(c_personid,`75`,`111`)%>% `colnames<-`(c('child','father','mother'))

# Section 2:  mining some interesting result                                     #
#                                                                                #
##################################################################################

complete_families <- tang_ped %>% drop_na() 

### I am consider choose some sub-population to calculate the identify coefficients
identity::identity.coefs()

######################### TO BE CONTINUE ..........................