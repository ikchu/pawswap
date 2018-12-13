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
        background-color: #EE7F2D;
        text-align: center;
      }
      .footer {
        color: white;
        background-color: #343a40;
        text-align: center;
        padding: 0px;
       }
       .navbar {
        color: white;

       }
       .btn {
        background-color: #343a40;
        color: white;
       }
    </style>

   <head>  
   </head>
   <body>
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-dark bg-dark">
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>
    
    <br>
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        Listing Details
      </nav>
      

      <div class="container">
         <hr>
               <strong> Name: </strong> {{details[0]}}<br>
               <strong> Email: </strong> {{details[1]}}<br>
               <strong> Textbook Name: </strong> {{details[2]}}<br>
               <strong> Department: </strong> {{details[3]}}<br>
               <strong> Course Number: </strong> {{details[4]}}<br>
               <strong> Course Title: </strong> {{details[5]}}<br>
               <strong> Condition: </strong> {{details[6]}}<br>
               <strong> Price: </strong> {{details[7]}}<br>
               <strong> Price Negotiable: </strong> {{details[8]}}<br>
               <br>
            <!-- if claimed then give option to unclaim (details[9] is 'claimed')-->
            % if claimed==0:
               <form method="get" action="/claimlisting">
                  <input type="hidden" name="listingid" value={{listingid}} />
                  <input type="hidden" name="price" value={{details[7]}} />
                  <button class = "btn btn-default" type="submit">Claim at Listed Price</button>
               </form>
               <br>
               OR
               <br>
               <br>
               <form method="get" action="/makeoffer">
                  <input type="hidden" name="listingid" value={{listingid}} />
                  <button class = "btn btn-default" type="submit">Make Offer</button>
                  &nbsp; $<input type="text" placeholder="Offer" name="offerprice" required />
               </form>
            % end
            % if claimed==1:
               <form method="get" action="/unclaimlisting">
                  <input type="hidden" name="listingid" value={{listingid}} />
                  <button class = "btn btn-default" type="submit">Unclaim Listing</button>
               </form>
            % end
         <hr>
         <!-- SET THE COOKIES IN HERE< PUSH THE COOKIE VALUES INTO THE TEMPLATE AND USE THOESE VALUES TO SEND THE URL BACK -->
        
   </div>
 <!-- Copyright -->
   <footer class="footer">
      <div class="footer-copyright text-center py-3">
        © 2018 Copyright:Reece Schachne, Ikaia Chu, David Bowman. <br>
        Please email pawswappu@gmail.com with questions, comments, or known bugs.
      </div>
   </footer>
      <!-- PUT IN COOKIE STUFF LATER -->
   </body>
</html>