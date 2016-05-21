library(smappR)
#mashing up smappR tutorial and tweeting from left to right replication materials
#mongod --dbpath /media/thomas/My\ Passport/postdoc/twitter_primary/mongodb
tfold<-'/media/thomas/My Passport/postdoc/twitter_primary'
files<-Sys.glob('rep*json')
outfiles<-c()
for (f in files){
    tweetsToMongo(file.name=f,ns="tweets.repub_primary")
    outfiles<-c(outfiles,f)
    }
write.csv(outfiles,file='primary_processed.txt',row.names=F,quote=F)

files<-Sys.glob('shutdown*json')
outfiles<-c()
for (f in files){
    tweetsToMongo(file.name=f,ns="tweets.shutdown2015")
    outfiles<-c(outfiles,f)
    }
write.csv(outfiles,file='shutdown2015_processed.txt',row.names=F,quote=F)

files<-Sys.glob('ahmed*json')
outfiles<-c()
for (f in files){
    tweetsToMongo(file.name=f,ns="tweets.ahmed")
    outfiles<-c(outfiles,f)
    }
write.csv(outfiles,file='ahmed_processed.txt',row.names=F,quote=F)



#need to figure out way to flag files that have already been read in

    
    
