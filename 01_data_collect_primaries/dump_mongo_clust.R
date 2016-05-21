library(smappR)
#mashing up smappR tutorial and tweeting from left to right replication materials
.f<-function(){ #ghetto comment out
tfold<-'/media/thomas/My Passport/postdoc/twitter_primary'
files<-Sys.glob('rep*json')
outfiles<-c()
donef<-read.table('primary_processed.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]

for (f in files){
    print(f)
    tweetsToMongo(file.name=f,ns="tweets.repub_primary")
    #outfiles<-c(outfiles,f)
    write.table(f,file='primary_processed.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }

}
#comment end
files<-Sys.glob('shutdown*json')
outfiles<-c()
donef<-read.table('shutdown2015_processed.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
    tweetsToMongo(file.name=f,ns="tweets.shutdown2015")
    #outfiles<-c(outfiles,f)
    write.table(f,file='shutdown2015_processed.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }


files<-Sys.glob('ahmed*json')
outfiles<-c()
donef<-read.table('ahmed_processed.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
    tweetsToMongo(file.name=f,ns="tweets.ahmed")
    #outfiles<-c(outfiles,f)
    write.table(f,file='ahmed_processed.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }

files<-Sys.glob('dem*json')
outfiles<-c()
donef<-read.table('dem_processed.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
    tweetsToMongo(file.name=f,ns="tweets.dem_primary")
    #outfiles<-c(outfiles,f)
    write.table(f,file='dem_processed.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }


#need to figure out way to flag files that have already been read in

    
    
