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
       .container{
        padding: 0;
       }
       .input:focus {
        outline:none;
        border:0;
        box-shadow:none;
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
        color: white;
        background-color: #343a40;
        text-align: center;
        padding: 0px;
       }
       .center {
        background-color: #EE7F2D;
       }
       .container {
        text-align: center;

       }
       .btn {
        color: white;
        background-color: #343a40;
       }
       .no-border {
          border: 0;
          box-shadow: none; /* You may want to include this as bootstrap applies these styles too */
        }
        .form-control {
          border: 0;
        }
        .navbar {
          display: flex;
          flex-direction: row
          margin-left: 150px;
        }
   </style>
    <head>
      <title>PawSwap</title>
   </head>
   <body>
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-dark bg-dark">
      <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>

    <div class="container">
      <form action="/mainpage" method="get">
                      <br>
                      <input type="text" class="input form-control no-border" placeholder="Department" name="dept" value={{dept}} >
                      <hr>
                      <input type="text" class="input form-control no-border" placeholder="Course Number" name="coursenum" value={{coursenum}}>
                      <hr>
                      <input type="text" class="input form-control no-border" placeholder="Course Title" name="coursetitle" value={{title}}>
                      <hr>
                      <input type="text" class="input form-control no-border" placeholder="Textbook Name" name="bookname" value={{bookname}}>
                      <hr>
                  </td>
              </tr>
          

          </table>

          <input class = "btn" type="submit" value="Search">
        </form>
      <hr>
    </div>
      <!-- PUT RESULTS IN HERE -->
    <div class="container">
        <table class="table table-hover table-striped">
            <tr>
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Name</th>
                <th>Price</th>
            </tr>
             % if len(listings) == 0:
<!-- do something here? -->
            <tr>
                <th></th>
                <th></th>
                <th>There are no current listings.</th>
                <th></th>
                <th></th>
            </tr>
             % else:
             %    for row in listings:
                    <tr class = "clickable-row" data-href="/listingsdetails?listingid={{row[0]}}&mpHotFix=True">
                        <td>{{row[1]}}</td>
                        <td>{{row[2]}}</td>
                        <td>{{row[3]}}</td>
                        <td>{{row[4]}}</td>
                        <td>$ {{row[5]}}</td>
                    </tr>
            
             %    end
             % end
       </table>
     </div>

       <!-- Copyright -->
       <footer class="footer">
          <div class="footer-copyright text-center py-3">
            © 2018 Copyright:Reece Schachne, Ikaia Chu, David Bowman. <br>
            Please email pawswappu@gmail.com with questions, comments, or known bugs.
          </div>
       </footer>
    
    
      <script>
        jQuery(document).ready(function($) {
            $(".clickable-row").click(function() {
            window.location = $(this).data("href");
            });
        });
          function classToggle() {
            const navs = document.querySelectorAll('.Navbar__Items')
            navs.forEach(nav => nav.classList.toggle('Navbar__ToggleShow'));
          }
          document.querySelector('.Navbar__Link-toggle')
            .addEventListener('click', classToggle);
      </script> 

   </body>

</html>