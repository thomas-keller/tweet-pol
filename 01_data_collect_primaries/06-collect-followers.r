#==============================================================================
# 06-collect-followers.r
# Purpose: download list of Twitter followers of politicians from Twitter API
# Author: Pablo Barbera
#small edits by Thomas Keller --- for some reason does not run as Rscript, only within R?
#need to load methods library in order for Rscript to work, apparently
#==============================================================================

# setup
library(smappR)
library(ROAuth)
library(methods)
outfolder <- './temp/followers_lists/'
oauth_folder <- './oauth_files'

# open list of accounts in first stage (Members of Congress + other political accounts)
elites <- read.csv("./input/elites-twitter-data.csv", stringsAsFactors=F)
elites <- elites[elites$followersCount>=5000,] # keeping only those w/5K+ followers

files<-list.files(outfolder)
# removing those that we already did (downloaded to "data/followers_lists/")
accounts.done <- gsub(".rdata", "",files, outfolder)
accounts.left <- elites$screenName[
		tolower(elites$screenName) %in% tolower(accounts.done) == FALSE]

print(length(accounts.left))
# loop over each account
while (length(accounts.left) > 0){

    # sample randomly one account to get followers
    new.user <- sample(accounts.left, 1)
    cat(new.user, " -- ", length(accounts.left), "15* accounts left!\n")   
    
    # download followers (with some exception handgetFling...) 
    error <- tryCatch(followers <- getFollowers(screen_name=new.user,
        oauth_folder=oauth_folder, sleep=60, verbose=FALSE), error=function(e) e)
    if (inherits(error, 'error')) {
        cat("Error! On to the next one...")
        print(error)
        next
    }
    
    # save to file and remove from lists of "accounts.left"
    file.name <- paste0(outfolder, new.user, ".rdata")
    save(followers, file=file.name)
    accounts.left <- accounts.left[-which(accounts.left %in% new.user)]

}


