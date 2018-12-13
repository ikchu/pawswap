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
       .navbar {
        color: white;
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
        <br>
       <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
          Post New Textbook For Sale
       </nav>
    <hr>
    %if ({errorBool}):
        <strong>{{e}}</strong>
    %end
        
        <form class=container action="/createlisting" method="get">
        <table>
            <tr>
                <td>
                        <input type="text" placeholder="Your Name" name="name" value={{details[1]}}> <br>
                </td>
            </tr>
             <tr>
                <td>
                        <input type="text" placeholder="Email" name="email" value={{details[2]}}> <br>
                </td>
            </tr>
            <tr>
                <td>
                        <input type="text" placeholder="Textbook Name" name="bookname" value={{details[3]}}> <br>
                </td>
            </tr>
            <tr>
                <td>   
                    <input type="text" placeholder="Department"name="dept" value={{details[4]}}> <br>
                </td>
            </tr>
            <tr>
                <td>   
                    <input type="text" placeholder="Course Number" name="coursenum" value={{details[5]}}> <br>
                </td>
            </tr>
            <tr> <!-- ?? We want this to be not text input -->
                <td>   
                    <input type="text" placeholder="Condition" name="condition" value={{details[6]}}> <br>
                </td>
            </tr>
            <tr>
                <td>
                        <input type="text" placeholder="Price" name="price" value={{details[7]}}>
                </td>
            </tr>
            <tr> <!-- ?? We want this to be not text input -->
                <td>
                        <input type="text" placeholder="Negotiable?" name="negotiable" value={{details[8]}}> <br>
                </td>
            </tr>
            
            <tr>
                <td>
                    <input type="submit" value="Submit">
                </td>
            </tr>
        </table>
      </form>
    <hr>      