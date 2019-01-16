#!/usr/bin/env python

#-----------------------------------------------------------------------
# pawswap.py
# Author: Reece Schachne, David Bowman, and Ikaia Chu
#-----------------------------------------------------------------------

from sys import argv
from os import environ
from time import localtime, asctime, strftime
from urllib import quote_plus
from Cookie import SimpleCookie
from CASClient import CASClient 
from bottle.ext import beaker
from bottle import route, request, response, error, redirect, run, get
from bottle import template, TEMPLATE_PATH, app
from listings import getListings, getDetails, createListing, editListing, deleteListing, unclaimListing
from listings import getMyListings, claimListing, getMyClaims, makeOffer, makeCounter, getMyOffers, getClaimsToMe, getOffersToMe
from listings import acceptOffer, unacceptOffer, rejectOffer, repost
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
            '<td><a href="/listingsdetails?listingid=' + str(row[0]) + '">' + str(row[1]) + '</a></td>' \
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

    try: 
        details = getDetails(listingid)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})

    # initially assume this listing has no relation to the user
    relation = 'None'
    # if it turns out that you claimed or made an offer on this listing,
    # store your claim/offer row and pass it through 
    claimOrOffer = []

    # is this my offer?
    myOffers = getMyOffers(username)
    for row in myOffers:
        if str(row[0]) == listingid:
            relation = 'My_Offer'
            claimOrOffer = row
            break
    # is this my claim?
    myClaims = getMyClaims(username)
    for row in myClaims:
        if str(row[0]) == listingid:
            relation = 'My_Claim'
            claimOrOffer = row
            break
    # is this my listing?
    myListings = getMyListings(username)
    for row in myListings:
        if str(row[0]) == listingid:
            relation = 'My_Listing'
            break
    # name, email, bookname, dept, coursenum, coursetitle, price, condition, negotiable
    templateInfo = {
        'listingid': listingid,
        'details': details,
        'claimOrOffer':claimOrOffer,
        'username': username,
        'claimed': details[9],
        'errorBool': False,
        'relation':relation
    }
    
    # Has this listing been claimed by another user?
    # Note: Only want to display the 'already claimed' error message if the listing
    # isn't yours or if you aren't the one who claimed it
    if (details[9]=='1') and (relation=='None' or relation=='My_Offer'):
        templateInfo['errorBool'] = True
        templateInfo['e'] = 'Sorry - this listing has been claimed by another user and is no longer available. Please return to the mainpage.'

    return template('listingsdetails.tpl', templateInfo)

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

    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e})
     
    templateInfo = {
        'listings': listings,
        'username': username,
        'myClaims': claims,
        'myOffers': offers,
        'claimsAndOffs': listingsClaimsAndOffs,
    }
    print 'pawswap.py > account : claimsAndOffs =', listingsClaimsAndOffs
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
    email = request.query.get('email')
    dept = request.query.get('dept')
    # make it uppercase automatically
    dept = dept.upper()
    coursenum = request.query.get('coursenum')
    bookname = request.query.get('bookname')
    condition = request.query.get('condition')
    price = int(request.query.get('price'))
    negotiable = request.query.get('negotiable')

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
    
    # if the price is not >= 0 then raise an error
    if (price < 0):
        templateInfo['errorBool'] = True
        templateInfo['e'] = 'Price must be greater than or equal to 0.'
        return template('createlisting.tpl', templateInfo)
    try:
        # returns detailsList that now includes listingid and coursetitle
        detailsList = createListing(detailsList)
        listingid = str(detailsList[10])
    except Exception, e:
        templateInfo['errorBool'] = True
        templateInfo['e'] = e
        return template('createlisting.tpl', templateInfo)

    newurl = '/listingsdetails?listingid=' + listingid
    redirect(newurl)

@route('/goToEditListing')
def goToEditListing():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    # request the listingid
    listingid = request.query.get('listingid')
    coursetitle = request.query.get('coursetitle')

    # verify that the user is the owner of the listing before allowing them to edit
    relation = 'None'
    # if it turns out that you claimed or made an offer on this listing,
    # store your claim/offer row and pass it through 
    claimOrOffer = []

    # is this my listing?
    myListings = getMyListings(username)
    for row in myListings:
        if str(row[0]) == listingid:
            relation = 'My_Listing'
            break

    if relation == 'None':
        return template('customerror.tpl')
    else:
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

    # verify that the user is the owner of the listing before allowing them to edit
    relation = 'None'
    # if it turns out that you claimed or made an offer on this listing,
    # store your claim/offer row and pass it through 
    claimOrOffer = []

    # is this my listing?
    myListings = getMyListings(username)
    for row in myListings:
        if str(row[0]) == listingid:
            relation = 'My_Listing'
            break

    if relation == 'None':
        return template('customerror.tpl')
    else:
        # sellerid is the person's netid but this will be retrieved from username
        name = request.query.get('name')
        email = request.query.get('email')
        dept = request.query.get('dept')
        # make it uppercase automatically
        dept = dept.upper()
        coursenum = request.query.get('coursenum')
        bookname = request.query.get('bookname')
        condition = request.query.get('condition')
        price = int(request.query.get('price'))
        negotiable = request.query.get('negotiable')

        detailsList = [username, name, email, bookname, dept, coursenum, condition, price, negotiable]
        # define template

        print 'pawswap.py > editlisting : edit fields',detailsList

        templateInfo = {
            'listingid': listingid,
            'details': detailsList,
            'username': username,
            'fromEditListing': True
            }

        # if the price is not >= 0 then raise an error
        if (price < 0):
            templateInfo['errorBool'] = True
            templateInfo['e'] = 'Price must be greater than or equal to 0.'
            return template('editlisting.tpl', templateInfo)

        try:
            detailsList = editListing(listingid, detailsList)
        except Exception, e:
            templateInfo['errorBool'] = True
            templateInfo['e'] = e
            templateInfo['fromEditListing'] = True
            return template('editlisting.tpl', templateInfo)

        newurl = '/listingsdetails?listingid=' + listingid
        redirect(newurl)

@route('/deletelisting')
def deleteThisListing():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')

    # verify that the user is the owner of the listing before allowing them to edit
    relation = 'None'
    # if it turns out that you claimed or made an offer on this listing,
    # store your claim/offer row and pass it through 
    claimOrOffer = []

    # is this my listing?
    myListings = getMyListings(username)
    for row in myListings:
        if str(row[0]) == listingid:
            relation = 'My_Listing'
            break

    if relation == 'None':
        return template('customerror.tpl')
    else:
        try:
            deleteListing(listingid)
        except Exception, e:
            return template('customerror.tpl', {'errorMsg' : e })
        redirect('/account')

# this links the claimerid and the listingid in a table
@route('/claimlisting')
def claimlisting():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')
    claimPrice = request.query.get('price')

    # ------------------------------------------------

    # # check to make sure not claimed
    # claimed = details[9]
    # if claimed == 1:
    #     # don't let the offer happen
    #     templateInfo['errorBool']= 1
    #     templateInfo['e'] = 'Sorry, this listing has just been claimed by another user. Please navigate to the mainpage.'
    #     return template('listingsdetails.tpl', templateInfo)

    # ------------------------------------------------

    try:
        # note: if listing is already claimed, this will do nothing
        claimListing(listingid, username, claimPrice)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })
    
    newurl = '/listingsdetails?listingid=' + listingid
    redirect(newurl)

@route('/unclaimlisting')
def unclaimlisting():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')

    # verify that the user is the owner of the listing before allowing them to edit
    relation = 'None'
    # if it turns out that you claimed or made an offer on this listing,
    # store your claim/offer row and pass it through 
    claimOrOffer = []

    # is this my claim?
    myClaims = getMyClaims(username)
    for row in myClaims:
        if str(row[0]) == listingid:
            relation = 'My_Claim'
            claimOrOffer = row
            break

    if relation == 'None':
        return template('customerror.tpl')
    else:
        try:
            unclaimListing(listingid, username)
        except Exception, e:
            return template('customerror.tpl', {'errorMsg' : e })
        
        newurl = '/listingsdetails?listingid=' + listingid
        redirect(newurl)

@route('/makeoffer')
def makeoffer():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)
    listingid = request.query.get('listingid')
    price = int(request.query.get('price'))
    details = getDetails(listingid)
    offerprice = int(request.query.get('offerprice'))

    templateInfo = {
        'listingid': listingid,
        'details': details,
        'offerprice': offerprice,
        'errorBool': False,
        'claimed': details[9],
    }
    
    # ------------------------------------------------

    # # check to make sure not claimed
    # claimed = details[9]
    # if claimed == 1:
    #     # don't let the offer happen
    #     templateInfo['errorBool']= 1
    #     templateInfo['e'] = 'Sorry - this listing has just been claimed. Please navigate to the mainpage.'
    #     return template('listingsdetails.tpl', templateInfo)
    
    # ------------------------------------------------
    
    if (offerprice <= 0) or (offerprice > price):
        templateInfo['errorBool'] = True
        templateInfo['e'] = 'Error: Your offer must be between $0 and the listed price.'
        return template('listingsdetails.tpl', templateInfo)

    try:
        makeOffer(listingid, username, offerprice)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

    newurl = '/listingsdetails?listingid=' + listingid
    redirect(newurl)

@route('/makecounteroffer')
def makecounteroffer():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)
    listingid = request.query.get('listingid')
    details = getDetails(listingid)
    offererid = request.query.get('offererid')
    counterprice = request.query.get('counterprice')

    try:
        makeCounter(listingid, offererid, counterprice)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

    redirect('/account')

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
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

    redirect('/account')

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
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

    redirect('/account')

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
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })

    redirect('/account')

@route('/repost')
def repostlisting():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')

    try:
        repost(listingid)
    except Exception, e:
        return template('customerror.tpl', {'errorMsg' : e })
    
    redirect('/account')

@error(404)
def notFound(error):
    return 'Not found'
    
if __name__ == '__main__':
    if len(argv) != 2:
        print 'Usage: ' + argv[0] + ' port required'
        exit(1)
    run(app=pawswapApp, host='0.0.0.0', port=argv[1], debug=True)