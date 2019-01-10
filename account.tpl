<!DOCTYPE html>
<html>
  <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>PawSwap</title>

    <!-- Bootstrap core CSS -->

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link href="vendor/bootstrap/css/bootstrap.css" rel="stylesheet">

    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <!-- Custom fonts for this template -->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="vendor/simple-line-icons/css/simple-line-icons.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Avenir">


    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
   <head>
            <!-- Global site tag (gtag.js) - Google Analytics -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=UA-131225117-1"></script>
        <script>
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());

          gtag('config', 'UA-131225117-1');
        </script>
      <title>My Account</title>
   </head>

   <style>
      h1{
          color: black;
      } 
      .title {
        color: #FFFFFF;
        background-color: #343a40;
        text-align: center;
        font-family: 'Avenir';
      }
      .no-border {
          border: 0;
          box-shadow: none; /* You may want to include this as bootstrap applies these styles too */
      }
      .form-control {
          border: 0;
      }
      .input:focus {
        outline:none;
        border:0;
        box-shadow:none;
      }
      .footer {
        color: white;
        background-color: #343a40;
        text-align: center;
        padding: 0px;
        font-family: 'Avenir';
       }
       .navbar {
        color: white;
        text-align: center;
        font-family: 'Avenir';
       }
       .sentence{
        text-align: right;
        float: right;
        font-family: 'Avenir';
       }
       .btn {
        padding:5;

        /*position:absolute;*/
       }
       .thisfont {
        font-family: 'Avenir';
       }
       .specific {
        font-size: large;
       }

    </style>

   <body>
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-dark bg-dark thisfont">
      <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>

    <div class="w3-container w3-padding-16"> 
       <nav class="thisfont text-center title specific">
          <strong> Books I'm Selling </strong>
       </nav>
        <table class="table table-hover table-striped thisfont">
            <tr>
              <!-- new way to list out the mylistings -->
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Title</th>
                <th>Listed Price</th>
            </tr>
            % if len(listings) == 0:
              <tr>
                <td colspan="5">You are not selling any books</td>
              </tr>
            % else:
              % for row in listings:
                <tr class = "clickable-row thisfont" data-href="/listingsdetails?listingid={{row[0]}}">
                  <td>{{row[1]}}</td>
                  <td>{{row[2]}}</td>
                  <td>{{row[3]}}</td>
                  <td>{{row[4]}}</td>
                  <td>${{row[5]}}</td>
                </tr>

                <!-- If there are no claims or offers on this listing -->
                % if (claimsAndOffs[row[0]] == []):
                    <tr>
                      <td></td>
                      <td></td>
                      <td></td>
                      <td colspan="2">No current offers or claims.</td>
                    </tr>


                <!-- If there are claims or offers on the listing -->
                % else:
                  <!-- For each claim and/or offer -->
                  % for claimOff in claimsAndOffs[row[0]]:
                    <tr>
                      <td></td>
                      
                      % if claimOff[5] == "Offer":
                        <!-- if this offer has not been accepted --> 
                        % if claimOff[2] == "Pending":
                          <td><strong>{{claimOff[0]}} made an offer of ${{claimOff[1]}}.</strong></td>
                        
                            <div>
                              <td>
                            <form method="get" action="/acceptoffer">
                              <input type="hidden" name="listingid" value={{row[0]}} />
                              <input type="hidden" name="offererid" value={{claimOff[0]}} />
                              <button class = "btn btn-default" type="submit">Accept Offer</button> <br>
                            </form>
                          </td>
                          <td>
                            <form method="get" action="/rejectoffer">
                              <input type="hidden" name="listingid" value={{row[0]}} />
                              <input type="hidden" name="offererid" value={{claimOff[0]}} />
                              <button class = "btn pull-right btn-default" type="submit">Reject Offer</button>
                            </form>
                          </td>
                          </div>
                          <td>
                            <form method="get" action="/makecounteroffer">
                              <input type="hidden" name="listingid" value={{row[0]}} />
                              <input type="hidden" name="offererid" value={{claimOff[0]}} />
                              <div class = "input-group">

                                  <input type="text" class="input form-control no-border thisfont" placeholder="$ Counter Offer" name="counterprice" required />
                                  <br>
                                  <span class="input-group-btn">
                                    &nbsp;
                                    <button class = "btn btn-default" type="submit">Go!</button>
                                  </span>
                            </div>
                            </form>
                          </td>
                        % end
                        % if claimOff[2] == "Countered":
                          <td colspan="4"><strong>You rejected {{claimOff[0]}}'s offer of ${{claimOff[1]}} and made a counter offer of ${{claimOff[3]}}.</strong></td>
                        % end
                        <!-- if this offer has been accepted --> 
                        % if claimOff[2] == "Accepted":
                          <td colspan="3"><strong>You have accepted {{claimOff[0]}}'s offer of ${{claimOff[1]}}.</strong></td>
                          <td>
                            <form method="get" action="/unacceptoffer">
                              <input type="hidden" name="listingid" value={{row[0]}} />
                              <input type="hidden" name="offererid" value={{claimOff[0]}} />
                              <button class = "btn btn-default" type="submit"><strong>Un-Accept Offer</strong></button>
                            </form>
                          </td>
                        % end
                        % if claimOff[2] == "Rejected":
                          <td colspan="2"><strong>You have rejected {{claimOff[0]}}'s offer of ${{claimOff[1]}}.</strong></td>
                          <td></td>
                          <td></td>
                        % end
                      <!-- If it's a claim -->
                      % else:
                        <td colspan="3"><strong>This listing was claimed by <a href="mailto:{{claimOff[0]}}@princeton.edu?subject=Pawswap Transaction&body=Hi, I noticed that you claimed my textbook on Pawswap, and I’m reaching out to finalize this transaction. Where/when should we meet to give you the book? We can discuss payment method too.

Let me know at your earliest convenience. Thank you!">{{claimOff[0]}}@princeton.edu </a>for ${{claimOff[1]}} and has been taken offline. If you can't complete the transaction, repost your listing.</strong></td>
                        <td>
                          <form method="get" action="/repost">
                            <input type="hidden" name="listingid" value={{row[0]}} />
                            <input type="hidden" name="offererid" value={{claimOff[0]}} />
                            <button class = "btn btn-default" type="submit"><strong>Repost</strong></button>
                          </form>
                        </td>
                      % end
                    </tr>
                  % end
                % end
              % end
            % end
            </table>
          </div>
        <div class="w3-container w3-padding-16">
        <nav class="thisfont text-center specific title">
          <strong> Books I've Claimed </strong>
       </nav>
        <table class="table table-hover table-striped thisfont">
            <tr>
              <!-- new way to list out the mylistings -->
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Title</th>
                <th>Listed Price</th>
                <th>Claimed Price</th>
            </tr>
            % if len(myClaims) == 0:
              <tr>
                <td colspan="6">You have not claimed any books</td>
              </tr>
            % else:
              % for row in myClaims:
                  <tr class = "clickable-row thisfont" data-href="/listingsdetails?listingid={{row[0]}}">
                      <td>{{row[1]}}</td>
                      <td>{{row[2]}}</td>
                      <td>{{row[3]}}</td>
                      <td>{{row[4]}}</td>
                      <td>${{row[5]}}</td>
                      <td>${{row[6]}}</td>
                  </tr>
                % end
              %end
          </table>
        </div>
        <div class="w3-container w3-padding-16">
        <nav class="thisfont text-center title specific">
          <strong> Offers I've Made </strong>
       </nav>
        <table class="table table-hover table-striped thisfont">
            <tr>
              <!-- new way to list out the mylistings -->
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Title</th>
                <th>Listed Price</th>
                <th>Your Offer</th>
                <th>Status</th>
            </tr>
            % if len(myOffers) == 0:
              <tr>
                <td colspan="7">You have not made any offers</td>
              </tr>
            % else:
              % for row in myOffers:
                <tr class = "clickable-row thisfont" data-href="/listingsdetails?listingid={{row[0]}}">
                  <td>{{row[1]}}</td>
                  <td>{{row[2]}}</td>
                  <td>{{row[3]}}</td>
                  <td>{{row[4]}}</td>
                  <td>${{row[5]}}</td>
                  <td>${{row[6]}}</td>
                  <td>{{row[7]}}</td>
                </tr>
                <!-- If this offer was accepted, display an option to claim at the accepted offer price -->
                % if row[7] == "Accepted":
                  <td></td>
                  <td colspan="5"><strong>The seller has accepted your offer</strong></td>
                  <td>
                    <form method="get" action="/claimlisting">
                      <input type="hidden" name="listingid" value={{row[0]}} />
                      <input type="hidden" name="price" value={{row[6]}} />
                      <button class = "btn btn-default" type="submit">Claim for ${{row[6]}}</button>
                    </form>
                  </td>
                % end
                % if row[7] == "Rejected":
                  <td></td>
                  <td></td>
                  <td></td>
                  <td colspan="2"><strong>The seller has rejected your offer. Would you like to make another offer?</strong></td>
                  <td colspan="2">
                    <form method="get" action="/makeoffer">
                      <input type="hidden" name="listingid" value={{row[0]}} />
                      <input type="hidden" name="price" value={{row[5]}} />
                      <button class = "btn btn-default" type="submit">Make Offer</button>
                      &nbsp; $<input type="text" placeholder="Offer" name="offerprice" required />
                    </form>
                  </td>
                % end
                % if row[7] == "Countered":
                  <td></td>
                  <td colspan="3"><strong>The seller has made a counter offer of ${{row[8]}}.</strong></td>
                  <td>
                    <form method="get" action="/claimlisting">
                      <input type="hidden" name="listingid" value={{row[0]}} />
                      <input type="hidden" name="price" value={{row[8]}} />
                      <button class = "btn btn-default" type="submit">Claim for ${{row[8]}}</button>
                    </form>
                  </td>
                  <td colspan="2">
                    <form method="get" action="/makeoffer">
                      <input type="hidden" name="listingid" value={{row[0]}} />
                      <input type="hidden" name="price" value={{row[5]}} />
                      <div class = "input-group">
                        <input type="text" class="input form-control no-border thisfont" placeholder="$ New Offer" name="offerprice" required />
                        <br>
                        <span class="input-group-btn">
                          &nbsp;
                          <button class = "btn btn-default" type="submit">Go!</button>
                        </span>
                      </div>
                  </td>
                  </form>
                % end
              % end
            %end
          </table>
        </div>
      <hr>
        <!-- Copyright -->
       <footer class="footer">
          <div class="footer-copyright text-center py-3">
            © 2018 Copyright: Reece Schachne, Ikaia Chu, David Bowman. <br>
            Please email pawswappu@gmail.com with questions, comments, or known bugs.
          </div>
       </footer>

      <script>
        jQuery(document).ready(function($) {
            $(".clickable-row").click(function() {
            window.location = $(this).data("href");
            });
        });
      </script>
    
   </body>
</html>