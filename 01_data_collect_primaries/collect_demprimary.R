load('my_oauth2')
library(streamR)

#collecting all tweets that contain at least one of the following terms
#following Barbera et al. 2015  tweeting from left to right

# this script will be run once every hour, and tweets are stored in different
# files, whose name indicate when they were created.
current.time <- format(Sys.time(), "%Y_%m_%d_%H_%M")
f <- paste0("dem_primary_", current.time, '.json')


keywords<-c('primary2015','demdebate','clinton','hillary','bernie','bern','sanders','biden','jimwebb','jim webb','webb','malley','o malley','omalley','chafee','cnndebate','chafee2016')
filterStream(file.name=f, track = keywords, timeout = 3600, oauth = my_oauth)
