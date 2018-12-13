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

    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <!-- Custom fonts for this template -->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet">
    <link href="vendor/simple-line-icons/css/simple-line-icons.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">


    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
   <style>
       td, th {
           text-align: left;
       }   
       .header {
        font-family: "Verdana", Geneva, sans-serif;
       }
       .newlistingbutton {
        background-color: #EE7F2D;
        border: none;
        color: black;
        padding: 10px 20px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        cursor: pointer;
       }
       .accountbutton {
        background-color: #EE7F2D;
        border: none;
        float: right;
        color: black;
        padding: 10px 20px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        cursor: pointer;
       }
       .header {
        color: black;
        background-color: #EE7F2D;
        text-align: center;
       }
       .footer {
        color: black;
        background-color: #EE7F2D;
        text-align: center;
       }
       .center {
        background-color: #EE7F2D;
       }
   </style>
    <head>
      <title>PawSwap</title>
   </head>
   <body>
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>

    <div class="w3-container w3-padding-16">
      <form action="/mainpage" method="get">
          <table class="w3-table-all">
              <tr>
                  <td>Department: </td>
                  <td>   
                      <input type="text" name="dept" value={{dept}}> <br>
                  </td>
              </tr>
              <tr>
                  <td>Course Number: </td>
                  <td>
                      <input type="text" name="coursenum" value={{coursenum}}>
                  </td>
              </tr>
              <tr>
                  <td>Title: </td>
                  <td>
                      <input type="text" name="coursetitle" value={{title}}>
                  </td>
              </tr>
              <tr>
                  <td>Textbook Name: </td>
                  <td>
                      <input type="text" name="bookname" value={{bookname}}>
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
    </div>
      <!-- PUT RESULTS IN HERE -->
    <div class="w3-container w3-padding-16">
        <table class="w3-table w3-striped w3-border">
            <tr>
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Name</th>
                <th>Price $</th>
            </tr>
             % if len(listings) == 0:
<!-- do something here? -->
<div align="center">There are no current listings.</div>
             % else:
             %    for row in listings:
                    <tr href="/listingsdetails?listingid={{row[0]}}">
                        <td><a href="/listingsdetails?listingid={{row[0]}}">{{row[1]}}</a></td>
                        <td>{{row[2]}}</td>
                        <td>{{row[3]}}</td>
                        <td>{{row[4]}}</td>
                        <td>{{row[5]}}</td>
                    </tr>
            
             %    end
             % end
       </table>
      <script>
          function classToggle() {
            const navs = document.querySelectorAll('.Navbar__Items')
            navs.forEach(nav => nav.classList.toggle('Navbar__ToggleShow'));
          }
          document.querySelector('.Navbar__Link-toggle')
            .addEventListener('click', classToggle);
      </script> 
   </body>
</html>