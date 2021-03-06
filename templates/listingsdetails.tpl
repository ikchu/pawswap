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

    <!-- Custom fonts for this template -->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="vendor/simple-line-icons/css/simple-line-icons.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">
     <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Avenir">

<meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

   <style>
      h1{
          color: black;
      } 
      .container{
        padding: 0;
       }
      .title {
        color: black;
        background-color: #343a40;
        text-align: center;
        font-family: 'Avenir';
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
        font-family: 'Avenir';

       }
       .btn {
        background-color: #343a40;
        color: white;
        font-family: 'Avenir';
       }

       .thisfont {
        font-family: 'Avenir';
       }
       .specific {
        font-size: large;
       }

    </style>

   <head> 
<!--    !-- Global site tag (gtag.js) - Google Analytics
 -->  <script async src="https://www.googletagmanager.com/gtag/js?id=UA-131225117-1"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-131225117-1');
      </script> 
   </head>
   <body>
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-dark bg-dark thisfont">
        <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>

   %if errorBool == True:
      <div class="container thisfont">
         <br>
         <strong>{{e}}</strong>
      </div>
   %else:
      <!------------ Title ------------>
      <br>
      <nav class="thisfont text-center specific">
         %if relation == "My_Offer":
            <strong> Your Offer </strong>
         %end
         %if relation == "My_Claim":
            <strong> Your Claim </strong>
         %end
         %if relation == "My_Listing":
            <strong> Your Listing </strong>
         %end
         %if relation == "None":
            <strong> Listing Details </strong>
         %end
      </nav>
      <!------------ Message ------------>
      %if relation == "My_Offer":
         <div class="container thisfont">
            <hr>
            <strong> Your offer for this book is ${{claimOrOffer[6]}}. This offer can be viewed and updated from your Account page. </strong>
         </div>
      %end
      %if relation == "My_Claim":
         <div class="container thisfont">
            <hr>
            <strong> You've claimed this listing for ${{claimOrOffer[6]}}. This textbook has been added to your Claimed List. Please contact the seller at <a href="mailto:{{details[1]}}?subject=Pawswap Transaction&body=Hi, I’ve claimed your textbook on Pawswap, and I’m reaching out to finalize this transaction. Where/when could I retrieve the book from you? I’ll bring cash or you can provide your Venmo handle. 

Let me know at your earliest convenience. Thank you!">{{details[1]}}</a> to pay for and retrieve your book. </strong>
         </div>
      %end
   %end
   <!------------ BODY ------------>
   <div class="container thisfont">
      <hr>
      <strong> Name: </strong> {{details[0]}}<br>
      <strong> Email: </strong> {{details[1]}}<br>
      <strong> Textbook Name: </strong> {{details[2]}}<br>
      <strong> Department: </strong> {{details[3]}}<br>
      <strong> Course Number: </strong> {{details[4]}}<br>
      <strong> Course Title: </strong> {{details[5]}}<br>
      <strong> Condition: </strong> {{details[6]}}<br>
      <strong> Price: </strong> ${{details[7]}}<br>
      <br>
      <!------------ Buttons ------------>
      %if errorBool == True:
         <form method="get" action="/mainpage">
            <button class = "btn btn-default" type="submit">Return to Mainpage</button>
         </form>   
      %else:
         %if relation == "My_Offer":
            <form method="get" action="/claimlisting">
               <input type="hidden" name="listingid" value={{listingid}} />
               <input type="hidden" name="price" value={{details[7]}} />
               <button class = "btn btn-default" type="submit">Claim at Listed Price</button>
            </form>
            <br>
            <br>
            <form method="get" action="/makeoffer">
               <input type="hidden" name="listingid" value={{listingid}} />
               <input type="hidden" name="price" value={{details[7]}} />
               <button class = "btn btn-default" type="submit">Make Offer</button>
               &nbsp; $<input type="number" step="0.01" placeholder="Offer" name="offerprice" required />
            </form>
         %end
         %if relation == "My_Claim":
            <form method="get" action="/unclaimlisting">
               <input type="hidden" name="listingid" value={{listingid}} />
               <button class = "btn btn-default" type="submit">Unclaim Listing</button>
            </form>
         %end
         %if relation == "My_Listing":
            <a class="btn" href='/goToEditListing?listingid={{listingid}}'>Edit listing</a>
            <a class="btn" href='/deletelisting?listingid={{listingid}}'>Delete listing</a>
         %end
         %if relation == "None":
            <form method="get" action="/claimlisting">
               <input type="hidden" name="listingid" value={{listingid}} />
               <input type="hidden" name="price" value={{details[7]}} />
               <button class = "btn btn-default" type="submit">Claim at Listed Price</button>
            </form>
            <br>
            <div>
              By <strong>claiming</strong> a listing, you are agreeing to pay for it at the listed price. Upon claiming, the listing will be removed from the mainpage; you will still be able to view it from your Account.
            </div>
            
            <br>
            <br>
            <form method="get" action="/makeoffer">
               <input type="hidden" name="listingid" value={{listingid}} />
               <input type="hidden" name="price" value={{details[7]}} />
               <button class = "btn btn-default" type="submit">Make Offer</button>
               &nbsp; $<input type="number" step="0.01" placeholder="Offer" name="offerprice" required />
            </form>
            <br>
            <div>
              After <strong>making an offer</strong>, the seller will be notified, and will be able to view the status of your offer in your Account. Others can still make offers on the same listing.
            </div>
         %end
      %end
      <hr>
   </div>

   <!-- Copyright -->
   <footer class="footer">
      <div class="footer-copyright text-center py-3">
        © 2018 Copyright: Reece Schachne, Ikaia Chu, David Bowman. <br>
        Please email pawswappu@gmail.com with questions, comments, or known bugs.
      </div>
   </footer>
      <!-- PUT IN COOKIE STUFF LATER -->
   </body>
</html>