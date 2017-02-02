# ---
#   title: "R Notebook"
# author: "Ziwei Meng"
# date: "2017-01-31"
# output: html_notebook
# ---
#   # <!--Set environment and load pre-processed docs-->
#   # ```{r message=FALSE, warning=FALSE,echo=FALSE}
# library(tm)
# library(dplyr)
# #library(syuzhet)
# #library(qdap)
# load('../output/stemDocs.RData')
# #load('../output/lda10topics.RData')
# load('../output/sentenceList.RData')
# load('../output/speechList.RData')
# #sentence.list <- tbl_df(sentence.list)
# #speech.list <- tbl_df(speech.list)
# unemplyGDP <- tbl_df(read.csv('../output/uneplyGDP.csv'))
# unemplyGDP$Date <- as.Date(unemplyGDP$Date)
# #speech.list$Date <- as.Date(read.csv('../output/indexDate.csv')$Date)
# #save(speech.list,file = '../output/speechList.RData')
# 
# 
# folder.path <- "../data/fulltext/"
# filenames <- list.files(path = folder.path, pattern = "*.txt")
# dtm <- DocumentTermMatrix(docs,control = list(weighting = function(x)
#   weightTfIdf(x,normalize =FALSE),stopwords = TRUE))
# #dtm=tidy(dtm)
# #rownames(dtm) <- filenames
# 
# word_freq <- read.csv('../output/word_freq.csv')
# word_freq <- tbl_df(word_freq)
# colnames(word_freq) <- c("word","freq")
# 
# # docs_topics <- read.csv('../output/LDAGibbs10DocsToTopics.csv')
# # docs_topics <- tbl_df(docs_topics)
# # topic_terms <- read.csv("../output/LDAGibbs10TopicsToTerms.csv")
# # topic_terms <- tbl_df(topic_terms)
# # topic_pr <- read.csv("../output/LDAGibbs10TopicProbabilities.csv")
# # topic_pr <- tbl_df(topic_pr)
# # t1_t2 <- read.csv("../output/LDAGibbs10Topic1ToTopic2.csv")
# # t1_t2 <- tbl_df(t1_t2)
# # t2_t3 <- read.csv("../output/LDAGibbs10Topic2ToTopic3.csv")
# # t2_t3 <- tbl_df(t2_t3)
# 
# # speech_index <- read.csv('../output/speechIndex.csv')
# # speech_index <- tbl_df(speech_index)
# # speech_index <- speech_index%>%select(File:Date)
# # speech.list$Date <- speech_index$Date
# # sentence.list=NULL
# # for(i in 1:nrow(speech.list)){
# #  sentences=sent_detect(speech.list$fulltext[i],
# #                        endmarks = c("?", ".", "!", "|",";"))
# #  if(length(sentences)>0){
# #    emotions=get_nrc_sentiment(sentences)
# #    word.count=word_count(sentences)
# #    # colnames(emotions)=paste0("emo.", colnames(emotions))
# #    # in case the word counts are zeros?
# #    emotions=diag(1/(word.count+0.01))%*%as.matrix(emotions)
# #    sentence.list=rbind(sentence.list,
# #                        cbind(speech.list[i,-ncol(speech.list)],
# #                              sentences=as.character(sentences),
# #                              word.count,
# #                              emotions,
# #                              sent.id=1:length(sentences)
# #                              )
# #   )
# #  }
# # }
# # sentence.list <- tbl_df(sentence.list)
# # #save(speech.list,file = '../output/speechList.RData')
# # save(sentence.list,file = '../output/sentenceList.RData')
# # ```
# # ## Republican presidents v.s. Democratic presidents
# # A baseline for most popular words among US presidents.
# # ```{r echo=FALSE}
# library(ggplot2)
# p <- ggplot(subset(word_freq,freq>765),aes(word,freq))
# p <- p + geom_bar(stat = "identity")
# p <- p + theme(axis.text.x = element_text(angle = 45,hjust = 1))
# p
# # ```
# 
# A contrast for what Republican presidents care and what Democratic presidents care.
# ```{r echo=FALSE}
# library(wordcloud)
# library(RColorBrewer)
# library(tidytext)
# #library(shiny)
# repb_terms <- tidy(colMeans(tbl_df(as.matrix(dtm))[speech.list$Party=='Republican',]%>%na.omit()))
# demc_terms <- tidy(colMeans(tbl_df(as.matrix(dtm))[speech.list$Party=='Democratic',]%>%na.omit()))
# 
# par(mfrow=c(1,2), mar = c(0, 0, 3, 0))
# wordcloud(repb_terms$names, 
#           repb_terms$x,
#           scale=c(4,0.5),
#           max.words=50,
#           min.freq=1,
#           random.order=FALSE,
#           rot.per=0,
#           use.r.layout=FALSE,
#           random.color=FALSE,
#           colors=brewer.pal(9,"Blues"))
# wordcloud(demc_terms$names, 
#           demc_terms$x,
#           scale=c(4,0.5),
#           max.words=50,
#           min.freq=1,
#           random.order=FALSE,
#           rot.per=0,
#           use.r.layout=FALSE,
#           random.color=FALSE,
#           colors=brewer.pal(9,"Blues"))
# ```
# Okay, we see Democrats care about tariff and Republicans care about job and...wait, Hillary? I suspect there is a thing with Trump and let's see what happens when we remove Trump for time being.
# ```{r echo=FALSE}
# repb_terms_noTrump <- tidy(colMeans(tbl_df(as.matrix(dtm))[(speech.list$Party=='Republican')&(speech.list$File!="DonaldJTrump"),]%>%na.omit()))
# 
# par(mfrow=c(1,2), mar = c(0, 0, 3, 0))
# wordcloud(repb_terms_noTrump$names, 
# repb_terms_noTrump$x,
# scale=c(4,0.5),
# max.words=50,
# min.freq=1,
# random.order=FALSE,
# rot.per=0,
# use.r.layout=FALSE,
# random.color=FALSE,
# colors=brewer.pal(9,"Blues"))
# wordcloud(demc_terms$names, 
# demc_terms$x,
# scale=c(4,0.5),
# max.words=50,
# min.freq=1,
# random.order=FALSE,
# rot.per=0,
# use.r.layout=FALSE,
# random.color=FALSE,
# colors=brewer.pal(9,"Blues"))
# ```
# Now when we removed Trump we also got out of Hillary and Obama in the Republican word cloud.
# We see that both parties share some key words like American, job, tax and family, and I wonder what's their difference? 
# ```{r echo=FALSE}
# #repb <- colMeans(tbl_df(as.matrix(dtm))[(speech.list$Party=='Republican')&(speech.list$File!='DonaldJTrump'),]%>%na.omit())
# repb <- colMeans(tbl_df(as.matrix(dtm))[(speech.list$Party=='Republican'),]%>%na.omit())
# demc <- colMeans(tbl_df(as.matrix(dtm))[(speech.list$Party=='Democratic'),]%>%na.omit())
# repb_careMore <- tidy(repb-demc+10)
# demc_careMore <- tidy(demc-repb+10)
# par(mfrow=c(1,2), mar = c(0, 0, 3, 0))
# wordcloud(repb_careMore$names, 
#           repb_careMore$x,
#           scale=c(4,0.5),
#           max.words=50,
#           min.freq=1,
#           random.order=FALSE,
#           rot.per=0,
#           use.r.layout=FALSE,
#           random.color=FALSE,
#           colors=brewer.pal(9,"Blues"))
# wordcloud(demc_careMore$names, 
#           demc_careMore$x,
#           scale=c(4,0.5),
#           max.words=50,
#           min.freq=1,
#           random.order=FALSE,
#           rot.per=0,
#           use.r.layout=FALSE,
#           random.color=FALSE,
#           colors=brewer.pal(9,"Blues"))
# ```
# However both parties care jobs, it seems Republicans even more care it, and Democrats really have a thing with revenue and tariff.
# Presidents who mentioned tariff most are,
# ```{r echo=FALSE}
# speech.list$President[order(as.matrix(dtm[,'tariff']),decreasing = TRUE)[1:5]]
# ```
# 4 of first 5 are Democrats, and Presidents who mentioned job most are,
# ```{r echo=FALSE}
# speech.list$President[order(as.matrix(dtm[,'job']),decreasing = TRUE)[1:5]]
# ```
# 3 of first 5 are Republicans.
# 
# ## How words frequency reflect reality
# 
# Now I'm wondering whether those speeches reflecting some trends in US big picture. For example, will presidents address more on jobs when the unemployment high? Or focus on economy when GDP growth low? Let's first show some key words trends.
# ```{r echo=FALSE}
# library(scales)
# #library(reshape2)
# speech.list$Job <- as.matrix(dtm[,'job'])
# speech.list$Economy <- as.matrix(dtm[,'econom'])
# speech.list$Date <- as.Date(speech.list$Date,"%Y-%m-%d")
# #multisers <- melt(speech.list%>%filter(Date>as.Date("1948-1-1"))%>%select(Date,Economy,Job),id="Date")
# #ggplot(multisers, aes(Date, value,colour=variable)) + geom_line() +
# #  scale_x_date(labels = date_format("%Y-%m")) + xlab("") + ylab("Word Trend")
# word.reflect <- speech.list%>%filter((Date>as.Date("1952-1-1"))&(Date<as.Date("2017-1-1"))&(type=="nomin"))%>%select(Date,Job,Economy)%>%inner_join(unemplyGDP)
# p <- ggplot() + 
#   geom_line(data = word.reflect%>%select(Date,Job), aes(x = Date, y = Job, color = "Job")) +
#   geom_line(data = word.reflect%>%select(Date,Economy), aes(x = Date, y = Economy, color = "Economy")) +
#   geom_line(data = word.reflect%>%select(Date,Unemployment), aes(x = Date, y = Unemployment, color = "Unemployment")) +
#   geom_line(data = word.reflect%>%select(Date,GDPperc), aes(x = Date, y = GDPperc, color = "GDPgrowth")) +
#   # geom_line(data = speech.list%>%filter((Date>as.Date("1952-1-1"))&(Date<as.Date("2017-1-1")))%>%select(Date,Job), aes(x = Date, y = Job, color = "Job")) +
#   # geom_line(data = speech.list%>%filter((Date>as.Date("1952-1-1"))&(Date<as.Date("2017-1-1")))%>%select(Date,Economy), aes(x = Date, y = Economy, color = "Economy"))  +
#   # geom_line(data = unemplyGDP, aes(x = Date, y = Unemployment, color = "Unemployment"))  +
#   # geom_line(data = unemplyGDP, aes(x = Date, y = GDPperc, color = "GDP growth percent"))  +
#   xlab('') +
#   ylab('Word Trends')
# p
# ```
# We can see that frequencies of "economy" seems associated with GDP growth percent but the association between "job" and unemplotment is not clear. To test our hypothesis we calculated the correlation between each pair.
# ```{r echo=FALSE}
# #library(matrixStats)
# #library(corrplot)
# #library(psychometric)
# # job_trend <- speech.list%>%filter((Date>as.Date("1952-1-1"))&(Date<as.Date("2017-1-1")))%>%select(Job)
# # economy_trend <- speech.list%>%filter((Date>as.Date("1952-1-1"))&(Date<as.Date("2017-1-1")))%>%select(Economy)
# # unemployment_trend <- as.data.frame(unemplyGDP$Unemployment) 
# # GDPgrw_trend <- as.data.frame(unemplyGDP$GDPperc)
# # word.reflect <- speech.list%>%filter((Date>as.Date("1952-1-1"))&(Date<as.Date("2017-1-1"))&(type=="inaug"))%>%select(Date,Job,Economy)%>%inner_join(unemplyGDP)
# word.reflect$higherUnemployment <- as.factor(word.reflect$Unemployment>median(word.reflect$Unemployment))
# word.reflect$higherGDP <- as.factor(word.reflect$GDPperc>median(word.reflect$GDPperc))
# #how GDP influent word frequency
# GDP.influence <- word.reflect%>%select(Job,Economy,higherGDP,higherUnemployment)%>%group_by(higherGDP)%>%summarise(meanJobFreq=mean(Job),meanEconomyFreq=mean(Economy))
# # pairwise.t.test(word.reflect$Job,word.reflect$higherGDP,pool.sd = TRUE,p.adjust.method = "bonf")$p.value
# # pairwise.t.test(word.reflect$Economy,word.reflect$higherGDP,pool.sd = TRUE,p.adjust.method = "bonf")$p.value
# #how unemployment influent word frequency
# unemployment.influence <- word.reflect%>%select(Job,Economy,higherGDP,higherUnemployment)%>%group_by(higherUnemployment)%>%summarise(meanJobFreq=mean(Job),meanEconomyFreq=mean(Economy))
# # pairwise.t.test(word.reflect$Job,word.reflect$higherUnemployment,pool.sd = TRUE,p.adjust.method = "bonf")$p.value
# # pairwise.t.test(word.reflect$Economy,word.reflect$higherUnemployment,pool.sd = TRUE,p.adjust.method = "bonf")$p.value
# 
# p_table <- as.data.frame(list(unemployment=c(pairwise.t.test(word.reflect$Job,word.reflect$higherUnemployment,pool.sd = TRUE,p.adjust.method = "bonf")$p.value,pairwise.t.test(word.reflect$Economy,word.reflect$higherUnemployment,pool.sd = TRUE,p.adjust.method = "bonf")$p.value),GDPgrowth=c(pairwise.t.test(word.reflect$Job,word.reflect$higherGDP,pool.sd = TRUE,p.adjust.method = "bonf")$p.value,pairwise.t.test(word.reflect$Economy,word.reflect$higherGDP,pool.sd = TRUE,p.adjust.method = "bonf")$p.value)))
# rownames(p_table) <- c('job','economy')
# p_table
# # cor_table <- as.data.frame(list(unemployment=c(cor(job_trend,unemployment_trend),cor(economy_trend,unemployment_trend)),GDPgrowth=c(cor(job_trend,GDPgrw_trend),cor(economy_trend,GDPgrw_trend))))
# # cor_table <- round(cor_table,digits = 2)
# # rownames(cor_table) <- c('job','economy')
# # cor_table
# # job_trend <- sapply(job_trend,as.numeric)
# # economy_trend <- sapply(economy_trend,as.numeric)
# # unemployment_trend <- sapply(unemployment_trend,as.numeric)
# # GDPgrw_trend <- sapply(GDPgrw_trend,as.numeric)
# # cor_p_table <- as.data.frame(list(unemployment=c(cor.test(job_trend,unemployment_trend)$p.value,cor.test(economy_trend,unemployment_trend)$p.value),GDPgrowth=c(cor.test(job_trend,GDPgrw_trend)$p.value,cor.test(economy_trend,GDPgrw_trend)$p.value)))
# # cor_p_table <- round(cor_p_table,digits = 2)
# # rownames(cor_p_table) <- c('job','economy')
# # cor_p_table
# #CIr(r=cor_table[1,1],n=62,level = .95)
# # corrplot(cor(job_trend,unemployment_trend), type="upper", order="hclust", tl.col="black", tl.srt=45)
# # par(mfrow=c(2,2))
# # ccf(job_trend,unemployment_trend)
# # ccf(economy_trend,unemployment_trend)
# # ccf(job_trend,GDPgrw_trend)
# # ccf(economy_trend,GDPgrw_trend)
# ```
# We can see word frequency of "job" is nearly "independent"" of unemployment or GDP growth percentage, however frequency of "economy" does have a mild positive association with unemployment and a negative one with GDP growth. In other words, when presidents address on "economy", there may be something wrong underlying the true economy.
# 
# <!-- And the economy environment can reflect not only in choosing specific words, but also in their mood. Let's take a look at sentiment trends against GDP growth. -->
# <!-- ```{r} -->
# <!-- positive_trend <- sentence.list%>%group_by(Date)%>%summarise(positive=mean(positive))%>%na.omit() -->
# <!-- positive_trend$Date <- as.Date(positive_trend$Date) -->
# <!-- p <- ggplot() + -->
# <!--   geom_line(data = positive_trend%>%filter((Date>as.Date("1952-1-1"))&(Date<as.Date("2017-1-1"))), aes(x = Date, y = scale(positive), color = "positive"))   + -->
# <!--   geom_line(data = unemplyGDP, aes(x = Date, y = scale(Unemployment), color = "Unemployment"))  + -->
# <!--   geom_line(data = unemplyGDP, aes(x = Date, y = scale(GDPperc), color = "GDP growth percent"))  + -->
# <!--   xlab('') + -->
# <!--   ylab('Sentiment Trends') -->
# <!-- p -->
# <!-- pos_trend <- positive_trend%>%filter((Date>as.Date("1952-1-1"))&(Date<as.Date("2017-1-1"))) -->
# <!-- cor_row <- pos_trend%>%inner_join(unemplyGDP) -->
# <!-- cor_row <- as.data.frame(list(unemplotment=cor(cor_row$positive,cor_row$Unemployment),GDPgrowth=cor(cor_row$positive,cor_row$GDPperc))) -->
# <!-- rownames(cor_row) <- c("sentiment") -->
# <!-- cor_row -->
# <!-- ``` -->
# 
# 
# ## Are presidents happier when at inauguration?
# 
# Finally, let's compare presidents' moods between inaugural and farewell. Will they be happier  when becoming the most powerful man, or more released when say good-bye?
# ![](../data/trump-vs-obama-two-types-of-men.jpg)
# ```{r echo=FALSE}
# mood_type <- sentence.list%>%filter(type!='speeches')%>%select(type,positive)%>%na.omit()
# mood_mean <- mood_type%>%group_by(type)%>%summarise(meanPositive=mean(positive))%>%arrange(desc(meanPositive))
# #mood_type <- sentence.list%>%filter(type!='speeches')%>%select(type,joy)%>%na.omit()%>%group_by(type)%>%summarise(goodMood=mean(joy))%>%arrange(desc(goodMood))
# mood_mean$meanPositive <- round(mood_mean$meanPositive,digits = 2)
# mood_mean
# mood_type$type <- as.factor(mood_type$type)
# pairwise.t.test(mood_type$positive,mood_type$type,pool.sd = TRUE,p.adjust.method = "bonf")
# ```
# It seems that a president is happiest at inaugural, then at farewell, least positive at nomination, maybe due to the uncertainty for the future.
# 
# 
# 
# 
# 
