#服务器端 userID=12http://spark.apache.org/
library(shiny)
Logged <-  FALSE
shinyServer(
  function(input,output){
    #source('login.R')
   #userId=12
   output$titles<-renderUI({
     fluidRow(
       column(12,id="columns",
              lapply(picture_itemid,function(i){#itemtemp数据类型
                a(box(width=NULL,
                      title = HTML(paste0("<div class='image-wrap'><img src='./images/all/",
                                          i,".jpg",#recipe.df$recipe.link ==
                                         "',class='img' ",
                                          # recipe.df$img.css[recipe.df$recipe.link == i],#recipe.df$recipe.link ==
                                          "'></div>",
                                         intro(i),
                                          "<br>"))

                )#box
                , href= as.character((all_item%>%filter(itemid==i)%>%select(course_link))$course_link[1]),target="view_window")#a
              })#lapply
              
              )# colum
     )# fluidrow
   }
   ) # output$tiles<-renderUI
   #登陆界面
   USER <- reactiveValues(Logged = Logged)
   
   observe({ 
     if (USER$Logged == FALSE) {
       if (!is.null(input$Login)) {
         if (input$Login > 0) {
           Username <<- isolate(input$userName)
           Password <- isolate(input$passwd)
           if(checkpassword(Username,Password)){
             USER$Logged <- TRUE
           }
           # Id.username <- which(my_username == Username)
           # Id.password <- which(my_password == Password)
           # if (length(Id.username) > 0 & length(Id.password) > 0) {
           #   if (Id.username == Id.password) {
           #     USER$Logged <- TRUE
           #   } 
           # }
         } 
       }
     }    
   })
   observe({
     if (USER$Logged == FALSE) {
       
       output$page <- renderUI({
         div(class="outer",do.call(bootstrapPage,c("",ui1())))
       })
     }
     if (USER$Logged == TRUE) 
     {
       output$page<-renderUI({
         x<-recommend%>%filter(userid==Username)%>%select(itemid)
         x<-as.list(x$itemid)
         categoryui(x)
       })
     }#if
   })
   #category
   output$office<-renderUI({
     itemid2<-all_item%>%filter(category=="office")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)
   } )
   output$exam<-renderUI({
     itemid2<-all_item%>%filter(category=="exam")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
   categoryui(itemid2)})
   output$language<-renderUI({
     itemid2<-all_item%>%filter(category=="language")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
      categoryui(itemid2)})
   output$construction<-renderUI({
     itemid2<-all_item%>%filter(category=="construction")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$financial<-renderUI({
     itemid2<-all_item%>%filter(category=="financial")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$job<-renderUI({
     itemid2<-all_item%>%filter(category=="job")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$management<-renderUI({
     itemid2<-all_item%>%filter(category=="management")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$medical<-renderUI({
     itemid2<-all_item%>%filter(category=="medical")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$computer<-renderUI({
     itemid2<-all_item%>%filter(category=="computer")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$socialscience<-renderUI({
     itemid2<-all_item%>%filter(category=="socialscience")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$life<-renderUI({
     itemid2<-all_item%>%filter(category=="life")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$software<-renderUI({
     itemid2<-all_item%>%filter(category=="software")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$culture<-renderUI({
     itemid2<-all_item%>%filter(category=="culture")%>%select(itemid)
     itemid2<-as.list(itemid2$itemid)
     categoryui(itemid2)})
   output$searchresult<-renderUI({
     searchnames<-input$searchText
     item<-searchcourse(searchnames)
     item<-all_item$itemid[item]
     categoryui(item)
   })
   #词云
   output$wordcloud2<-renderWordcloud2({
     wordcloud2(fre[1:100,])
   })
   # output$heapmap<-renderREmap({
   #   remapH(heapdata3,minAlpha = 0.5)
   # })
   }
)