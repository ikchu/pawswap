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
   <head>
      <title>My Account</title>
   </head>

   <style>
      h1{
          color: black;
      } 
      .title {
        color: #FFFFFF;
        background-color: #EE7F2D;
        text-align: center;
      }
      .footer {
        color: black;
        background-color: ##555555;
        text-align: center;

       }
       .navbar {
        color: white;
        text-align: center;
       }
    </style>

   <body>
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>

    <div class="w3-container w3-padding-16">
       <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
          My Listings
       </nav>
        <table class="table table-hover table-striped">
            <tr>
              <!-- new way to list out the mylistings -->
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Name</th>
                <th>Price $</th>
            </tr>
            % if len(listings) == 0:
              <!-- do something here? -->
              <div align="center">You have no current listings.</div>
            % else:
            %    for row in listings:
                  <tr class = "clickable-row" data-href="/accountlistingsdetails?listingid={{row[0]}}">
                      <td>{{row[1]}}</td>
                      <td>{{row[2]}}</td>
                      <td>{{row[3]}}</td>
                      <td>{{row[4]}}</td>
                      <td>{{row[5]}}</td>
                  </tr>
            %    end
            % end
            </table>
          </div>
        <div class="w3-container w3-padding-16">
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
          My Claims
       </nav>
        <table class="table table-hover table-striped">
            <tr>
              <!-- new way to list out the mylistings -->
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Name</th>
                <th>Price $</th>
            </tr>
            % if len(claims) == 0:
            <div align="center">You have no current claims.</div>
            % else:
              % for row in claims:
                  <tr class = "clickable-row" data-href="/listingsdetails?listingid={{row[0]}}">
                      <td>{{row[1]}}</td>
                      <td>{{row[2]}}</td>
                      <td>{{row[3]}}</td>
                      <td>{{row[4]}}</td>
                      <td>{{row[5]}}</td>
                  </tr>
                % end
              %end
          </table>
        </div>
      <hr>
      <script>
        jQuery(document).ready(function($) {
            $(".clickable-row").click(function() {
            window.location = $(this).data("href");
            });
        });
      </script>
    
   </body>
</html>