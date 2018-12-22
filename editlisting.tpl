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
        .footer {
        color: white;
        background-color: #343a40;
        text-align: center;
        padding: 0px;
       }
       .container{
        padding: 0;
       }
        .title {
            color: black;
            background-color: #EE7F2D;
            text-align: center;
        } 
        .btn {
        background-color: #343a40;
        color: white;
       }
       .navbar {
        color: white;
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
      <nav class="navbar navbar-dark bg-dark">
          <a class="navbar-brand" href="/mainpage">PawSwap</a>
          <a class="navbar-brand" href="/account">My Account</a>
        </nav>
        <br>
       <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
          Edit Your Listing
       </nav>
    <hr>

    %if ({errorBool}):
        <strong>{{e}}</strong>
    %end
    
        <!-- can't add listingid and coursetitle in link below because they will be overwritten when form is submitted
            so need to add them manually as hidden fields -->  
        <form action="/editlisting" method="get">
        <input type="hidden" name="listingid" value={{listingid}} />
        <table>
            <tr>
                <td>Your Name: </td>
                <td>
                        <input type="text" name="name" value="{{details[1]}}" required> <br>
                </td>
            </tr>
             <tr>
                <td>Email: </td>
                <td>
                        <input type="text" name="email" value="{{details[2]}}" required> <br>
                </td>
            </tr>
            <tr>
                <td>Textbook Name: </td>
                <td>
                        <input type="text" name="bookname" value="{{details[3]}}" required> <br>
                </td>
            </tr>
            <tr>
                <td>Department (3 Letter Abbreviation): </td>
                <td>   
                    <input type="text" name="dept" value="{{details[4]}}" required> <br>
                </td>
            </tr>
            <tr>
                <td>Course Number: </td>
                <td>   
                    <input type="text" name="coursenum" value="{{details[5]}}" required> <br>
                </td>
            </tr>
             <!-- Skipping over details[5] which is coursetitle -->
            <tr>
                <td>Condition (New, Good, Fair, or Poor): </td>
                <td>   
                    <input type="text" name="condition" value="{{details[6]}}" required> <br>
                </td>
            </tr>
            <tr>
                <td>Price: </td>
                <td>
                        <input type="text" name="price" value="{{details[7]}}" required>
                </td>
            </tr>
            <tr> <!-- ?? We want this to be not text input -->
                <td>Is the Price Negotiable? (Yes or No): </td>
                <td>
                    <input type="radio" placeholder="Negotiable?" name="negotiable" value="Yes" checked="checked" required>
                    <input type="radio" placeholder="Negotiable?" name="negotiable" value="No"><br>
                </td>
            </tr>
            
            <tr>
                <td></td>
                <td>
                    <input class = "btn" type="submit" value="Confirm Edit">
                </td>
            </tr>
        </table>
      </form>
        <!-- Copyright -->
       <footer class="footer">
          <div class="footer-copyright text-center py-3">
            © 2018 Copyright:Reece Schachne, Ikaia Chu, David Bowman. <br>
            Please email pawswappu@gmail.com with questions, comments, or known bugs.
          </div>
       </footer>
    <hr>
       