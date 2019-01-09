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
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Avenir">

    <!-- Custom styles for this template -->
    <link href="css/landing-page.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <style>
        .footer {
        color: white;
        background-color: #343a40;
        text-align: center;
        padding: 0px;
        font-family: 'Avenir';
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
       .input:focus {
        outline:none;
        border:0;
        box-shadow:none;
        max-width: 500px;
        }
       .no-border {
          border: 0;
          max-width: 500px;
          box-shadow: none; /* You may want to include this as bootstrap applies these styles too */
        }
        .form-control {
          border: 0;
          max-width: 500px;
        }

       .navbar {
        color: white;
        font-family: 'Avenir';
       }
       .thisfont {
        font-family: 'Avenir';
       }
       .specific {
        font-size: large;
       }
       td, th {
           text-align: left;
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
      <nav class="navbar navbar-dark bg-dark thisfont">
          <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
          <a class="navbar-brand" href="/mainpage">PawSwap</a>
          <a class="navbar-brand" href="/account">My Account</a>
        </nav>
        <br>
       <nav class="thisfont text-center specific">
          <strong> Edit Your Listing </strong>
       </nav>
    <hr>

    %if ({errorBool}):
        <strong>{{e}}</strong>
    %end
    
        <!-- can't add listingid and coursetitle in link below because they will be overwritten when form is submitted
            so need to add them manually as hidden fields -->  
        <form class = "container" action="/editlisting" method="get">
        <input type="hidden" name="listingid" value={{listingid}} />

        
              <div class = "thisfont form-row">
                <label for = "thisname"> <strong> Your Name: </strong>  </div>
                  <div class = "col-md-6"> <input id = "thisname" type="text" class="input form-control no-border thisfont" name="name" value="{{details[1]}}" required>
              </div>
           
              <div class="thisfont form-row ">
                <label for = "thisemail"> <strong> Email: </strong> </div>
                    <div class = "col-md-6"> <input id = "thisemail" type="text" class="input form-control no-border thisfont " name="email" value="{{details[2]}}" required> 
              </div>

              <div class="thisfont form-row ">
                <label for = "thistext"> <strong> Textbook Name: </strong> </div>
                    <div class = "col-md-6"> <input id = "thistext" type="text" class="input form-control no-border thisfont " name="textbook" value="{{details[3]}}" required> 
              </div>
 
              <div class="thisfont form-row ">
                <label for = "thisdep"> <strong> Department (3 Letter Abbreviation) </strong> </div>
                    <div class = "col-md-6"> <input id = "thisdep" type="text" class="input form-control no-border thisfont " name="dept" value="{{details[4]}}" required> 
              </div>
           
              <div class="thisfont form-row "> 
                <label for="thiscourse"> <strong> Course Number: </strong> </div> 
                    <div class = "col-md-6"> <input id="thiscourse" type="text" class="input form-control no-border thisfont" name="coursenum" value="{{details[5]}}" required>
              </div> 
           
              <div class="thisfont form-row "> 
                <label for="thiscon"> <strong> Condition (New, Good, Fair, or Poor): </strong> </div>
                  <div class = "col-md-6"> <input id = "thiscond" type="text" class="input form-control no-border thisfont" name="condition" value="{{details[6]}}" required> 
              </div> 
       
              <div class="thisfont form-row "> 
                <label for="thisp"> <strong> Price: </strong> </div>
                  <div class = "col-md-6"> <input id = "thisp" type="text" class="input form-control no-border thisfont" name="price" value="{{details[7]}}" required> 
              </div> 
         
              </label>
              </div>

              <div class = "container">
                  <input class = "btn" type="submit" value="Confirm Edit"> <br>
              </div> <hr>
          
      </form>
      <br>
        <!-- Copyright -->
       <footer class="footer">
          <div class="footer-copyright text-center py-3">
            © 2018 Copyright: Reece Schachne, Ikaia Chu, David Bowman. <br>
            Please email pawswappu@gmail.com with questions, comments, or known bugs.
          </div>
       </footer>
       