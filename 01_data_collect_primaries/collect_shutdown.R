load('my_oauth')
library(streamR)

#collecting all tweets that contain at least one of the following terms
#following Barbera et al. 2015  tweeting from left to right

# this script will be run once every hour, and tweets are stored in different
# files, whose name indicate when they were created.
current.time <- format(Sys.time(), "%Y_%m_%d_%H_%M")
f <- paste0("shutdown2015_", current.time, '.json')


keywords<-c('government shutdown','shutdown','shutting down', 'shut down', 'boener','mitch mcconell', 'ted cruz','tedcruz', 'abortion','planned parenthood','furlough','budget','gopshutdown','reid','government','debtlimit','debtceiling','govtshutdown','speakerboehner','senatorreid','harry reid')
filterStream(file.name=f, track = keywords, timeout = 3600, oauth = my_oauth)
