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
   <body onLoad="getResults(); document.getElementById('dept').focus();">
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-dark bg-dark">
      <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>

    <div class="container">
                      <br>
                      <input type="text" class="input form-control no-border" placeholder="Department" name="dept" oninput="getResults()" id='dept'>
                      <hr>
                      <input type="text" class="input form-control no-border" placeholder="Course Number" name="coursenum" oninput="getResults()" id='coursenum'>
                      <hr>
                      <input type="text" class="input form-control no-border" placeholder="Course Title" name="coursetitle" oninput="getResults()" id='coursetitle'>
                      <hr>
                      <input type="text" class="input form-control no-border" placeholder="Textbook Name" name="bookname" oninput="getResults()" id='bookname'>
                      <hr>
      <hr>
    </div>
      <!-- PUT RESULTS IN HERE -->
    <div class="container">
        <table class="table table-hover table-striped" id="resultsTable">
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

    <script>
        function createAjaxRequest()  // From Nixon book
            {
                let req;
                        
                try  // Some browser other than Internet Explorer
                {
                    req = new XMLHttpRequest();
                }
                    catch (e1) 
                    {    
                        try  // Internet Explorer 6+
                        {
                            req = new ActiveXObject("Msxml2.XMLHTTP");
                        }
                        catch (e2) 
                        {  
                            try  // Internet Explorer 5
                            { 
                                req = new ActiveXObject("Microsoft.XMLHTTP"); 
                            }
                            catch (e3)
                            {  
                                req = false;
                            }
                        }
                    }
                return req;
            }

            function processReadyStateChange()
            {
                const STATE_UNINITIALIZED = 0;
                const STATE_LOADING       = 1;
                const STATE_LOADED        = 2;
                const STATE_INTERACTIVE   = 3;
                const STATE_COMPLETED     = 4;
            
                if (this.readyState != STATE_COMPLETED)
                { return; }
                
                if (this.status != 200)  // Request succeeded?
                {  
                alert("AJAX error: Request failed: " + this.statusText);
                return;
                }
                
                if (this.responseText == null)  // Data received?
                {  
                alert("AJAX error: No data received");
                return;
                }
                console.log('called theresultsTable pawswap!');
                var resultsListings = document.getElementById('resultsTable');
                resultsListings.innerHTML = this.responseText;
            }

            var date = new Date();
            var seed = date.getSeconds();
            var request = null;
            
            function getResults()
            {
                console.log('getResults is being called');
                var dept = document.getElementById('dept').value;
                var coursenum = document.getElementById('coursenum').value;
                var coursetitle = document.getElementById('coursetitle').value;
                var bookname = document.getElementById('bookname').value;
                dept = encodeURIComponent(dept);
                coursenum = encodeURIComponent(coursenum);
                coursetitle = encodeURIComponent(coursetitle);
                bookname = encodeURIComponent(bookname);
                var messageId = Math.floor(Math.random(seed) * 1000000) + 1;
                var url = '/searchresults?dept=' + dept + '&coursenum=' + coursenum + '&coursetitle=' + coursetitle + '&bookname=' + bookname + '&messageId=' + messageId;
                if (request != null)
                    request.abort();
    
                request = createAjaxRequest();
                if (request == null) return;
                request.onreadystatechange = processReadyStateChange;
                request.open("GET", url);
                request.send(null);
            }

      </script> 

   </body>
</html>