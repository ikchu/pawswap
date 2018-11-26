#!/usr/bin/env python

#-----------------------------------------------------------------------
# listings.py (similar to A1 reg.py)
# Authors: Ikaia Chu
#-----------------------------------------------------------------------

import re
from os import path
from sys import argv, stderr, exit
from sqlite3 import connect
import random

#-----------------------------------------------------------------------
# Search Fields Available to User: 
#   - dept 
#   - coursenum 
#   - coursetitle 
#   - bookname
# Functions:
#   - getListings(userSearchDict)
#   - getDetails(listingid)
#   - createListing(fieldDict)
#   - deleteListing(listingid)
#   Note: Only these functions should be called from outside this program
# Usage:
#   - getListings(userSearchDict):
#       - takes in a dictionary created from the user's search form
#           - dictionary in form of {'dept' : 'cos', 'courseTitle' : 'algorithms'} for example
#       - returns list of 'rows' from the database
#           - technically a list of lists
#           - each 'row' is actually a list containing listingid, bookname, dept, coursenum, coursetitle, price
#   - getDetails(listingid):
#       - takes in a listingid
#       - returns list whose elements are fields of that listing
#           - name, email, bookname, dept, coursenum, coursetitle, price, condition, negotiable
#   - createListing(fieldDict):
#       - takes in a dictionary created by the 'create listing page'
#           - dictionary contains sellerid, name, email, bookname, dept, coursenum, price, condition, negotiable
#       - uses dictionary to add new row to database
#           - will need to write helper function to create listingid
#           - will need to connect registrar database to be able to add coursetitle to listing without user having to type it in manually
#   - editListing(listingid, fieldDict)
#       - edits any some field(s) of a listing
#       - dictionary contains only the fields that are to be updated (name, email, bookname, dept, coursenum, price, condition, negotiable)
#   - deleteListing(listingid):
#       - deletes row from database by listingid
#-----------------------------------------------------------------------

def getListings(userSearchDict):

    dataList = []
    DATABASE_NAME = 'listings.sqlite'

    if not path.isfile(DATABASE_NAME):
        raise Exception("database \'" + DATABASE_NAME + "\' not found")

    try:
        connection = connect(DATABASE_NAME)
        cursor = connection.cursor()

        stmtStr = getListingsStmtStr(userSearchDict)
        searchFields = createValList(userSearchDict)

        print stmtStr
        print searchFields

        cursor.execute(stmtStr, searchFields)

        row = cursor.fetchone()
        while row is not None:
            dataList.append(row)
            row = cursor.fetchone()

        cursor.close()
        connection.close()

    except Exception, e:
        print >> stderr, "listings.py > getListings:", e

    return dataList

def getDetails(listingid):

    DATABASE_NAME = 'listings.sqlite'

    if not path.isfile(DATABASE_NAME):
        raise Exception("database \'" + DATABASE_NAME + "\' not found")

    try:
        connection = connect(DATABASE_NAME)
        cursor = connection.cursor()

        stmtStr = getdetailsStmtStr()
        cursor.execute(stmtStr, [listingid])

        row = cursor.fetchone()

        cursor.close()
        connection.close()

        return row

    except Exception, e:
        print >> stderr, "listings.py > getDetails:", e

# Takes in dictionary containing search fields
# Returns listings list of tuples (containing all the fields)
def createListing(fieldList):

    listingFields = fieldList
    
    DATABASE_NAME = 'listings.sqlite'

    if not path.isfile(DATABASE_NAME):
        raise Exception("database \'" + DATABASE_NAME + "\' not found")

    connection = connect(DATABASE_NAME)
    cursor = connection.cursor()

    stmtStr = createListingStmtStr()

    # using .values instead of createValList() because we don't want to format what the user inputs when creating a post
    listingid = newListingID(cursor)
    # fieldList[3], fieldList[4] = dept, coursenum
    coursetitle = getCourseTitle(listingFields[4], listingFields[5])

    # adding these into the list before creating the new row in the db
    # these weren't in the user input 'fieldDict', but they need to be in the db row
    listingFields.append(coursetitle)
    listingFields.append(listingid)

    newList = [listingid, listingFields[0], listingFields[1], listingFields[2], listingFields[3], listingFields[4], listingFields[5], coursetitle, listingFields[6], listingFields[7], listingFields[8]]
    cursor.execute(stmtStr, newList)
    connection.commit()

    cursor.close()
    connection.close()

    return listingid

#   - editListing(listingid, fieldDict)
#       - edits any some field(s) of a listing
#       - dictionary contains only the fields that are to be updated (any combo of name, email, bookname, dept, coursenum, price, condition, negotiable)
def editListing(listingid, fieldDict):

    DATABASE_NAME = 'listings.sqlite'

    if not path.isfile(DATABASE_NAME):
        raise Exception("database \'" + DATABASE_NAME + "\' not found")

    try:
        connection = connect(DATABASE_NAME)
        cursor = connection.cursor()

        stmtStr = editListingStmtStr(fieldDict)

        # using .values instead of createValList() because we don't want to format what the user inputs when creating a post
        fields = fieldDict.values()
        fields.append(listingid)

        cursor.execute(stmtStr, fields)

        cursor.close()
        connection.close()

    except Exception, e:
        print >> stderr, "listings.py > editListing:", e

def deleteListing(listingid):

    DATABASE_NAME = 'listings.sqlite'

    if not path.isfile(DATABASE_NAME):
        raise Exception("database \'" + DATABASE_NAME + "\' not found")

    try:
        connection = connect(DATABASE_NAME)
        cursor = connection.cursor()

        stmtStr = deleteListingStmtStr()
        cursor.execute(stmtStr, [listingid])
        connection.commit()

        cursor.close()
        connection.close()

    except Exception, e:
        print >> stderr, "listings.py > deleteListing:", e



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
#   - deleteListingStmtStr()
#------------------------------------------------------------------------------

def getListingsStmtStr(searchDict):
    # baseline string with no key/value pairs (this will get all listings)
    # this only needs to get the bare minimum data that will show up on the listings results page
    # I figured that on the thumbnails we should need only these 5 fields?
    stmtStrBase = 'SELECT listingid, bookname, dept, coursenum, coursetitle, price ' + \
        'FROM listings'

    # specifies sort order - eventually have user select the 'sort by' method and adjust this accordingly
    stmtStrEnd = ' ORDER BY dept ASC, coursenum ASC, bookname ASC'

    stmtStrEsc = ' ESCAPE \'\\\''

    # for each valid key (ex. '-dept'), the value is the string that will be appended to stmtStr (ex. ' AND dept = \'COS\'')
    # using 'LIKE' will take care of caps/lower issue. 
    keyStmtDict = {
        'dept'       : 'dept LIKE ?',
        'coursenum'  : 'coursenum LIKE ?',
        'coursetitle': 'coursetitle LIKE ?',
        'bookname'  : 'bookname LIKE ?'
    }
    
    stmtStr = stmtStrBase

    stmtStr += ' WHERE ' + keyStmtDict['dept']
    stmtStr += ' AND ' + keyStmtDict['coursenum']
    stmtStr += ' AND ' + keyStmtDict['coursetitle']
    stmtStr += ' AND ' + keyStmtDict['bookname']

    stmtStrEnd = stmtStrEsc + stmtStrEnd

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

    # for key in searchDict:
    #     # re.sub replaces all occurances of % and _ with \% and \_ respectively
    #     # our SELECT statement later uses ESCAPE '\' which takes any character
    #     # after a '\' to be a literal character. 
    #     literalVal = re.sub(r'%', r'\\%', searchDict[key])
    #     literalVal = re.sub(r'_', r'\\_', literalVal)
    #     valList.append('%' + literalVal + '%')

    return valList

def getdetailsStmtStr():
    return 'SELECT name, email, bookname, dept, coursenum, coursetitle, condition, price, negotiable ' + \
        'FROM listings ' + \
        'WHERE listingid = ?'

# returns a unique listingid that is not already in the database
# implementation method: use a counter. start listingid at 1, then 2, 3, etc. 
def newListingID(cursor):
    # stmtStrID = 'SELECT count(*) FROM listings'
    # cursor.execute(stmtStrID)

    # row = cursor.fetchone()

    # listingid = str(row[0] + 1)
    # return listingid

    return random.randint(1, 10000)
    

def createListingStmtStr():
    return 'INSERT INTO listings VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'

# returns the course title when given dept and coursenum
def getCourseTitle(dept, coursenum):
    # connect to reg.sqlite, issue a SELECT statement with dept and coursenum criteria
    # retrieve title from the row that is returned, return it
    # temporary method because we won't be using reg.sqlite!

    stmtStr = 'SELECT title ' + \
        'FROM classes, courses, crosslistings ' + \
        'WHERE classes.courseid = courses.courseid ' + \
        'AND courses.courseid = crosslistings.courseid ' + \
        'AND dept = ? ' + \
        'AND coursenum = ?'

    DATABASE_NAME_R = 'reg.sqlite'

    valList = [dept, coursenum]
    print valList

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
        raise Exception('Course title/num not found. Try different dept and coursenum')

def editListingStmtStr(fieldDict):

    stmtStrBase = 'UPDATE listings SET '

    # specifies sort order - eventually have user select the 'sort by' method and adjust this accordingly
    stmtStrEnd = 'WHERE listingid = ?'

    # for each valid key (ex. '-dept'), the value is the string that will be appended to stmtStr (ex. ' AND dept = \'COS\'')
    # using 'LIKE' will take care of caps/lower issue. 
    keyStmtDict = {
        'name'       : 'name=? ',
        'email'      : 'email=? ',
        'bookname'   : 'bookname=? ',
        'coursenum'  : 'coursenum=? ',
        'condition'  : 'condition=? ',
        'price'      : 'price=? ',
        'negotiable' : 'negotiable=? '
    }

    stmtStr = stmtStrBase

    # adding key/value conditions to stmtStr
    for index, key in enumerate(fieldDict):
        if index == 0: 
            stmtStr += keyStmtDict[key]
        else:
            stmtStr += ', ' + keyStmtDict[key]

    stmtStr += stmtStrEnd

    return stmtStr

def deleteListingStmtStr():
    return 'DELETE FROM listings WHERE listingid = ?'


    
