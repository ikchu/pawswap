#!/usr/bin/env python

#-----------------------------------------------------------------------
# CASClient.py
# Authors: Scott Karlin, Alex Halderman, Brian Kernighan, Bob Dondero
#-----------------------------------------------------------------------

import sys, os, cgi, urllib, re, wsgiref.util, uuid
from sqlite3 import connect
from os import path
from datetime import date, datetime

#-----------------------------------------------------------------------

class CASClient:

    #-------------------------------------------------------------------
    
    # Initialize a new CASClient object so it uses the given CAS
    # server, or fed.princeton.edu if no server is given.
    
    def __init__(self, url='https://fed.princeton.edu/cas/'):
        self.cas_url = url

    #-------------------------------------------------------------------

    # Return the URL of the current request after stripping out the
    # "ticket" parameter added by the CAS server.
	
    def stripTicket(self, request):
        url = request.url
        if url is None:
            return "something is badly wrong"
        url = re.sub(r'ticket=[^&]*&?', '', url)
        url = re.sub(r'\?&?$|&$', '', url)
        return url
        
    #-------------------------------------------------------------------

    # Validate a login ticket by contacting the CAS server. If
    # valid, return the user's username; otherwise, return None.

    def validate(self, ticket, request):
        val_url = self.cas_url + "validate" + \
            '?service=' + urllib.quote(self.stripTicket(request)) + \
            '&ticket=' + urllib.quote(ticket)
        r = urllib.urlopen(val_url).readlines()   # returns 2 lines
        if len(r) == 2 and re.match("yes", r[0]) != None:
            return r[1].strip()
        return None
        
    #-------------------------------------------------------------------

    # Authenticate the remote user, and return the user's username.
    # Do not return unless the user is successfully authenticated.
   	
    def authenticate(self, request, response, redirect, session):
        
        # If the user's username is in the session, then the user was
        # authenticated previously.  So return the user's username.
        if session is not None:
            username = session.get('username')
        if username is not None:
            return username
           
        # If the request contains a login ticket, then try to
        # validate it.
        ticket = request.query.get('ticket')
        if ticket is not None:
            username = self.validate(ticket, request)
            if username is not None:             
                # The user is authenticated, so store the user's
                # username in the session.               
                session['username'] = username        
                return username
      
        # The request does not contain a valid login ticket, so
        # redirect the browser to the login page to get one.
        login_url = self.cas_url + 'login' \
            + '?service=' + urllib.quote(self.stripTicket(request))
            
        redirect(login_url)

#-----------------------------------------------------------------------

def main():
    print "CASClient does not run standalone"

if __name__ == '__main__':
    main()