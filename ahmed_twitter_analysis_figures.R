library(smappR)
library(pryr)
library(cowplot)
#Need to modify this function from SmappR, makes more sense to supply the mongo object
#also, it breaks with the combination of mongo3, or whatever  I was using

#kept getting the following error otherwise
#Error in count.tweets(set) : 
#  R couldn't find mongo object that connects to MongoDB in workspace.
#base code for count.tweets2 and extract.tweets comes from smappR
#only difference is that you feed in the mongo object

count.tweets2 <- function (mongo,set, string = NULL, retweets = NULL, hashtags = NULL, 
          from = NULL, to = NULL, user_id = NULL, screen_name = NULL, 
          verbose = TRUE) 
{

  query <- list()
  if (!is.null(string)) {
    if (length(string) > 1) {
      string <- paste(string, collapse = "|")
    }
    query <- c(query, list(text = list(`$regex` = string, 
                                       `$options` = "i")))
  }
  if (!is.null(user_id)) {
    if (length(user_id) == 1) {
      query <- c(query, list(user.id_str = as.character(user_id)))
    }
    if (length(user_id) > 1) {
      stop("Error! You can only query tweets sent from one user")
    }
  }
  if (!is.null(screen_name)) {
    if (length(screen_name) == 1) {
      query <- c(query, list(user.screen_name = list(`$regex` = paste0("^", 
                                                                       screen_name), `$options` = "i")))
    }
    if (length(screen_name) > 1) {
      stop("Error! You can only query tweets sent from one user")
    }
  }
  if (!is.null(retweets)) {
    if (retweets == TRUE) {
      query <- c(query, list(retweeted_status = list(`$exists` = TRUE)))
    }
    if (retweets == FALSE) {
      query <- c(query, list(retweeted_status = list(`$exists` = FALSE)))
    }
  }
  if (!is.null(hashtags)) {
    if (hashtags == TRUE) {
      query <- c(query, list(entities.hashtags.1 = list(`$exists` = TRUE)))
    }
    if (hashtags == FALSE) {
      query <- c(query, list(entities.hashtags.1 = list(`$exists` = FALSE)))
    }
  }
  if (!is.null(from)) {
    from.txt <- as.POSIXct(from, "%Y-%m-%d %H:%M:%S")
    query <- c(query, list(timestamp = list(`$gte` = from.txt)))
  }
  if (!is.null(to)) {
    to.txt <- as.POSIXct(to, "%Y-%m-%d %H:%M:%S")
    query <- c(query, list(timestamp = list(`$lt` = to.txt)))
  }
  if (length(query) == 0) 
    query <- mongo.bson.empty()
  n.tweets <- mongo.count(mongo, ns = set, query = query)
  if (verbose == TRUE) {
    cat(n.tweets, "tweets", "\n")
  }
  if (verbose == FALSE) {
    return(n.tweets)
  }
}

extract.tweets2 <- function (mongo, set, string = NULL, size = 0, fields = c("created_at", 
                                                   "user.screen_name", "text"), retweets = NULL, hashtags = NULL, 
          from = NULL, to = NULL, user_id = NULL, screen_name = NULL, 
          verbose = TRUE) 
{
  require(rmongodb)
  fields.arg <- fields
  query <- list()
  if (!is.null(from)) {
    from.txt <- as.POSIXct(from, "%Y-%m-%d %H:%M:%S", tz = "")
    query <- c(query, list(timestamp = list(`$gte` = from.txt)))
  }
  if (!is.null(to)) {
    to.txt <- as.POSIXct(to, "%Y-%m-%d %H:%M:%S", tz = "")
    query <- c(query, list(timestamp = list(`$lt` = to.txt)))
  }
  if (!is.null(string)) {
    if (length(string) > 1) {
      string <- paste(string, collapse = "|")
    }
    query <- c(query, list(text = list(`$regex` = string, 
                                       `$options` = "i")))
  }
  if (!is.null(user_id)) {
    if (length(user_id) == 1) {
      query <- c(query, list(user.id_str = as.character(user_id)))
    }
    if (length(user_id) > 1) {
      query <- c(query, list(user.id_str = list(`$in` = as.character(user_id))))
    }
  }
  if (!is.null(screen_name)) {
    if (length(screen_name) == 1) {
      query <- c(query, list(user.screen_name = list(`$regex` = paste0("^", 
                                                                       screen_name), `$options` = "i")))
    }
    if (length(screen_name) > 1) {
      stop("Error! You can only query tweets sent from one user with screen_name. User user_id instead.")
    }
  }
  if (size > 0 & size < 1) {
    seed <- runif(1, 0, 1 - size)
    query <- c(query, list(random_number = list(`$gte` = seed, 
                                                `$lte` = seed + size)))
  }
  if (size >= 1) {
    if (!is.null(string)) {
      n.tweets <- count.tweets2(mongo, set, string = string, verbose = FALSE)
    }
    if (is.null(string)) {
      n.tweets <- count.tweets2(mongo, set, verbose = FALSE)
    }
    p.diff <- (size/n.tweets)
    seed <- runif(1, 0, 1 - p.diff)
    query <- c(query, list(random_number = list(`$gte` = seed, 
                                                `$lte` = seed + p.diff + 0.01)))
  }
  if (!is.null(retweets)) {
    if (retweets == TRUE) {
      query <- c(query, list(retweeted_status = list(`$exists` = TRUE)))
    }
    if (retweets == FALSE) {
      query <- c(query, list(retweeted_status = list(`$exists` = FALSE)))
    }
  }
  if (!is.null(hashtags)) {
    if (hashtags == TRUE) {
      query <- c(query, list(entities.hashtags.1 = list(`$exists` = TRUE)))
    }
    if (hashtags == FALSE) {
      query <- c(query, list(entities.hashtags.1 = list(`$exists` = FALSE)))
    }
  }
  if (length(query) == 0) 
    query <- mongo.bson.empty()
  if (size == 0) {
    n <- mongo.count(mongo, ns = set, query = query)
    if (n == 0 | n == -1) {
      stop("Zero tweets match the specified conditions. Is the DB name correct?")
    }
  }
  if (size > 0 & size < 1) {
    n <- ceiling(size * mongo.count(mongo, ns = set, query = query))
  }
  if (size >= 1) {
    n <- size
  }
  out <- rep(NA, n)
  if (is.null(fields)) {
    fields <- mongo.bson.empty()
  }
  if (!is.null(fields)) {
    new.fields <- list()
    for (f in fields) {
      new.fields[f] <- 1L
    }
    fields <- new.fields
  }
  res <- mongo.find(mongo = mongo, ns = set, query = query, 
                    fields = fields)
  i <- 1
  if (verbose == TRUE) {
    pb <- txtProgressBar(min = 1, max = n, style = 3)
  }
  if (size < 1) {
    while (mongo.cursor.next(res)) {
      out[i] <- list(mongo.bson.to.list(mongo.cursor.value(res)))
      i <- i + 1
      if (verbose == TRUE) {
        setTxtProgressBar(pb, i)
      }
    }
  }
  if (size >= 1) {
    while (mongo.cursor.next(res) & i <= size) {
      out[i] <- list(mongo.bson.to.list(mongo.cursor.value(res)))
      i <- i + 1
      if (verbose == TRUE) {
        setTxtProgressBar(pb, i)
      }
    }
  }
  out <- smappR:::parseMongo(out, fields = fields.arg)
  class(out) <- "tweets"
  return(out)
}





#I have ?q
bs<-mongo.create(host="127.0.0.1:27016",db='bespoke')
set='bespoke.ahmed'
set2='bespoke.repub_primary'
set3='bespoke.dem_primary'
count.tweets2(bs,set)
count.tweets2(bs,set2)
count.tweets2(bs,set3)
# the keywords we filtered on the waterhose were 
#keywords<-c('IstandwithAhmed','Irving','Ahmed Mohammed','IrvingISD')
tweets<-extract.tweets2(bs,set)
df <- tweetsToDF(tweets) ## transforming to data frame
head(df)
df$created_at<-formatTwDate(df$created_at)

#first attempt at making a nice plot
#N=947391
p<-ggplot(df,aes(x=created_at))+geom_histogram(binwidth=3600)+scale_x_datetime()
p<-p+ylab('Hourly Tweets regarding Ahmed Mohammed')+xlab('Date')
print(p)

tweets<-extract.tweets2(bs,set)
df <- tweetsToDF(tweets) ## transforming to data frame
head(df)
df$created_at<-formatTwDate(df$created_at)

#first attempt at making a nice plot
#N=947391
p<-ggplot(df,aes(x=created_at))+geom_histogram(binwidth=3600)+scale_x_datetime()
p<-p+ylab('Hourly Tweets regarding Ahmed Mohammed')+xlab('Date')
print(p)