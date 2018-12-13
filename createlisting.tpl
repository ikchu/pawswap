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
       .top {
        color: black;
        background-color: #EE7F2D;
        text-align: center;
       }
       .footer {
        color: black;
        background-color: #EE7F2D;
        text-align: center;
       }
    </style>
    <head>
      <title>PawSwap</title>
    </head>
    <body>
        <!-- Pawswap nav bar to go home -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
          <a class="navbar-brand" href="/mainpage">PawSwap</a>
          <a class="navbar-brand" href="/account">My Account</a>
        </nav>

        <div class= "top">
            <h2>Post New Textbook for Sale</h2>
        </div>
    <hr>
    %if ({errorBool}):
        <strong>{{e}}</strong>
    %end
    
        <form action="/createlisting" method="get">
        <table>
            <tr>
                <td>Your Name: </td>
                <td>
                        <input type="text" name="name" value={{details[1]}}> <br>
                </td>
            </tr>
             <tr>
                <td>Email: </td>
                <td>
                        <input type="text" name="email" value={{details[2]}}> <br>
                </td>
            </tr>
            <tr>
                <td>Textbook Name: </td>
                <td>
                        <input type="text" name="bookname" value={{details[3]}}> <br>
                </td>
            </tr>
            <tr>
                <td>Department (3 Letter Abbreviation): </td>
                <td>   
                    <input type="text" name="dept" value={{details[4]}}> <br>
                </td>
            </tr>
            <tr>
                <td>Course Number: </td>
                <td>   
                    <input type="text" name="coursenum" value={{details[5]}}> <br>
                </td>
            </tr>
            <tr> <!-- ?? We want this to be not text input -->
                <td>Condition (New, Good, Fair, or Poor): </td>
                <td>   
                    <input type="text" name="condition" value={{details[6]}}> <br>
                </td>
            </tr>
            <tr>
                <td>Price: </td>
                <td>
                        <input type="text" name="price" value={{details[7]}}>
                </td>
            </tr>
            <tr> <!-- ?? We want this to be not text input -->
                <td>Is the Price Negotiable? (Yes or No): </td>
                <td>
                        <input type="text" name="negotiable" value={{details[8]}}> <br>
                </td>
            </tr>
            
            <tr>
                <td></td>
                <td>
                    <input type="submit" value="Submit">
                </td>
            </tr>
        </table>
      </form>
    <hr>
<!-- do something here? -->

Click here to <a href="/mainpage">go back to main page</a>.
    <div class= "footer">
        <hr>
          Created by
          Reece Schachne, David Bowman, and Ikaia Chu
        <hr>
    </div>
       