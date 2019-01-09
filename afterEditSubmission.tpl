<!DOCTYPE html>
<!-- this is the details/edit page which appears after submission of listing -->
<html>
   <head>
   <!--    !-- Global site tag (gtag.js) - Google Analytics
 -->  <script async src="https://www.googletagmanager.com/gtag/js?id=UA-131225117-1"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'UA-131225117-1');
      </script>   
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>PawSwap</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Avenir">

    <link href="vendor/bootstrap/css/bootstrap.css" rel="stylesheet">

    <!-- Custom fonts for this template -->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="vendor/simple-line-icons/css/simple-line-icons.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">

   </head>
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

   <style>
        .footer {
          color: white;
          background-color: #343a40;
          text-align: center;
          font-family: 'Avenir';
          padding: 0px;
       }
       .container{
        padding: 0;
       }
        .title {
        color: black;
        font-family: 'Avenir';
        background-color: #EE7F2D;
        text-align: center;
        } 
        .btn {
        background-color: #343a40;
        color: white;
        font-family: 'Avenir';
       }
       .navbar {
        color: white;
        font-family: 'Avenir';
       }
       .thisfont {
        font-family: 'Avenir';
       }
    </style>
   <body>
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-dark bg-dark thisfont">
      <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>
    <br>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
     <strong> Your Listing </strong>
    </nav>
      <hr>
        <a class = "btn thisfont" href="/goToEditListing?listingid={{details[10]}}">Click here to edit your listing</a>
        <br>
        <div class= "thisfont">
            <strong> Name: </strong> {{details[1]}}<br>
            <strong> Email: </strong> {{details[2]}}<br>
            <strong> Textbook Name: </strong> {{details[3]}}<br>
            <strong> Department: </strong> {{details[4]}}<br>
            <strong> Course Number: </strong> {{details[5]}}<br>
            <strong> Course Title: </strong> {{details[9]}}<br>
            <strong> Condition: </strong> {{details[6]}}<br>
            <strong> Price: </strong> {{details[7]}}<br>
        </div>
      <hr>
      <hr>
        <!-- Copyright -->
       <footer class="footer">
          <div class="footer-copyright text-center py-3">
            © 2018 Copyright: Reece Schachne, Ikaia Chu, David Bowman. <br>
            Please email pawswappu@gmail.com with questions, comments, or known bugs.
          </div>
       </footer>
   </body>
</html>