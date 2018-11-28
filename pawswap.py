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
<<<<<<< HEAD
=======
from bottle.ext import beaker
from CASClient import CASClient
>>>>>>> 249137d170c602399f567c0c77529c0f9244b966
from listings import getListings, getDetails, createListing, editListing, deleteListing
TEMPLATE_PATH.insert(0, '')

# CAS things
sessionOptions = {
    'session.type': 'file',
    'session.cookie_expires': True,
    'session.data_dir': './data',
    'session.auto': True
}

pawswapApp = beaker.middleware.SessionMiddleware(app(), sessionOptions)

@route('/customerror')
def customerror(errorMsg):
#    url = request.get_cookie('url')
    e = {'errorMsg' : errorMsg}
    return template('customerror.tpl', e)
    
@route('/')
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

    # create dictionary
    dbSearchCriteria = {'dept' : dept, 'coursenum': coursenum, 'coursetitle': title, 'bookname' : bookname }
    # search with that criteria; returns bookname, dept, coursenum, price
    listings = getListings(dbSearchCriteria)

    # first element of listings is the id

    
#    process template things so they are html safe
    
    templateInfo = {
        'errorMsg': errorMsg,
        'bookname': bookname,
        'coursenum': coursenum,
        'dept': dept,
        'title': title,
        'listings': listings,
        'username': username
        }
    
    return template('mainpage.tpl', templateInfo)
    
@route('/listingsdetails')
def listingsdetails():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')

    details = getDetails(listingid)
    # name, email, bookname, dept, coursenum, coursetitle, price, condition, negotiable
    url = request.get_cookie('url')
    response.set_cookie('url', request.url)
     
    templateInfo = {
        'listingid': listingid,
        'details': details,
        'url': url,
        'username': username
    }
    return template('listingsdetails.tpl', templateInfo)

@route('/account')
def account():
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

    # create dictionary
    dbSearchCriteria = {'dept' : dept, 'coursenum': coursenum, 'coursetitle': title, 'bookname' : bookname }
    # search with that criteria; returns bookname, dept, coursenum, price
    listings = getListings(dbSearchCriteria)
    
    url = request.get_cookie('url')
    response.set_cookie('url', request.url)
     
    templateInfo = {
        'url': url,
        'errorMsg': errorMsg,
        'bookname': bookname,
        'coursenum': coursenum,
        'dept': dept,
        'title': title,
        'listings': listings,
        'username': username
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
    
    print "TEST: goToCreateListing is being called"

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

    # sellerid is the person's netid
    netid = request.query.get('netid')
    if ((netid is None) or (netid.strip() == '')):
        netid = ''
        emptyField = True
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
    detailsList = [netid, name, email, bookname, dept, coursenum, condition, price, negotiable]
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
        createListing(detailsList)
        print 'TEST HERE'
        print detailsList 
    except Exception, e:
        print e
        templateInfo['errorBool'] = True
        templateInfo['e'] = e
        return template('createlisting.tpl', templateInfo)
    print 'templateInfo: ', templateInfo
    # update the template now that listingid and course title have been appended
    templateInfo['details'] = detailsList
    templateInfo['listingid'] = detailsList[10]
    templateInfo['errorBool'] = False
    print 'TemplateInfo[details]:'
    print templateInfo['details']
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

    print 'listingid:', listingid
    print 'coursetitle', coursetitle

    # call the get details function with this listingid
    detailsList = getDetails(listingid)

    # get current url to pass in case it goes back
    url = request.get_cookie('url')
    response.set_cookie('url', request.url)

    templateInfo = {
        'listingid': listingid,
        'coursetitle': coursetitle,
        'details': detailsList,
        'url': url,
        'errorBool': False,
        'e': '',
        'emptyListing': False,
        'username': username,
        'fromEditListing': True
    }

    return template('editlisting.tpl', templateInfo)

@route('/editlisting')
def editlisting():
    session = request.environ.get('beaker.session')
    
    casClient = CASClient()
    username = casClient.authenticate(request, response, redirect, session)

    listingid = request.query.get('listingid')
    coursetitle = request.query.get('coursetitle')
    
    emptyField = False

    # sellerid is the person's netid
    netid = request.query.get('netid')
    if ((netid is None) or (netid.strip() == '')):
        netid = ''
        emptyField = True
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
    detailsList = [netid, name, email, bookname, dept, coursenum, condition, price, negotiable]
    # define template
    templateInfo = {
        'listingid': listingid,
        'coursetitle': coursetitle,
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
    
    print 'The Deets:', detailsList
    try:
        # modifies detailsList to include listingid and coursetitle
        editListing(listingid, detailsList)
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
    deleteListing(listingid)
    
    # create dictionary
    dept = ''
    coursenum = ''
    title = ''
    bookname = ''

    dbSearchCriteria = {'dept' : dept, 'coursenum': coursenum, 'coursetitle': title, 'bookname' : bookname }
    # search with that criteria; returns bookname, dept, coursenum, price
    listings = getListings(dbSearchCriteria)

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
    
@error(404)
def notFound(error):
    return 'Not found'
    
if __name__ == '__main__':
    if len(argv) != 2:
        print 'Usage: ' + argv[0] + ' port'
        exit(1)
    run(app=pawswapApp, host='0.0.0.0', port=argv[1], debug=True)