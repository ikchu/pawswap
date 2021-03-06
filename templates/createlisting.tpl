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
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Avenir">

    <!-- Custom styles for this template -->
    <link href="css/landing-page.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <style>
        h1{
            font-family: 'Avenir';
            color: black;
          } 
       td, th {
           text-align: left;
       }   
       .container{
        padding: 0;
       }
       .top {
        color: black;
        font-family: 'Avenir';
        background-color: #343a40
        ;
        text-align: center;
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
        text-align: center;
       }
       .btn {
        color:white;
        font-family: 'Avenir';
        background-color: #343a40;
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
        .nego{
            color:grey;
        }
        .thisfont {
        	font-family: 'Avenir';
        	color: #343a40;
        }
        .specific{
        	font-size: large;
        }
        .thisfont {
       	font-family: 'Avenir';
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
      <title>PawSwap</title>
    </head>
    <body>
        <!-- Pawswap nav bar to go home -->
        <nav class="navbar navbar-dark bg-dark thisfont">
          <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
          <a class="navbar-brand" href="/mainpage">PawSwap</a>
          <a class="navbar-brand" href="/account">My Account</a>
        </nav>
        <br>
       <nav class="thisfont text-center title specific">
          <strong> New Listing </strong>
       </nav>
  
    %if errorBool == True:
      <div class="container thisfont">
         <br>
         <strong>{{e}}</strong>
         <br>
         <hr>
      </div>
    %end
        
        <form class=container action="/createlisting" method="get">
       
                    <input type="text" class="input form-control no-border thisfont" placeholder="Your Name" name="name" value="{{details[1]}}" required> 
                    <hr>
                    <input type="text" class="input form-control no-border thisfont" placeholder="Email" name="email" value="{{details[2]}}" required> 
                    <hr>
                    <input type="text" class="input form-control no-border thisfont" placeholder="Textbook Name" name="bookname" value="{{details[3]}}" required> 
                    <hr>
         
                    <input type="text" class="input form-control no-border thisfont" placeholder="Department (ex. COS)" name="dept" value="{{details[4]}}" required> 
                    <hr>
             
                    <input type="text" class="input form-control no-border thisfont" placeholder="Course Number (ex. 126)" name="coursenum" value="{{details[5]}}" required>
                    <hr> <!-- ?? We want this to be not text input -->
                
                    <input type="text" class="input form-control no-border thisfont" placeholder="Condition" name="condition" value="{{details[6]}}" required> 
                    <hr>
             
                    <input type="number" step="0.01" class="input form-control no-border thisfont" placeholder="Price (ex. 100)" name="price" value="{{details[7]}}" required>
                    <hr>
              
                    <input class = "btn" type="submit" value="Submit">
               
      </form>
      <br>
        <!-- Copyright -->
       <footer class="footer">
          <div class="footer-copyright text-center py-3">
            © 2018 Copyright: Reece Schachne, Ikaia Chu, David Bowman. <br>
            Please email pawswappu@gmail.com with questions, comments, or known bugs.
          </div>
       </footer>    