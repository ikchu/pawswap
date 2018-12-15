#!/usr/bin/env python

#-----------------------------------------------------------------------
# pawswap.py
# Author: Reece Schachne, David Bowman, and Ikaia Chu
#-----------------------------------------------------------------------

from sys import argv
from time import localtime, asctime, strftime
from urllib import quote_plus
from Cookie import SimpleCookie
from CASClient import CASClient 
from bottle.ext import beaker
from bottle import route, request, response, error, redirect, run, get
from bottle import template, TEMPLATE_PATH, app
from listings import getListings, getDetails, createListing, editListing, deleteListing, unclaimListing
from listings import getMyListings, claimListing, getMyClaims, makeOffer, getMyOffers, getClaimsToMe, getOffersToMe
from listings import acceptOffer, unacceptOffer, rejectOffer
TEMPLATE_PATH.insert(0, '')

# CAS things
sessionOptions = {
    'session.type': 'file',
    'session.cookie_expires': True,
    'session.data_dir': './data',
    'session.auto': True
}

pawswapApp = beaker.middleware.SessionMiddleware(app(), sessionOptions)

@route('/')
@route('/landingpage')
def landingpage():
    
    errorMsg = request.query.get('errorMsg')
    if errorMsg is None:
        errorMsg = ''   

    templateInfo = {
    }
    return template('landingpage.html', templateInfo)

@route('/mainpage')
def mainpage():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    # Temporary code: this can be removed if we can removed the 'value={{dept}}', etc. from
    # the mainpage.tpl. And I think we can.

    # 
    return template('mainpage.tpl')

    
@route('/searchresults')
def searchresults():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    errorMsg = request.query.get('errorMsg')
    if errorMsg is None:
        errorMsg = ''   

    dept = request.query.get('dept')
    coursenum = request.query.get('coursenum')
    title = request.query.get('coursetitle')
    bookname = request.query.get('bookname')

    if bookname is None:
        bookname = ""
    if coursenum is None:
        coursenum = ""
    if dept is None:
        dept = ""
    if title is None:
        title = ""

    templateInfo = {
        'errorMsg': errorMsg,
        'bookname': bookname,
        'coursenum': coursenum,
        'dept': dept,
        'title': title,
        'username': username
        }

    try:
        # create dictionary
        dbSearchCriteria = {'dept' : dept, 'coursenum': coursenum, 'coursetitle': title, 'bookname' : bookname }
        # search with that criteria; returns bookname, dept, coursenum, price
        listings = getListings(dbSearchCriteria)
        templateInfo['listings'] = listings
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})

    # COPIED FROM ASS 4 (working with AJAX) - adapted to return what we want
    ret = '''<tr>
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Title</th>
                <th>Price</th>
            </tr>'''

    if (len(listings) != 0):
        # # now return all of the listings
        for row in listings:
            retAdd = '<tr class = "clickable-row">' \
            '<td><a href="/listingsdetails?listingid=' + str(row[0]) + '">' + str(row[1]) + ',</a></td>' \
            '<td>' + str(row[2]) + '</td>' \
            '<td>' + str(row[3]) + '</td>' \
            '<td>' + str(row[4]) + '</td>' \
            '<td>$ ' + str(row[5]) + '</td>' \
            '</tr>'
            ret += retAdd
        return ret
    # otherwise there are no current listings
    else:
        retAdd = '''<tr>
                        <th></th>
                        <th></th>
                        <th>There are no current listings.</th>
                        <th></th>
                        <th></th>
                    </tr>'''
        ret += retAdd
        return ret
    # first element of listings is the id
    # return template('mainpage.tpl', templateInfo)
@route('/listingsdetails')
def listingsdetails():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)
    listingid = request.query.get('listingid')
    print 'Listings Details being called!'
    try: 
        details = getDetails(listingid)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})
    # name, email, bookname, dept, coursenum, coursetitle, price, condition, negotiable
    templateInfo = {
        'listingid': listingid,
        'details': details,
        'username': username,
        'claimed': details[9]
    }

    return template('listingsdetails.tpl', templateInfo)

# same as listing deets except it returns accountlistingdetails.tpl which
# has delete functionality; regular listingdetails does not
@route('/accountlistingsdetails')
def accListDet():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')

    try:
        details = getDetails(listingid)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})

    # name, email, bookname, dept, coursenum, coursetitle, price, condition, negotiable

    templateInfo = {
        'listingid': listingid,
        'details': details,
        'username': username
    }
    return template('accountlistingsdetails.tpl', templateInfo)

@route('/account')
def account():
    print 'pawswap.py > account'
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    # returns a list of a user's listings
    try: 
        listings = getMyListings(username)
        # return all of the listings you've claimed UPDATE to return claimed price
        claims = getMyClaims(username)
        # return all of the offers with typical details and current offerprice
        offers = getMyOffers(username)
        
        listingsClaimsAndOffs = {}

        for listing in listings:
            listingid = listing[0]
            
            claimsToMe = getClaimsToMe(listingid) # returns [offererid, offer, 'Yes/No', 'Claim'] Note: 'Yes/No' doesn't matter here. Just including for length consistency between offer/claim
            offersToMe = getOffersToMe(listingid) # returns [offererid, offer, 'Yes/No', 'Offer']

            claimsAndOffers = claimsToMe + offersToMe

            listingsClaimsAndOffs[listing[0]] = claimsAndOffers

        print 'pawswap.py > account : listingsClaimsAndOffs dict =', listingsClaimsAndOffs

    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})
     
    templateInfo = {
        'listings': listings,
        'username': username,
        'myClaims': claims,
        'myOffers': offers,
        'claimsAndOffs': listingsClaimsAndOffs,
    }
    print 'pawswap.py > account : account.tpl should be called now'
    return template('account.tpl', templateInfo)

# This is the method that redirect the user to the creatlistings page
@route('/goToCreateListing')
def goToCreateListing():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)
    emptyDetList = ['','','','','','','','','','','']

    templateInfo = {
        'details': emptyDetList,
        'errorBool': False,
        'e': '',
        'username': username,
        'fromEditListing': False
    }
    # if we are going to return this template, we need to remove the 
    # section of code in createlisting.tpl where Reece iterates through
    # courses
    return template('createlisting.tpl', templateInfo)

@route('/createlisting')
def createlisting():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    emptyField = False

    # sellerid is the person's username as collected by CAS

    name = request.query.get('name')
    if ((name is None) or (name.strip() == '')):
        name = ''
        emptyField = True
    email = request.query.get('email')
    if ((email is None) or (email.strip() == '')):
        email = ''
        emptyField = True
    dept = request.query.get('dept')
    # make it uppercase automatically
    dept = dept.upper()
    if ((dept is None) or (dept.strip() == '')):
        dept = ''
        emptyField = True
    coursenum = request.query.get('coursenum')
    if (coursenum is None) or (coursenum.strip() == ''):
        coursenum = ''
        emptyField = True
    bookname = request.query.get('bookname')
    if (bookname is None) or (bookname.strip() == ''):
        bookname = ''
        emptyField = True
    condition = request.query.get('condition')
    if ((condition is None) or (condition.strip() == '')):
        condition = ''
        emptyField = True
    price = request.query.get('price')
    if ((price is None) or (price.strip() == '')):
        price = ''
        emptyField = True
    negotiable = request.query.get('negotiable')
    if (negotiable is None) or (negotiable.strip() == ''):
        negotiable = ''
        emptyField = True

    detailsList = [username, name, email, bookname, dept, coursenum, condition, price, negotiable]
    # define template
    templateInfo = {
        'listingid': '',
        'details': detailsList,
        'username': username,
        'fromEditListing': False
        }
    # if there is an empty field, return the createlisting template
    if emptyField:
        templateInfo['errorBool'] = True
        templateInfo['e'] = 'One of the fields below is empty.'
        return template('createlisting.tpl', templateInfo)
    
    try:
        # modifies detailsList to include listingid and coursetitle
        detailsList = createListing(detailsList)
    except Exception, e:
        templateInfo['errorBool'] = True
        templateInfo['e'] = e
        return template('createlisting.tpl', templateInfo)
    # update the template now that listingid and course title have been appended
    templateInfo['details'] = detailsList
    templateInfo['listingid'] = detailsList[10]
    templateInfo['errorBool'] = False
    
    # Need to think about what template we return to. Maybe return to some new template that previews what your post looks like??
    # return template('createlisting.tpl', templateInfo)
    return template('afterSubmission.tpl', templateInfo)

@route('/goToEditListing')
def goToEditListing():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    # request the listingid
    listingid = request.query.get('listingid')
    coursetitle = request.query.get('coursetitle')

    # call the get details function with this listingid
    # note: the cursor row is a tuple, not a list. so detailsList is actually a tuple
    # using list() to convert tuple to list, then deleting coursetitle by index (since del and insert dont work on tuples)
    detailsList = list(getDetails(listingid))
    # removing coursetitle to have correct formatting for editlisting.tpl
    del detailsList[5]
    # inserting username at start to have correct formatting for editlisting.tpl
    detailsList.insert(0, username)
    # now detailsList has order [username, name, email, bookname, dept, coursenum, condition, price, negotiable]

    templateInfo = {
        'listingid': listingid,
        'coursetitle': coursetitle,
        'details': detailsList,
        'errorBool': False,
        'e': '',
        'emptyListing': False,
        'fromEditListing': True
    }

    return template('editlisting.tpl', templateInfo)

@route('/editlisting')
def editlisting():

    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')
    # no longer need to get coursetitle because that'll be obtained once listings.py > editListing() is called
    
    emptyField = False

    # sellerid is the person's netid but this will be retrieved from username

    name = request.query.get('name')
    if ((name is None) or (name.strip() == '')):
        name = ''
        emptyField = True
    email = request.query.get('email')
    if ((email is None) or (email.strip() == '')):
        email = ''
        emptyField = True
    dept = request.query.get('dept')
    if ((dept is None) or (dept.strip() == '')):
        dept = ''
        emptyField = True
    coursenum = request.query.get('coursenum')
    if (coursenum is None) or (coursenum.strip() == ''):
        coursenum = ''
        emptyField = True
    bookname = request.query.get('bookname')
    if (bookname is None) or (bookname.strip() == ''):
        bookname = ''
        emptyField = True
    condition = request.query.get('condition')
    if ((condition is None) or (condition.strip() == '')):
        condition = ''
        emptyField = True
    price = request.query.get('price')
    if ((price is None) or (price.strip() == '')):
        price = ''
        emptyField = True
    negotiable = request.query.get('negotiable')
    if (negotiable is None) or (negotiable.strip() == ''):
        negotiable = ''
        emptyField = True

    detailsList = [username, name, email, bookname, dept, coursenum, condition, price, negotiable]
    # define template

    templateInfo = {
        'listingid': listingid,
        'details': detailsList,
        'username': username,
        'fromEditListing': True
        }
    # if there is an empty field, return the createlisting template
    if emptyField:
        templateInfo['errorBool'] = True
        templateInfo['e'] = 'One of the fields below is empty.'
        return template('editlisting.tpl', templateInfo)

    try:
        detailsList = editListing(listingid, detailsList)
    except Exception, e:
        templateInfo['errorBool'] = True
        templateInfo['e'] = e
        templateInfo['fromEditListing'] = True
        return template('editlisting.tpl', templateInfo)

    # update the template now that listingid and course title have been appended
    templateInfo['details'] = detailsList
    templateInfo['errorBool'] = False

    
    # Need to think about what template we return to. Maybe return to some new template that previews what your post looks like??
    # return template('createlisting.tpl', templateInfo)
    return template('afterEditSubmission.tpl', templateInfo)

@route('/deletelisting')
def deleteThisListing():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')

    try:
        deleteListing(listingid)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})
    
    # create dictionary
    dept = ''
    coursenum = ''
    title = ''
    bookname = ''

    dbSearchCriteria = {'dept' : dept, 'coursenum': coursenum, 'coursetitle': title, 'bookname' : bookname }
    # search with that criteria; returns bookname, dept, coursenum, price
    try:
        listings = getListings(dbSearchCriteria)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})

    templateInfo = {
        'errorMsg': '',
        'bookname': '',
        'coursenum': '',
        'dept': '',
        'title': '',
        'listings': listings,
        'username': username
        }
    return template('mainpage.tpl', templateInfo)

# this links the claimerid and the listingid in a table
@route('/claimlisting')
def claimlisting():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')
    details = getDetails(listingid)
    claimPrice = request.query.get('price')

    try:
        claimListing(listingid, username, claimPrice)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })
    
    # call method in listings.py that adds the claimer netid to a table with
    # this listingid
    # newClaim(listingid, username)
    
    templateInfo = {
        'listingid': listingid,
        'details': details,
        'claimprice': claimPrice
    }
    return template('afterClaim.tpl', templateInfo)

@route('/unclaimlisting')
def unclaimlisting():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')
    details = getDetails(listingid)

    try:
        unclaimListing(listingid, username)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })
    
    templateInfo = {
        'listingid': listingid,
        'details': details,
    }
    return template('afterUnclaim.tpl', templateInfo)

@route('/makeoffer')
def makeoffer():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)
    listingid = request.query.get('listingid')
    details = getDetails(listingid)
    
    offerprice = request.query.get('offerprice')
    templateInfo = {
        'listingid': listingid,
        'details': details,
        'offerprice': offerprice
    }

    try:
        makeOffer(listingid, username, offerprice)
        return template('afterOffer.tpl', templateInfo)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

@route('/acceptoffer')
def acceptoffer():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    offererid = request.query.get('offererid')
    listingid = request.query.get('listingid')

    # calls a listings.py function to change the offers table 'accept' column to accepted
    try:
        acceptOffer(listingid, offererid)
        
        # Code below identical to account(). It displays the account page
        # I tried just calling redirect('/account') instead but it didn't seem to work
        # -----------------------------------------------
        listings = getMyListings(username)
        claims = getMyClaims(username)
        offers = getMyOffers(username)
        listingsClaimsAndOffs = {}
        for listing in listings:
            listingid = listing[0]
            claimsToMe = getClaimsToMe(listingid) # returns [offererid, offer, 'Yes/No', 'Claim'] Note: 'Yes/No' doesn't matter here. Just including for length consistency between offer/claim
            offersToMe = getOffersToMe(listingid) # returns [offererid, offer, 'Yes/No', 'Offer']
            claimsAndOffers = claimsToMe + offersToMe
            listingsClaimsAndOffs[listing[0]] = claimsAndOffers

        templateInfo = {
        'listings': listings,
        'username': username,
        'myClaims': claims,
        'myOffers': offers,
        'claimsAndOffs': listingsClaimsAndOffs,
        }
        return template('account.tpl', templateInfo)
        # -----------------------------------------------
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

@route('/unacceptoffer')
def unacceptoffer():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    offererid = request.query.get('offererid')
    listingid = request.query.get('listingid')

    # calls a listings.py function to change the offers table 'accept' column to accepted
    try:
        unacceptOffer(listingid, offererid)
        
        # Code below identical to account(). It displays the account page
        # I tried just calling redirect('/account') instead but it didn't seem to work
        # -----------------------------------------------
        listings = getMyListings(username)
        claims = getMyClaims(username)
        offers = getMyOffers(username)
        listingsClaimsAndOffs = {}
        for listing in listings:
            listingid = listing[0]
            claimsToMe = getClaimsToMe(listingid) # returns [offererid, offer, 'Yes/No', 'Claim'] Note: 'Yes/No' doesn't matter here. Just including for length consistency between offer/claim
            offersToMe = getOffersToMe(listingid) # returns [offererid, offer, 'Yes/No', 'Offer']
            claimsAndOffers = claimsToMe + offersToMe
            listingsClaimsAndOffs[listing[0]] = claimsAndOffers

        templateInfo = {
        'listings': listings,
        'username': username,
        'myClaims': claims,
        'myOffers': offers,
        'claimsAndOffs': listingsClaimsAndOffs,
        }
        return template('account.tpl', templateInfo)
        # -----------------------------------------------
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

@route('/rejectoffer')
def rejectoffer():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    offererid = request.query.get('offererid')
    listingid = request.query.get('listingid')

    # calls a listings.py function to change the offers table 'accept' column to accepted
    try:
        rejectOffer(listingid, offererid)
        
        # Code below identical to account(). It displays the account page
        # I tried just calling redirect('/account') instead but it didn't seem to work
        # -----------------------------------------------
        listings = getMyListings(username)
        claims = getMyClaims(username)
        offers = getMyOffers(username)
        listingsClaimsAndOffs = {}
        for listing in listings:
            listingid = listing[0]
            claimsToMe = getClaimsToMe(listingid) # returns [offererid, offer, 'Yes/No', 'Claim'] Note: 'Yes/No' doesn't matter here. Just including for length consistency between offer/claim
            offersToMe = getOffersToMe(listingid) # returns [offererid, offer, 'Yes/No', 'Offer']
            claimsAndOffers = claimsToMe + offersToMe
            listingsClaimsAndOffs[listing[0]] = claimsAndOffers

        templateInfo = {
        'listings': listings,
        'username': username,
        'myClaims': claims,
        'myOffers': offers,
        'claimsAndOffs': listingsClaimsAndOffs,
        }
        return template('account.tpl', templateInfo)
        # -----------------------------------------------
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

@error(404)
def notFound(error):
    return 'Not found'
    
if __name__ == '__main__':
    if len(argv) != 2:
        print 'Usage: ' + argv[0] + ' port required'
        exit(1)
    run(app=pawswapApp, host='0.0.0.0', port=argv[1], debug=True)