<!DOCTYPE html>
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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

    <!-- Custom styles for this template -->
    <link href="css/landing-page.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

   <style>
      h1{
          color: black;
          font-family: 'Avenir';
      } 
      .title {
        color: black;
        background-color: #EE7F2D;
        text-align: center;
        font-family: 'Avenir';
      }
      .container{
        padding: 0;
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
       .thisfont {
       	font-family: 'Avenir';
       }
       .specific {
       	font-size: large;
       }
    </style>
 
   <head>
           <!-- Global site tag (gtag.js) - Google Analytics -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=UA-131225117-1"></script>
        <script>
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());

          gtag('config', 'UA-131225117-1');
        </script>  
   </head>
   <body>
    <nav class="navbar navbar-dark bg-dark thisfont">
    	  <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
          <a class="navbar-brand" href="/mainpage">PawSwap</a>
          <a class="navbar-brand" href="/account">My Account</a>
        </nav>
        <br>
       <nav class="thisfont text-center title specific">
          <strong> Claimed Listing </strong>
       </nav>
  
      <div class="container thisfont">
         <hr>
            <strong>*You've claimed this listing for ${{claimprice}}. This textbook has been added to your Claimed List*</strong>
            <p>Please contact the seller at <strong>{{details[1]}}</strong> to pay and retrieve your book.</p>
               <strong> Name: </strong> {{details[0]}}<br>
               <strong> Email: </strong> {{details[1]}}<br>
               <strong> Textbook Name: </strong> {{details[2]}}<br>
               <strong> Department: </strong> {{details[3]}}<br>
               <strong> Course Number: </strong> {{details[4]}}<br>
               <strong> Course Title: </strong> {{details[5]}}<br>
               <strong> Price: </strong> {{details[6]}}<br>
               <strong> Condition: </strong> {{details[7]}}<br>
               <br>
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