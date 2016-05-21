library(smappR)

files<-list.files(pattern='ahmed_2015.*json')[1:172]

outfiles<-c()
donef<-read.table('ahmed_processed_apr.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
if(nrow(donef)>0) files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
    print(f)
    tweetsToMongo(file.name=f,ns="bespoke.ahmed")
    #outfiles<-c(outfiles,f)
    write.table(f,file='ahmed_processed_apr.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }



files<-list.files('dem.*json')c(1:38,325:354)
#want a set period of 24 hours surrounding the 2 debates captured more or less
outfiles<-c()
donef<-read.table('dem_processed_apr.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
if(nrow(donef)>0) files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
  tweetsToMongo(file.name=f,ns="bespoke.dem_primary")
  #outfiles<-c(outfiles,f)
  write.table(f,file='dem_processed_apr.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
}
#mashing up smappR tutorial and tweeting from left to right replication materials
#.f<-function(){ #ghetto comment out
#tfold<-'/media/thomas/My Passport/postdoc/twitter_primary'
list.files(pattern='republican_primary_2015_09_.*json')[30:85]
outfiles<-c()
donef<-read.table('primary_processed_apr.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
    print(f)
    tweetsToMongo(file.name=f,ns="bespoke.repub_primary")
    #outfiles<-c(outfiles,f)
    write.table(f,file='primary_processed_apr.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }
    
list.files(pattern='republican_primary_2015_10_.*json')[718:772]
outfiles<-c()
donef<-read.table('primary_processed_apr.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
    print(f)
    tweetsToMongo(file.name=f,ns="bespoke.repub_primary")
    #outfiles<-c(outfiles,f)
    write.table(f,file='primary_processed_apr.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }
    
list.files(pattern='republican_primary_2015_11_.*json')[215:269]
outfiles<-c()
donef<-read.table('primary_processed_apr.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
    print(f)
    tweetsToMongo(file.name=f,ns="bespoke.repub_primary")
    #outfiles<-c(outfiles,f)
    write.table(f,file='primary_processed_apr.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }

#}#comment end
.f<-function(){
files<-Sys.glob('shutdown*json')
outfiles<-c()
donef<-read.table('shutdown2015_processed.txt',sep=',',stringsAsFactors=F,header=T)
#redo last one in case it wasn't complete
if(nrow(donef)>0) files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]
for (f in files){
    print(f)
    tweetsToMongo(file.name=f,ns="tweets.shutdown2015")
    #outfiles<-c(outfiles,f)
    write.table(f,file='shutdown2015_processed.txt',row.names=F,quote=F,append=T,sep=',',col.names=F)
    }
}


#end stupid comment effort



#think this works as a way to flag files that have been read in?


    
    
