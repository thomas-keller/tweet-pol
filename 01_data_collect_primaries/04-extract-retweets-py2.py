#==============================================================================
# 04-extract-retweets.py
# Purpose: extracts retweets (retweter and retweeted) from each of the tweet
# collections. [Note that we apply activity filters when extracting the
# retweets to make the process more efficient.]
# Author: Pablo Barbera
#
#slight edits by Thomas Keller ~ 10-06-15 - 05-4-16
#changed to python3 for newer version of pymongo
#changed back to 2 because pymongo is barfing on the encoding
#==============================================================================

import json, sys, re, time
import pymongo, sys
from pymongo import MongoClient
from datetime import datetime, timedelta
## Export retweets as edges, and store them in a different file
## for each collection and day, with the following format:
## "temp/retweets/retweets_list_COLLECTION_DATE.csv"
## Also note that ONLY automatic retweets are included.

# connecting to MongoDB
connection = MongoClient('localhost', 27016)

#collections = ["BostonBombing", "GunControl", "MinimumWage", 
#       "USElection", "superbowl", "MarriageEquality", "Budget", "Syria", 
#       "GovernmentShutdown", "oscars", "SOTU", "olympics"]
collections=['repub_primary','ahmed','dem_primary']
for col in collections:
    db = connection['bespoke']
    sp = db[col]
    # query only those tweets coming from users who passed our filter
    data = sp.find({'user.followers_count':{'$gte':25},
        'user.statuses_count':{'$gte':100},
        'user.friends_count':{'$gte':100},
         'retweeted_status':{'$exists':True} })

    retweets = []
    old_date = str('a')
    i = 0
    print data.count()
    sys.stdout.flush()
    #welp=data.decode(unicode_decode_error_handler='replace')
    for t in data:
        if i % 1000 == 0:
            print str(i)
            sys.stdout.flush()
            try:
                new_date = t['timestamp'].date()
            except:
                continue
            # when tweet date is new, open new file where tweets will be stored
            # (note that this assumes tweets are in order, which should almost always be the case!)
            if new_date is not old_date:
                print new_date
                outhandle = open('/home/thomas/twitter_crap/temp/retweets/retweets_list_' + col + '_' + str(new_date) + '.csv', 'a+')
                for retweet in retweets:
                    outhandle.write("{0},{1}\n".format(retweet[0], retweet[1]))
                outhandle.close()  
                retweets = []          
        try:
            retweeter = t['user']['id_str']
            retweeted = t['retweeted_status']['user']['id_str']
        except:
            continue
        retweets.append([retweeter, retweeted])
        i += 1


