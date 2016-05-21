library(smappR)

dump_tweets<-function(files,ns,logfile){

    donef<-read.table(logfile,sep=',',stringsAsFactors=F,header=T)
    #redo last one in case it wasn't complete, sometimes connection breaks
    #subtracting files that have completed from the "todo list"
    if(nrow(donef)>0) files<-files[-which(files %in% donef[1:nrow(donef)-1,1])]

    for (f in files){
        tryCatch({
            tweetsToMongo(file.name=f,ns=ns)
            }
            ,error=function(err){
                print(err)
            }, finally = { write.table(f,file=logfile,row.names=F,quote=F,append=T,sep=',',col.names=F) }
        )} #end tryCatch 
}
    

#I had to eye-ball out the limits to get a week long period for this and 48-hour windows for the other datasets
#I wish I could git git2r to compile on the cluster (openssl can't link, something weird with module setup)
#anyway, not worth it, but dirdf looks for in the future, might do a test with the few files I have on the home drive

#tweets related to Ahmed Mohamed and the clock he brought to school (also known as the "hoax bomb"). Cluster was down for maintenance for the first couple days this went down, but I started collecting after that (16th, it happened on Sep. 14th)
files<-list.files(pattern='ahmed_2015.*json')[1:172]
dump_tweets(files,'bespoke.ahmed','ahmed_processed_apr.txt')

#first and second US democratic debates
files<-list.files(pattern='dem.*json')[c(1:38,325:354)]
dump_tweets(files,'bespoke.dem_primary','dem_processed_apr.txt')

#first republican debate
list.files(pattern='republican_primary_2015_09_.*json')[30:85]
dump_tweets(files,'bespoke.repub_primary','primary_processed_apr.txt')

#second republican debate
list.files(pattern='republican_primary_2015_10_.*json')[718:772]
dump_tweets(files,'bespoke.repub_primary','primary_processed_apr.txt')

#third republican debate
list.files(pattern='republican_primary_2015_11_.*json')[215:269]
dump_tweets(files,'bespoke.repub_primary','primary_processed_apr.txt')

