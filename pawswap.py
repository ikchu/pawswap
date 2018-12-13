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
from listings import getMyListings, claimListing, getMyClaims, makeOffer, getMyOffers
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

    url = request.get_cookie('url')
    response.set_cookie('url', request.url)
     
    templateInfo = {
        'url': url,
    }
    return template('landingpage.html', templateInfo)

@route('/mainpage')
def mainpage():
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

    response.set_cookie('url', request.url)

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

    # first element of listings is the id
    return template('mainpage.tpl', templateInfo)
    
@route('/listingsdetails')
def listingsdetails():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)
    hotfix = request.query.get('mpHotFix')
    listingid = request.query.get('listingid')

    try: 
        details = getDetails(listingid)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})
    # name, email, bookname, dept, coursenum, coursetitle, price, condition, negotiable
    url = request.get_cookie('url')
    response.set_cookie('url', request.url)

    templateInfo = {
        'listingid': listingid,
        'details': details,
        'url': url,
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
    url = request.get_cookie('url')
    response.set_cookie('url', request.url)

    templateInfo = {
        'listingid': listingid,
        'details': details,
        'url': url,
        'username': username
    }
    return template('accountlistingsdetails.tpl', templateInfo)

@route('/account')
def account():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    errorMsg = request.query.get('errorMsg')
    if errorMsg is None:
        errorMsg = ''   

    # returns a list of a user's listings
    try: 
        listings = getMyListings(username)
        # return all of the listings you've claimed UPDATE to return claimed price
        claims = getMyClaims(username)
        print 'Claims', claims
        # return all of the offers with typical details and current offerprice
        offers = getMyOffers(username)
        print 'Offers', offers

        
        listingsClaimOrOff = {}
        for listing in listings:
            isClaim = True
            claimOrOfferList = []
            # call a getClaimsOfMine()
            claimOrOfferList = getClaimsToMe(listing[0])
           
            # if this method returns empty list then:
            if claimOrOfferList == []
                isClaim = False
                # getOffersToMe()
                claimOrOfferList = getOffersToMe(listing[0])
            claimOrOfferList.append(isClaim)
            listingsClaimOrOff[listing[0]] = claimOrOfferList
    
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})

    url = request.get_cookie('url')
    response.set_cookie('url', request.url)
     
    templateInfo = {
        'url': url,
        'errorMsg': errorMsg,
        # 'bookname': bookname,
        # 'coursenum': coursenum,
        # 'dept': dept,
        # 'title': title,
        'listings': listings,
        'username': username,
        'myClaims': claims,
        'myOffers': offers,
        'claimOrOff': listingsClaimOrOff
        'claimBool': claimBool
    }
    return template('account.tpl', templateInfo)

# This is the method that redirect the user to the creatlistings page
# passing the current url as a cookie. The only problem I foresee is that createlisting.tpl
# currently tries to reference things that are not passed in this dictionary (like courses)
@route('/goToCreateListing')
def goToCreateListing():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    url = request.get_cookie('url')
    response.set_cookie('url', request.url)
    emptyDetList = ['','','','','','','','','','','']

    templateInfo = {
        'url' : url,
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

    # get the url of the former page
    url = request.get_cookie('url')
    detailsList = [username, name, email, bookname, dept, coursenum, condition, price, negotiable]
    # define template
    templateInfo = {
        'listingid': '',
        'url': url,
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
        print e
        templateInfo['errorBool'] = True
        templateInfo['e'] = e
        return template('createlisting.tpl', templateInfo)
    # update the template now that listingid and course title have been appended
    templateInfo['details'] = detailsList
    templateInfo['listingid'] = detailsList[10]
    templateInfo['errorBool'] = False
    response.set_cookie('url', request.url)
    
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

    # get current url to pass in case it goes back
    url = request.get_cookie('url')
    response.set_cookie('url', request.url)
    print 'details[3]', detailsList[3]
    templateInfo = {
        'listingid': listingid,
        'coursetitle': coursetitle,
        'details': detailsList,
        'url': url,
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

    # get the url of the former page
    url = request.get_cookie('url')
    detailsList = [username, name, email, bookname, dept, coursenum, condition, price, negotiable]
    # define template

    templateInfo = {
        'listingid': listingid,
        'url': url,
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
    
    response.set_cookie('url', request.url)
    
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
    print 'LISTINGID', listingid
    details = getDetails(listingid)
    
    offerprice = request.query.get('offerprice')
    print 'PRICE', offerprice
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

@error(404)
def notFound(error):
    return 'Not found'
    
if __name__ == '__main__':
    if len(argv) != 2:
        print 'Usage: ' + argv[0] + ' port'
        exit(1)
    run(app=pawswapApp, host='0.0.0.0', port=argv[1], debug=True)