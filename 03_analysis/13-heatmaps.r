#==============================================================================
# 13-heatmaps.r
# Purpose: produce heatmaps (retweets) of Ahmed Mohammed and Primary debate discussions (#Istandwithmohammed, #hilary, #Donaldtrump, etc.)
# Original Author: Pablo Barbera
# Modified for these topics : Thomas Keller
#==============================================================================

# setup
library(reshape)
wd <-getwd()
if(wd!="/home/thomas/tweet-pol") setwd("tweet-pol")
load("./output/estimates.rdata")
estimates <- estimates[,c("id", "ideology")]

## list abbreviations and names
dsets<-c('ahmed','repub_primary','dem_primary')
lists <- c("ahmed","democrats","republicans")
dsets.labels<-c("Ahmed Mohammed","Early Republican Primary",'Early Democratic Primary')
not.poli <- c("superbowl", "newtown", "oscars", "syria", "olympics", "boston")
not.poli.labels <- c("Super Bowl", "Newtown Shooting", "Oscars 2014", "Syria",
    "Winter Olympics", "Boston Marathon")
poli <- c("minimum_wage", "marriageequality", "budget", "governmentshutdown",
    "sotu", "obama")
poli.labels <- c("Minimum Wage", "Marriage Equality", "Budget",
    "Gov. Shutdown", "State of the Union", "2012 Election")

## functions to construct heatmaps
min <- -3.5
max <- 3.5
breaks <- 0.25

expand_data <- function(breaks=0.10, min=-4, max=4){
    x <- results$ideology_retweeter
    y <- results$ideology_retweeted
    x <- (round((x - min) / breaks, 0) * breaks) + min
    y <- (round((y - min) / breaks, 0) * breaks) + min
    tab <- table(x, y)
    tab <- melt(tab)
    tab$prop <- tab$value/sum(tab$value)
    return(tab)
}

######################################################################
### PRE-PROCESSING: EXTRACTING RETWEET LISTS AND MERGING WITH ESTIMATES
######################################################################

pol.days <- c() ## we also estimate our polarization index by day

for (j in 1:length(dsets)){
    
    lst <- dsets[j]
    cat(lst, "\n")
    fls <- list.files("temp/retweets", full.names=TRUE)
    fls <- fls[grep(lst, fls)]  

    results <- list()   

    for (i in 1:length(fls)){
        retweets <- read.table(fls[i], sep=",", 
        	stringsAsFactors=F, col.names=c("retweeter", "retweeted"), fill=T)
        names(retweets)[1] <- 'id'
        retweets <- merge(retweets, estimates)
        names(retweets)[1] <- "retweeter"
        names(retweets)[3] <- "ideology_retweeter"
        names(retweets)[2] <- 'id'
        retweets <- merge(retweets, estimates)
        names(retweets)[4] <- "ideology_retweeted"
        names(retweets)[1] <- "retweeted"
        results[[i]] <- retweets
        cat(i, " ")
        pol.days <- rbind(pol.days,
            data.frame(collection = dsets.labels[j], day = i, 
                polar = mean(abs(retweets$ideology_retweeted)),
            stringsAsFactors=F))
    }   

    results <- do.call(rbind, results)  

    ## saving results
    save(results, file=paste0("temp/retweets_ideology/rt_results_", lst, '.rdata'))

}

save(pol.days, file="temp/polarization-by-day.rdata")

######################################################################
### FIGURE 2: dsets
######################################################################

xy.dsets <- c()

for (j in 1:length(dsets)){

    cat(j, " ")

    ## loading retweet data
    lst <- dsets[j]
    cat(lst, " ")
    load(paste0("temp/retweets_ideology/rt_results_", lst, '.rdata'))

    names(results) <- c("retweeted", "retweeter",
        "ideology_retweeter", "ideology_retweeted")

    ## summarizing
    new.xy <- expand_data(breaks=0.25)
    new.xy$candidate <- dsets.labels[j]
    xy.dsets <- rbind(xy.dsets, new.xy)
}

library(scales)
library(ggplot2)

p <- ggplot(xy.dsets, aes(x=y, y=x))
pq <- p + geom_tile(aes(fill=prop), colour="white") + 
        scale_fill_gradient(name="% of\ntweets", 
        low = "white", high = "black", 
        breaks=c(0, .0025, 0.005, 0.0075, 0.01, 0.012), limits=c(0, .0122),
        labels=c("0.0%", "0.25%", "0.5%", "0.75%","1.0%", ">1%")) +
        labs(y="Estimated Ideology of Retweeter", x="Estimated Ideology of Author") + 
        scale_y_continuous(expand=c(0,0), breaks=(-2:2), limits=c(-3.5, 3.5)) +
        scale_x_continuous(expand=c(0,0), breaks=(-2:2), limits=c(-3.5, 3.5)) +
        facet_wrap( ~ candidate, nrow=2) + 
        theme(panel.border=element_rect(fill=NA), panel.background = element_blank()) +
        coord_equal() 
pq

ggsave(filename="04_plots/figure2.pdf", plot=pq, height=5, width=8)


