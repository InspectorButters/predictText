#Set working directory
setwd("C:/Users/Bob/Desktop/R & Git/Projects/textPrediction")

#Download and unzip file; files are large and this step may take several minutes
dataURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(dataURL, destfile = "./Swiftkey.zip")
unzip("./Swiftkey.zip")

#Files are unzipped into child directly named "final", and include blogs, news and twitter
#documents in German, English, Finnish and Russian. We will use only the English version.

unlink("./final/de_DE", recursive = TRUE)     #delete German files
unlink("./final/fi_FI", recursive = TRUE)     #delete Finnish files
unlink("./final/ru_RU", recursive = TRUE)     #delete Russian files

#To simplify Corpus construction, move all 3 english files up to the "final" folder

file.rename(from = "./final/en_US/en_US.blogs.txt",
            to = "./final/en_US.blogs.txt")
file.rename(from = "./final/en_US/en_US.news.txt",
            to = "./final/en_US.news.txt")
file.rename(from = "./final/en_US/en_US.twitter.txt",
            to = "./final/en_US.twitter.txt")

#Furthur housekeeping: delete the now-empty en_US directory and the unzipped file

unlink("./final/en_US", recursive = TRUE)
unlink("./Swiftkey.zip", recursive = TRUE)


#Read the three English files (Blogs, News and Twitter) into R. To overcome the difficulty
#with missing EOLs in the news file, we read into R using a connection.  For consistency,
#this method is applied to the other two files (blogs and twitter) as well.

con <- file("./final/en_US.blogs.txt", open = 'rb')
blogs <- readLines(con, skipNul = TRUE)
close(con)

con <- file("./final/en_US.news.txt", open = 'rb')
news <- readLines(con, skipNul = TRUE)
close(con)

con <- file("./final/en_US.twitter.txt", open = 'rb')
twitter <- readLines(con, skipNul = TRUE)
close(con)


#Examine and summarize the data 

library(stringi)

blogs.size <- file.info("./final/en_US.blogs.txt")$size / 1000000       #size in MBs
news.size <- file.info("./final/en_US.news.txt")$size / 1000000         #size in MBs
twitter.size <- file.info("./final/en_US.twitter.txt")$size / 1000000   #size in MBs

blogs.words <- stri_count_words(blogs)
news.words <- stri_count_words(news)
twitter.words <- stri_count_words(twitter)

data.frame(source = c("blogs", "news", "twitter"),
           file.size.MB = c(blogs.size, news.size, twitter.size),
           num.lines = c(length(blogs), length(news), length(twitter)),
           num.words = c(sum(blogs.words), sum(news.words), sum(twitter.words)),
           mean.num.words = c(mean(blogs.words), mean(news.words), mean(twitter.words)))

#source file.size.MB num.lines num.words mean.num.words
#1   blogs     210.1600    899288  37546246       41.75108
#2    news     204.8015   1010241  34762373       34.40998
#3 twitter     167.1053   2360148  30093410       12.75065




#Data Cleaning

library(tm)             #load text mining (tm) package

sampSize <- 0.0025        #set % sample size

data.sample <- c(sample(blogs, length(blogs) * sampSize),
                 sample(news, length(news) * sampSize),
                 sample(twitter, length(twitter) * sampSize))

corpus <- VCorpus(VectorSource(data.sample))

toSpace <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
corpus <- tm_map(corpus, toSpace, "(f|ht)tp(s?)://(.*)[.][a-z]+")   #remove URLs
corpus <- tm_map(corpus, toSpace, "@[^\\s]+")                       #remove special chars

corpus <- tm_map(corpus, content_transformer(tolower))              #all lowercase


corpus <- tm_map(corpus, removeWords, stopwords("en"))              #e.g., "a", "the", etc.
corpus <- tm_map(corpus, removePunctuation)                         #remove punctuation
corpus <- tm_map(corpus, removeNumbers)                             #remove numbers
corpus <- tm_map(corpus, stripWhitespace)                           #no excess white space
corpus <- tm_map(corpus, PlainTextDocument)                         #create plain text doc


#Exploratory Analysis

library(RWeka)
library(ggplot2)

options(mc.cores=1)

getFreq <- function(tdm) {
  freq <- sort(rowSums(as.matrix(tdm)), decreasing = TRUE)
  return(data.frame(word = names(freq), freq = freq))
}

bigram <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigram <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))

makePlot <- function(data, label) {
  ggplot(data[1:30,], aes(reorder(word, -freq), freq)) +
    labs(x = label, y = "Frequency") +
    theme(axis.text.x = element_text(angle = 60, size = 12, hjust = 1)) +
    geom_bar(stat = "identity", fill = I("grey50"))
}

freq1 <- getFreq(removeSparseTerms(TermDocumentMatrix(corpus), 0.9999))
freq2 <- getFreq(removeSparseTerms(TermDocumentMatrix(corpus, control = list(tokenize = bigram)), 0.9999))
freq3 <- getFreq(removeSparseTerms(TermDocumentMatrix(corpus, control = list(tokenize = trigram)), 0.9999))


makePlot(freq1, "30 Most Common Unigrams")
makePlot(freq2, "30 Most Common Bigrams")
makePlot(freq3, "30 Most Common Trigrams")

