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
    <style>
        h1{
            font-family: "Arial Black", Gadget, sans-serif;
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
        text-align: center;
       }
       .btn {
        color:white;
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
    </style>
    <head>
      <title>PawSwap</title>
    </head>
    <body>
        <!-- Pawswap nav bar to go home -->
        <nav class="navbar navbar-dark bg-dark">
          <a class="navbar-brand" href="/mainpage">PawSwap</a>
          <a class="navbar-brand" href="/account">My Account</a>
        </nav>
        <br>
       <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
          Post New Textbook For Sale
       </nav>
    <hr>
    %if ({errorBool}):
        <strong>{{e}}</strong>
    %end
        
        <form class=container action="/createlisting" method="get">
       
                    <input type="text" class="input form-control no-border" placeholder="Your Name" name="name" value="{{details[1]}}" required> 
                    <hr>
          
                    <input type="text" class="input form-control no-border" placeholder="Email" name="email" value="{{details[2]}}" required> 
                    <hr>
        
                    <input type="text" class="input form-control no-border" placeholder="Textbook Name" name="bookname" value="{{details[3]}}" required> 
                    <hr>
         
                    <input type="text" class="input form-control no-border" placeholder="Department" name="dept" value="{{details[4]}}" required> 
                    <hr>
             
                    <input type="text" class="input form-control no-border" placeholder="Course Number" name="coursenum" value="{{details[5]}}" required>
                    <hr> <!-- ?? We want this to be not text input -->
                
                    <input type="text" class="input form-control no-border" placeholder="Condition" name="condition" value="{{details[6]}}" required> 
                    <hr>
             
                    <input type="text" class="input form-control no-border" placeholder="Price" name="price" value="{{details[7]}}" required>
                    <hr>

                    <div class= "nego"><!-- ?? We want this to be not text input -->
                      Is the price negotiable?
               
                        <input type="radio" placeholder="Negotiable?" name="negotiable" value="Yes" checked="checked" required> Yes
                        <input type="radio" placeholder="Negotiable?" name="negotiable" value="No"> No
                    </div>
                    <hr>
              
                    <input class = "btn" type="submit" value="Submit">
               
      </form>
      <br>
        <!-- Copyright -->
       <footer class="footer">
          <div class="footer-copyright text-center py-3">
            © 2018 Copyright:Reece Schachne, Ikaia Chu, David Bowman. <br>
            Please email pawswappu@gmail.com with questions, comments, or known bugs.
          </div>
       </footer>
    <hr>      