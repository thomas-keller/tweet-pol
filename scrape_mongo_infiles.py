f=open('/nv/hp10/tkeller30/mongo_tweets.o8877982')
fnames=[]
for lin in f:
    if lin[0]=='[':
        fnames.append(lin.strip()[5:-1])
fout=open('primary_processed.txt','w')
fout.write('x\n')
for f in fnames:
    fout.write('%s\n'%f)
fout.close()