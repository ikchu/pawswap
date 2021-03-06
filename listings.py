#!/usr/bin/env python

#-----------------------------------------------------------------------
# listings.py
# Authors: Ikaia Chu
#-----------------------------------------------------------------------

import re
import psycopg2
from sys import argv, stderr, exit
from sqlite3 import connect
import requests
import random
import datetime

#-----------------------------------------------------------------------
# Search Fields Available to User: 
#   - dept 
#   - coursenum 
#   - coursetitle 
#   - bookname
# Public Functions:
#   - getListings(userSearchDict)
#   - getDetails(listingid)
#   - createListing(fieldList)
#   - editListing(listingid, fieldList)
#   - deleteListing(listingid)
#   - getMyListings(username)
#   - claimListing(listingid, claimerid, price)
#   - unclaimListing(listingid, claimerid)
#   - makeOffer(listingid, offererid, offerprice)
#   - makeCounter(listingid, offererid, counter)
#   - getMyClaims(claimerid)
#   - getMyOffers(claimerid)
#   - getOffersToMe(listingid)
#   - getClaimsToMe(listingid)
#   - acceptOffer(listingid, offererid)
#   - unacceptOffer(listingid, offererid)
#   - def rejectOffer(listingid, offererid)
#-----------------------------------------------------------------------

def getListings(userSearchDict):

    dataList = []
    
    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = getListingsStmtStr(userSearchDict)

    searchFields = createValList(userSearchDict)

    cursor.execute(stmtStr, searchFields)

    row = cursor.fetchone()
    while row is not None:
        dataList.append(row)
        row = cursor.fetchone()

    cursor.close()
    connection.close()

    return dataList

def getDetails(listingid):

    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()
    
    stmtStr = getdetailsStmtStr()
    cursor.execute(stmtStr, [listingid])

    row = cursor.fetchone()
    cursor.close()
    connection.close()
    
    return list(row)

# Takes in dictionary containing search fields
# Returns listings list of tuples (containing all the fields)
def createListing(fieldList):
    
    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = createListingStmtStr()

    # using .values instead of createValList() because we don't want to format what the user inputs when creating a post
    listingid = newListingID(cursor)
    # fieldList[3], fieldList[4] = dept, coursenum
    coursetitle = getCrsTitleJSON(fieldList[4], fieldList[5])

    # adding these into the list before creating the new row in the db
    # these weren't in the user input 'fieldDict', but they need to be in the db row
    listingFields = list(fieldList)
    listingFields.append(coursetitle)
    listingFields.append(listingid)

    # make sure that listings are initially 'unclaimed'
    claimedStatus = '0'

    # include date and time of posting
    dt = str(datetime.datetime.utcnow())

    newList = [listingid, listingFields[0], listingFields[1], listingFields[2], listingFields[3], listingFields[4], listingFields[5], coursetitle, listingFields[6], listingFields[7], listingFields[8], claimedStatus, dt]
    cursor.execute(stmtStr, newList)
    connection.commit()

    cursor.close()
    connection.close()

    return listingFields

#   - editListing(listingid, fieldList)
#       - edits any some field(s) of a listing
#       - fieldList contains only the fields that are to be updated (any combo of name, email, bookname, dept, coursenum, price, condition, negotiable)
def editListing(listingid, fieldList):

    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    # getting new coursetitle in case the user edited dept or coursenum
    # fieldList[4] is dept, fieldList[5] is coursenum
    coursetitle = getCrsTitleJSON(fieldList[4], fieldList[5])

    stmtStr = editListingStmtStr()

    # using .values instead of createValList() because we don't want to format what the user inputs when creating a post
    # fields = fieldDict.values()

    fields = list(fieldList)
    fields.append(coursetitle)
    fields.append(listingid)

    # PROBLEMS
    #   - listingid is None
    #   - things are out of order

    cursor.execute(stmtStr, fields)
    connection.commit()

    cursor.close()
    connection.close()

    return fields

def deleteListing(listingid):

    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'DELETE FROM listings WHERE listingid = %s'
    cursor.execute(stmtStr, [listingid])
    connection.commit()

    stmtStr = 'DELETE FROM offers WHERE listingid = %s'
    cursor.execute(stmtStr, [listingid])
    connection.commit()

    cursor.close()
    connection.close()

# this method takes in a username as input, searches the database
# for all listings with that username and returns the listings
def getMyListings(username):
    dataList = []

    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'SELECT listingid, bookname, dept, coursenum, coursetitle, price FROM listings WHERE sellerid = %s'
    usernameList = [username]

    cursor.execute(stmtStr, usernameList)

    row = cursor.fetchone()
    while row is not None:
        dataList.append(row)
        row = cursor.fetchone()

    cursor.close()
    connection.close()

    return dataList

# this method takes a listingid and claimerid and adds them to our second table
# will only claim a listing that is not already claimed
def claimListing(listingid, claimerid, price):
    # check if listing has already been claimed
    details = getDetails(listingid)
    claimed = details[9]
    if (claimed != 1):
        connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
        cursor = connection.cursor()

        stmtStr = makeOfferStmtStr(listingid, claimerid, cursor)
        cursor.execute(stmtStr, [price, 'Claimed', listingid, claimerid])

        # update table 1 (listings) so that claimed col is '1'
        stmtStr = 'UPDATE listings SET claimed=1 WHERE listingid=%s'
        cursor.execute(stmtStr, [listingid])

        # maybe here I should also have it change any offer statuses on this listing to be something like 'This listing has been claimed'
        # if I do that, make sure that unclaimListing reverts the offer statuses to 'Pending'

        connection.commit()

        cursor.close()
        connection.close()

def unclaimListing(listingid, claimerid):
    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'DELETE FROM offers WHERE listingid=%s AND offererid=%s'
    # be careful to pass fields in this order when executing
    cursor.execute(stmtStr, [listingid, claimerid])

    # update table 1 (listings) so that claimed col is '1'
    stmtStr = 'UPDATE listings SET claimed=0 WHERE listingid=%s'
    cursor.execute(stmtStr, [listingid])

    connection.commit()

    cursor.close()
    connection.close()

def makeOffer(listingid, offererid, offerprice):
    # check if listing has already been claimed
    details = getDetails(listingid)
    claimed = details[9]
    if (claimed != 1):
        connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
        cursor = connection.cursor()

        stmtStr = makeOfferStmtStr(listingid, offererid, cursor)
        cursor.execute(stmtStr, [offerprice, 'Pending', listingid, offererid])

        connection.commit()

        #-----------------------------------------------------------------
        # ideally, here we send notification to seller that offer was made
        #-----------------------------------------------------------------
        cursor.close()
        connection.close()

def makeCounter(listingid, offererid, counter):
    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = makeCounterStmtStr()
    print 'listings.py > makeCounter: stmtStr =', stmtStr, 'Values = [ Countered', counter, 'Pending', listingid, offererid,']'
    cursor.execute(stmtStr, ['Countered', counter, 'Pending', listingid, offererid])

    connection.commit()
    cursor.close()
    connection.close()

# this returns a list of all the claims associated with a netid
def getMyClaims(claimerid):
    dataList = []

    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    # get all rows that ARE claimed
    stmtStr = 'SELECT listings.listingid, bookname, dept, coursenum, coursetitle, price, offer FROM listings, offers WHERE offers.offererid = %s AND listings.listingid = offers.listingid AND offerstatus = %s'
    cursor.execute(stmtStr, [claimerid, 'Claimed'])

    row = cursor.fetchone()
    while row is not None:
        dataList.append(row)
        row = cursor.fetchone()

    cursor.close()
    connection.close()
    
    return dataList
def getMyOffers(claimerid):
    dataList = []

    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    # get all rows that are NOT claimed
    stmtStr = 'SELECT listings.listingid, bookname, dept, coursenum, coursetitle, price, offer, offerstatus, counter, counterstatus FROM listings, offers WHERE offers.offererid = %s AND listings.listingid = offers.listingid AND offerstatus != %s'
    cursor.execute(stmtStr, [claimerid, 'Claimed'])

    row = cursor.fetchone()
    while row is not None:
        dataList.append(row)
        row = cursor.fetchone()

    cursor.close()
    connection.close()
    
    return dataList

# returns offers on the listing with listingid
def getOffersToMe(listingid):
    dataList = []

    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'SELECT offererid, offer, offerstatus, counter, counterstatus FROM listings, offers WHERE offers.listingid = listings.listingid AND offers.listingid = %s AND claimed = %s'
    cursor.execute(stmtStr, [listingid, '0'])

    row = cursor.fetchone()
    while row is not None:
        tmp = list(row)
        tmp.append('Offer')
        dataList.append(tmp)
        row = cursor.fetchone()

    cursor.close()
    connection.close()
    
    return dataList
    
# gets claims on a Listing at listingid
# should only ever return one claim, since we only allow one claim per listing
def getClaimsToMe(listingid):
    dataList = []

    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'SELECT offererid, offer, offerstatus, counter, counterstatus FROM listings, offers WHERE offers.listingid = listings.listingid AND offers.listingid = %s AND offerstatus = %s'
    cursor.execute(stmtStr, [listingid, 'Claimed'])

    row = cursor.fetchone()
    while row is not None:
        tmp = list(row)
        tmp.append('Claim')
        dataList.append(tmp)
        row = cursor.fetchone()

    cursor.close()
    connection.close()
    
    return dataList

def acceptOffer(listingid, offererid):
    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'UPDATE offers SET offerstatus=%s WHERE listingid=%s AND offererid=%s'
    cursor.execute(stmtStr, ['Accepted',listingid,offererid])
    connection.commit()

    cursor.close()
    connection.close()

def unacceptOffer(listingid, offererid):
    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'UPDATE offers SET offerstatus=%s WHERE listingid=%s AND offererid=%s'
    cursor.execute(stmtStr, ['Pending',listingid,offererid])
    connection.commit()

    cursor.close()
    connection.close()

def rejectOffer(listingid, offererid):
    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'UPDATE offers SET offerstatus=%s WHERE listingid=%s AND offererid=%s'
    cursor.execute(stmtStr, ['Rejected',listingid,offererid])
    connection.commit()

    cursor.close()
    connection.close()
    
def repost(listingid):
    connection = psycopg2.connect("dbname=da0gcdvn3issq host=ec2-54-235-67-106.compute-1.amazonaws.com port=5432 user=krjwjldbljtshq password=60d5da56862d7e9021a68085dfbf9b2f7ceb107fa2fd8f6e9a12f7be4dfc044f sslmode=require")
    cursor = connection.cursor()

    stmtStr = 'UPDATE listings SET claimed=%s WHERE listingid=%s'
    cursor.execute(stmtStr, ['0',listingid])
    connection.commit()

    stmtStr = 'DELETE FROM offers WHERE listingid=%s'
    cursor.execute(stmtStr, [listingid])
    connection.commit()

    cursor.close()
    connection.close()

#------------------------------------------------------------------------------
# 'Private' Helper Functions
#
#   - getListingStmtStr(searchDict)
#   - createValList(searchDict)
#   - getdetailsStmtStr()
#   - newListingID()
#   - createListingStmtStr()
#   - getCourseTitle(dept, coursenum)
#   - editListingStmtStr()
#------------------------------------------------------------------------------

def getListingsStmtStr(searchDict):
    # baseline string with no key/value pairs (this will get all listings)
    # this only needs to get the bare minimum data that will show up on the listings results page
    # I figured that on the thumbnails we should need only these 5 fields?
    stmtStrBase = 'SELECT listingid, bookname, dept, coursenum, coursetitle, price, dt FROM listings'

    # specifies sort order - eventually have user select the 'sort by' method and adjust this accordingly
    stmtStrEnd = ' ORDER BY dt DESC, dept ASC, coursenum ASC, bookname ASC'

    stmtStrEsc = ' ESCAPE \'\\\''

    # for each valid key (ex. '-dept'), the value is the string that will be appended to stmtStr (ex. ' AND dept = \'COS\'')
    # using 'LIKE' will take care of caps/lower issue. 
    keyStmtDict = {
        'dept'       : 'dept ILIKE %s',
        'coursenum'  : 'coursenum ILIKE %s',
        'coursetitle': 'coursetitle ILIKE %s',
        'bookname'  : 'bookname ILIKE %s',
        'claimed'   : 'claimed = %s'
    }
    
    stmtStr = stmtStrBase

    stmtStr += ' WHERE ' + keyStmtDict['dept']
    stmtStr += ' AND ' + keyStmtDict['coursenum']
    stmtStr += ' AND ' + keyStmtDict['coursetitle']
    stmtStr += ' AND ' + keyStmtDict['bookname']
    stmtStr += ' AND ' + keyStmtDict['claimed']

    stmtStr += stmtStrEnd

    # hasKeyValue = False
    # adding key/value conditions to stmtStr
    # for index, key in enumerate(searchDict):
    #     if index == 0: 
    #         stmtStr += ' WHERE ' + keyStmtDict[key]
    #     else:
    #         stmtStr += ' AND ' + keyStmtDict[key]
    #     hasKeyValue = True

    # hack to fix 'Syntax Error Near ESCAPE' problem which only showed up
    # when running python reg.py or python reg.py -h. Solution: only add the
    # ESCAPE statement if there is at least one key/val pair
    # if hasKeyValue :
    #     stmtStrEnd = stmtStrEsc + stmtStrEnd
    # stmtStr += stmtStrEnd

    return stmtStr

# this function takes a keyValueDict as input and creates a
# list of the values for the keys
def createValList(searchDict):
    valList = []

    literalVal = re.sub(r'%', r'\\%', searchDict['dept'])
    literalVal = re.sub(r'_', r'\\_', literalVal)
    valList.append('%' + literalVal + '%')

    literalVal = re.sub(r'%', r'\\%', searchDict['coursenum'])
    literalVal = re.sub(r'_', r'\\_', literalVal)
    valList.append('%' + literalVal + '%')

    literalVal = re.sub(r'%', r'\\%', searchDict['coursetitle'])
    literalVal = re.sub(r'_', r'\\_', literalVal)
    valList.append('%' + literalVal + '%')

    literalVal = re.sub(r'%', r'\\%', searchDict['bookname'])
    literalVal = re.sub(r'_', r'\\_', literalVal)
    valList.append('%' + literalVal + '%')

    # adding the claimed stipulation (claimed must be '0' to be shown on mainpage)
    valList.append('0')

    # for key in searchDict:
    #     # re.sub replaces all occurances of % and _ with \% and \_ respectively
    #     # our SELECT statement later uses ESCAPE '\' which takes any character
    #     # after a '\' to be a literal character. 
    #     literalVal = re.sub(r'%', r'\\%', searchDict[key])
    #     literalVal = re.sub(r'_', r'\\_', literalVal)
    #     valList.append('%' + literalVal + '%')

    return valList

def getdetailsStmtStr():
    return 'SELECT name, email, bookname, dept, coursenum, coursetitle, condition, price, negotiable, claimed ' + \
        'FROM listings ' + \
        'WHERE listingid = %s'

# returns a unique listingid that is not already in the database
# implementation method: use a counter. start listingid at 1, then 2, 3, etc. 
def newListingID(cursor):
    # stmtStrID = 'SELECT count(*) FROM listings'
    # cursor.execute(stmtStrID)

    # row = cursor.fetchone()

    # listingid = str(row[0] + 1)
    # return listingid

    while True:
        randomId = random.randint(1, 1000000)
        stmtStr = 'SELECT listingid FROM listings WHERE listingid = %s'
        cursor.execute(stmtStr, [str(randomId)])
        row = cursor.fetchone()
        if row is None:
            return randomId
    

def createListingStmtStr():
    return 'INSERT INTO listings VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'

# returns the course title when given dept and coursenum
def getCourseTitle(dept, coursenum):
    # connect to reg.sqlite, issue a SELECT statement with dept and coursenum criteria
    # retrieve title from the row that is returned, return it
    # temporary method because we won't be using reg.sqlite!

    stmtStr = 'SELECT title ' + \
        'FROM classes, courses, crosslistings ' + \
        'WHERE classes.courseid = courses.courseid ' + \
        'AND courses.courseid = crosslistings.courseid ' + \
        'AND dept = %s ' + \
        'AND coursenum = %s'

    DATABASE_NAME_R = 'reg.sqlite'

    valList = [dept, coursenum]

    connectionReg = connect(DATABASE_NAME_R)
    cursorReg = connectionReg.cursor()
    cursorReg.execute(stmtStr, valList)
    row = cursorReg.fetchone()

    if row is not None:
        title = str(row[0])
        cursorReg.close()
        connectionReg.close()
        return title
    else:
        cursorReg.close()
        connectionReg.close()
        raise Exception('Course title not found. Try different dept and coursenum')

# This method accesses the current registrar; the dept and coursenum are passed to it
def getCrsTitleJSON(dept, coursenum):
    url = 'http://etcweb.princeton.edu/webfeeds/courseofferings/?term=all&subject=' + dept + '&catnum=' + coursenum + '&fmt=json&brief=yes'
    resp = requests.get(url)
    crsData = resp.json()

    try:
        title = (((((crsData['term'])[0])['subjects'])[0])['courses'][0])['title']
        return title
    except Exception:
        pass
    
    try:
        title = (((((crsData['term'])[1])['subjects'])[0])['courses'][0])['title']
        return title
    except Exception:
        pass

    try:
        title = (((((crsData['term'])[2])['subjects'])[0])['courses'][0])['title']
        return title
    except Exception:
        pass

    try:
        title = (((((crsData['term'])[3])['subjects'])[0])['courses'][0])['title']
        return title
    except Exception:
        pass

    try:
        title = (((((crsData['term'])[4])['subjects'])[0])['courses'][0])['title']
        return title
    except Exception:
        raise Exception('This course was not found. Please try a different Department and Course Number.')

def editListingStmtStr():
    stmtStr = 'UPDATE listings SET sellerid=%s, name=%s, email=%s, bookname=%s, dept=%s, coursenum=%s, condition=%s, price=%s, negotiable=%s, coursetitle=%s WHERE listingid=%s'
    return stmtStr

def makeOfferStmtStr(listingid, offererid, cursor):
    # checking to see if the offerer has already made an offer for this listing. 
    # if so, then we want to update that row in offers table. Otherwise create new row
    precheckStr = 'SELECT * FROM offers WHERE listingid LIKE %s AND offererid LIKE %s'
    cursor.execute(precheckStr, [listingid, offererid])
    offerAlreadyExists = (cursor.fetchone() is not None)
    
    if offerAlreadyExists:
        stmtStr = 'UPDATE offers SET offer=%s, offerstatus=%s WHERE listingid=%s AND offererid=%s'
    else:
        # fields seem out of order. but leave it this way so that order is same for INSERT vs. UPDATE stmts
        stmtStr = 'INSERT INTO offers (offer, offerstatus, listingid, offererid) VALUES (%s,%s,%s,%s)'

    return stmtStr 

def makeCounterStmtStr():
    # when this function is called, it is assumed that it is being called on a 
    # specfiic offer that already exists in the table

    stmtStr = 'UPDATE offers SET offerstatus=%s, counter=%s, counterstatus=%s WHERE listingid=%s AND offererid=%s'
    return stmtStr



    
