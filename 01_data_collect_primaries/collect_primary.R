load('my_oauth')
library(streamR)

#collecting all tweets that contain at least one of the following terms
#following Barbera et al. 2015  tweeting from left to right

# this script will be run once every hour, and tweets are stored in different
# files, whose name indicate when they were created.
current.time <- format(Sys.time(), "%Y_%m_%d_%H_%M")
f <- paste0("republican_primary_", current.time, '.json')


keywords<-c('primary2015','gopdebate','demdebate','gop primary','rand paul','senrandpaul','santorum','jindal','pataki','lindsey graham','graham','trump','realdonaldtrump','jeb!','jeb','bush','walker','huckabee','carson','cruz','rubio',
'marco','paul','rand','christie','kasich','fiorina','tedcruz','republicandebate','clinton','hillary','bernie','bern','sanders','biden','sentedcruz','omalley')
filterStream(file.name=f, track = keywords, timeout = 3600, oauth = my_oauth)
