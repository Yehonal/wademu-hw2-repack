#!/usr/bin/python
#players.save pruner by nneonneo, Sept 09 2005
#Last Updated Oct 16 2005

#Modify following lines to change pruning options.
#Account Pruning
prune_empty_accounts=1 #Removes accounts with no characters attached.
prune_unused_accounts_days=90 #If the account isn't used for more than this amount of days, then it is removed. Set to 0 to disable.
ignore_gms=1 #If set to 1, the pruner won't remove accounts with PLEVEL>=1.
#Character Pruning
prune_players_save=1 #Setting this to 0 disables the entire player pruning code, and leaves only the account pruner.
prune_leq_level=3 #All characters whose levels are below this will be removed. Set to 0 to disable.
prune_unattached_players=1 #Remove players without an account attached to them

import os,struct,time
try:
    import psyco
    psyco.full()
except: pass

maxage=int(time.time()-3600*24*prune_unused_accounts_days)
validguid=[]
allobjects={}
characters={}
charbags={}
mastercounter=0
charskilled=0
acctskilled=0
numacct=0
numchars=0

def ReadCString(f):
    retstr=''
    ch=f.read(1)
    while ch!='\x00':
        retstr+=ch
        ch=f.read(1)
    return retstr

def load_accounts_old(post_lint=0):
    global acctskilled,numacct
    flist=os.listdir("accounts") # list accounts
    numacct=len(flist)
    for acct in flist: #iterate over each file
        charfound=False
        chars=[]
        f=open("accounts\\"+acct)
        data=f.readline()
        while data: #read line by line
            if data.startswith('CHAR='):
                if not post_lint:
                    chars.append(int(data[6:],16))
                    charfound=True
                else:
                    if int(data[6:],16) in allobjects: charfound=True
            if data.startswith('PLEVEL='): plevel=int(data[7:])
            data=f.readline()
        f.close()
        if ((prune_empty_accounts and not charfound) or (prune_unused_accounts_days and os.stat("accounts\\"+acct).st_mtime<maxage)) and (not ignore_gms or not plevel):
            os.unlink("accounts\\"+acct)
            acctskilled+=1
        elif chars:
            for k in chars: validguid.append(k)

def load_accounts_new(post_lint=0):
    global acctskilled,numacct
    if prune_empty_accounts or prune_unused_accounts_days:
        newdatfile=open("accounts.out.dat","wb")
        newstrfile=open("accounts.out.str","wb")
        newdatfile.write('DAT \x01'+'\x00'*31)
        newstrfile.write('STR \x01'+'\x00'*15)
    savepath="saves"
    datfile=open(savepath+"\\accounts.dat","rb")
    strfile=open(savepath+"\\accounts.str","rb")
    datfile.seek(-1,2)
    datlen=datfile.tell()
    if (datlen-35)%238: raise "Accounts DB corrupt." #data is 238 bytes long for each account
    numacct=datlen/238
    datfile.seek(0)
    datfile.read(36) #garbage
    for i in range(numacct): #iterate over each account
        acctdat={"CHAR":[],"PLEVEL":0,"EMAIL":"","PASSWORD":"","NAME":"","LAST_ACCESS":0,"BANNED":0,"LOCKED":0}
        offsets=struct.unpack("<II",datfile.read(8))
        if offsets[0]:
            strfile.seek(offsets[0])
            acctdat["NAME"]=ReadCString(strfile)
        if offsets[1]:
            strfile.seek(offsets[1])
            acctdat["PASSWORD"]=ReadCString(strfile)
        datfile.read(40)
        offset=struct.unpack("<I",datfile.read(4))[0]
        if offset:
            strfile.seek(offset)
            acctdat["EMAIL"]=ReadCString(strfile)
        charfound=False
        chars=[]
        datfile.read(16)
        pos=datfile.tell()
        datfile.read(166)
        acctdat["LAST_ACCESS"]=struct.unpack("<I",datfile.read(4))[0]
        datfile.seek(pos)
        for p in range(10):
            dat=datfile.read(8)
            acctdat["CHAR"].append(dat)
            ch=struct.unpack("<LL",dat) #no uint64
            if (ch[1]+ch[0])>0:
                if not post_lint:
                    chars.append((ch[1]<<32)+ch[0])
                    charfound=True
                else:
                    if (ch[1]<<32)+ch[0] in allobjects: charfound=True
        acctdat["PLEVEL"]=struct.unpack("<I",datfile.read(4))[0]
        dat=datfile.read(80) #more garbage
        acctdat["BANNED"]=datfile.read(1)
        acctdat["LOCKED"]=datfile.read(1)
        acctdat["LAST_ACCESS"]=struct.unpack("<I",datfile.read(4))[0]
        if ((not prune_empty_accounts or charfound) and (not prune_unused_accounts_days or acctdat["LAST_ACCESS"]>maxage)) or (ignore_gms and acctdat["PLEVEL"]):
            for k in chars: validguid.append(k)
            chars=[]
            for k in acctdat["CHAR"]:
                if k != "\x00"*8: chars.append(k)
            chars.extend(["\x00"*8]*acctdat["CHAR"].count("\x00"*8))
            newdatfile.write(struct.pack("<I",newstrfile.tell()))
            newstrfile.write(acctdat["NAME"]+"\x00")
            newdatfile.write(struct.pack("<I",newstrfile.tell()))
            newstrfile.write(acctdat["PASSWORD"]+"\x00")
            newdatfile.write("\x00"*40)
            if acctdat["EMAIL"]:
                newdatfile.write(struct.pack("<I",newstrfile.tell()))
                newstrfile.write(acctdat["EMAIL"]+"\x00")
            else: newdatfile.write("\x00"*4)
            newdatfile.write("\x00"*16)
            for i in acctdat["CHAR"]: newdatfile.write(i)
            newdatfile.write(struct.pack("<I",acctdat["PLEVEL"]))
            newdatfile.write("\x00"*80)
            newdatfile.write(acctdat["BANNED"]+acctdat["LOCKED"])
            newdatfile.write(struct.pack("<I",acctdat["LAST_ACCESS"]))
        else: acctskilled+=1
    datfile.close()
    strfile.close()
    if prune_empty_accounts or prune_unused_accounts_days:
        newdatfile.close()
        newstrfile.close()

def lint_players(filename):
    global mastercounter,charskilled,numchars
    f=open(filename)
    f.seek(-1,2)
    length=f.tell()
    f.seek(0)
    totalnum=0
    percentcounter=0
    percent=0
    line=f.readline()
    while line:
        if line.startswith("[OBJECT]"):
            percentcounter+=1
            if percentcounter>=totalnum/100:
                percentcounter=0
                percent+=1
                print "loading",percent,"% complete"
            GUID=0
            while not line.startswith("\n"):
                if line.startswith("GUID"):
                    GUID=int(line[5:-1],16)
                    allobjects[GUID]=["",0,0]
                if line.startswith("TYPE"): allobjects[GUID][1]=int(line[5:-1])
                if line.startswith("LINK"): allobjects[GUID][2]=int(line[5:-1],16)
                if line.startswith("XYZ"):
                    xyz=line[4:-1].split(' ')
                    if (abs(float(xyz[0]))+abs(float(xyz[1]))+abs(float(xyz[2])))>100000:
                        print "Invalid Object! XYZ="+line[4:-1]
                        allobjects.pop(GUID,0)
                        if GUID in validguid: validguid.remove(GUID)
                        GUID=0
                        charskilled+=1
                    elif abs(float(xyz[3]))>10000:
                        line="XYZ="+xyz[0]+" "+xyz[1]+" "+xyz[2]+" "+"0.00000" #reset orientation
                if line.startswith("LEVEL") and prune_leq_level:
                    level=int(line[6:-1])
                    if level<=prune_leq_level:
                        allobjects.pop(GUID,0)
                        if GUID in validguid: validguid.remove(GUID)
                        GUID=0
                        charskilled+=1
                if GUID: allobjects[GUID][0]+=line
                line=f.readline()
                if f.tell()>=length: break
            if GUID:
                if allobjects[GUID][1]==4:
                    numchars+=1
                    if not prune_unattached_players:
                        characters[GUID]=[]
                        mastercounter+=1
                    elif GUID in validguid:
                        characters[GUID]=[]
                        mastercounter+=1
                    else: charskilled+=1
        if line.startswith("exported="): totalnum=int(line[9:])
        line=f.readline()
        if f.tell()>=length: break
    f.close()
    print "loading done"
    percentcounter=0
    percent=0
    for i in allobjects:
        percentcounter+=1
        if percentcounter>=len(allobjects)/50:
            percentcounter=0
            percent+=1
            print "processing",percent,"% complete"
        if allobjects[i][1] is 2: #bag
            if allobjects[i][2] in validguid:
                characters[allobjects[i][2]].append(i)
                charbags[i]=[]
                #validguid.append(i)
                mastercounter+=1
    percentcounter=0
    percent=50
    for i in allobjects:
        percentcounter+=1
        if percentcounter>=len(allobjects)/50:
            percentcounter=0
            percent+=1
            print "processing",percent,"% complete"
        #if allobjects[i][1] is 4: #character
            #if i in validguid:
                #characters[i]=[]
        if allobjects[i][1] is 1: #item
            if allobjects[i][2] in characters:
                characters[allobjects[i][2]].append(i)
                mastercounter+=1
            elif allobjects[i][2] in charbags:
                charbags[allobjects[i][2]].append(i)
                mastercounter+=1
    print "done pruning"
    f=open("players.out.save","w+")
    f.write("[OBJECTS]\nexported="+str(mastercounter)+"\n")
    for i in characters:
        f.write("\n[OBJECT]\n")
        f.write(allobjects[i][0])
        for k in characters[i]:
            f.write("\n[OBJECT]\n")
            f.write(allobjects[k][0])
            if k in charbags:
                for bi in charbags[k]:
                    f.write("\n[OBJECT]\n")
                    f.write(allobjects[bi][0])
    f.close()

if os.access("saves\\accounts.dat",os.F_OK): load_accounts_new()
else: load_accounts_old()
print "accounts loaded"
if prune_players_save:
    lint_players("saves\\players.save")
    print charskilled,"player"+"s"*(charskilled!=1)+" removed, out of "+str(numchars)+" total"
    acctskilled=0
    if os.access("saves\\accounts.dat",os.F_OK): load_accounts_new(1)
    else: load_accounts_old(1)
if prune_empty_accounts or prune_unused_accounts_days: print acctskilled,"account"+"s"*(acctskilled!=1)+" removed, out of "+str(numacct)+" total"
if prune_unused_accounts_days: print "pruned all accounts older than "+time.ctime(maxage)
raw_input("press <enter> to exit")
