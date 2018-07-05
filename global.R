#构建基于Spark的推荐引擎

#library(sparklyr)
library(dplyr)
library(RMySQL)
library(stringr)
library(REmap)
# sc <- spark_connect(master = "local")#连接到本地spark
# setwd("E:\\program\\R\\shiny\\base")
# rawdata<-read.table("./data/u.data",sep = "\t")
# col_rawdata_name<-c("userId","itemId","rating","timestamp")
# names(rawdata)<-col_rawdata_name

# head(rawdata)
# remove data from rdd
# 1.removetable
#sc%>%spark_session()%>%invoke("catalog")%>%invoke("dropTempView","u_item")
# 2.clearn cache
# sc%>%spark_session()%>%invoke("catalog")%>%invoke("clearCache")

#save to spark
#S_rawdata<-copy_to(sc,rawdata)
# qu qian 3 lie
# S_rawdata<-select(S_rawdata,userId,itemId,rating)
# explicit_model<-ml_als_factorization(S_rawdata,rating_col = "rating",user_col = "userId",item_col = "itemId")
# summary(explicit_model)
# 
# predictions<-explicit_model$.jobj %>% invoke("transform",spark_dataframe(S_rawdata_train))%>%collect()
# recommend<-ml_recommend(explicit_model,type = c("items","users"),n=5)

#数据处理
#E:\\program\\R\\shiny\\base
recommend<-read.csv("data/recommend.csv")#根据userID提取推荐的itemID
userdata<-read.csv("data/userdata.csv",header = TRUE,quote="",encoding = "UTF-8")#根据itemID选择图片名
all_item<-read.csv("data/all_item.csv",header = TRUE,encoding = "ANSI")
heapdata3<-read.csv("data/heapdata3.csv",header = TRUE)
class_names<-all_item$course_name
userdata_item<-userdata%>%select(X.itemid.)
userdata_item<-as.data.frame(table(userdata_item$X.itemid.))
userdata_item_freq<-(userdata_item%>%arrange(desc(Freq)))[1:60,1]
#data<-data[,-1]
#userID=108534
#picture_itemid<-recommend %>% filter(userid==userID)%>%select(itemid)
picture_itemid<-as.list(userdata_item_freq)
# picture_name<-userdata %>% filter(X.itemid.==picture_itemid$itemid)%>%select(X.Var1.)
# picture_name<-as.vector(unique(picture_name$X.Var1.))
# 
# picture_name<-str_sub(picture_name,2,-2)
# picture_name<-as.list(picture_name)
#itemtemp<-as.numeric(itemtemp)
Logged = FALSE;
# my_username <- "test"
# my_password <- "test"

con<-dbConnect(MySQL(),host='localhost',port=3306,dbname="elearn",user="root",password="1234")

ui1 <- function(){
  tagList(
    div(id = "login",class="login-box",p(class="login-box-msg","登录你的账户"),
        wellPanel(class="form-group has-feedback",textInput("userName", "Username",placeholder="number"),
                  passwordInput("passwd", "Password"),
                  br(),actionButton("Login", "Log in")))#,
    #tags$style(type="text/css", "#login {font-size:10px;   text-align: left;position:absolute;top: 40%;left: 50%;margin-top: -100px;margin-left: -150px;}")
  )}
#分类
categoryui<-function(x){
  fluidRow(
    column(12,id="columns",
          # itemid2<-all_item%>%filter(category==x)%>%select(itemid),
           lapply(x,function(i){#itemtemp数据类型
             a(box(width=NULL,
                   title = HTML(paste0("<div class='image-wrap'><img src='./images/all/",
                                       as.character(i),".jpg",#recipe.df$recipe.link ==
                                       "',class='img' ",
                                       # recipe.df$img.css[recipe.df$recipe.link == i],#recipe.df$recipe.link ==
                                       "'></div>",
                                       as.character(intro(i)),
                                       "<br>"))
                   
             )#box
             , href= as.character((all_item%>%filter(itemid==i)%>%select(course_link))$course_link[1]),target="view_window")#a
           })#lapply
           
    )# colum
  )# fluidrow
}

ui2 <- function(){tagList(tabPanel("Test"))}
ui = (htmlOutput("page"))

checkpassword <- function(id,pass){
  passwords<-dbGetQuery(con,paste("select password from users where userid=",paste0("'",id,"'")))
  if (is.na(passwords[1,1])){
    return(FALSE)
  }
  if(passwords[1,1]==pass){
    return(TRUE)
  }else{
    return(FALSE)
  }
}

intro<-function(i){
  introduce<-all_item%>%filter(itemid==i)%>%select(course_name)
  introduce<-unique(introduce)
  introduce<-as.character(introduce$course_name)
  #introduce<-str_sub(introduce,2,-2)
  return(introduce)
}

#分词
library(jiebaR)
library(wordcloud2)
engine<-worker(user = "data/jieba.utf8",stop_word="data/stop_words.utf8")
words<-userdata$X.Var1.
words<-as.character(words)
fen<-segment(words,engine)
fre<-freq(segment(words,engine)) %>% arrange(desc(freq))
#查找课程
searchcourse<-function(x){
  n <- NULL  
  for(i in 1:length(all_item$course_name))  
  {  
    if(grepl(x,all_item$course_name[i],ignore.case = TRUE)==TRUE){
      n<-c(n,i)
    }
  }
  return(n)
}