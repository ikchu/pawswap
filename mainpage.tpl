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
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Avenir">


    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
   <style>
       td, th {
           text-align: left;
       }   
       .header {
        font-family: 'Avenir';
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
        background-color: #343a40;
        border: none;
        font-family: 'Avenir';
        color: black;
        padding: 10px 20px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        cursor: pointer;
       }
       .accountbutton {
        background-color: #343a40;
        border: none;
        float: right;
        color: black;
        font-family: 'Avenir';
        padding: 10px 20px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        cursor: pointer;
       }
       .header {
        color: black;
        background-color: #343a40;
        text-align: center;
        font-family: 'Avenir';
       }
       .footer {
        color: white;
        background-color: #343a40;
        text-align: center;
        padding: 0px;
        font-family: 'Avenir';
       }
       .center {
        background-color: #343a40;
       }
       .container {
        text-align: center;

       }
       .btn {
        color: white;
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
        .navbar {
          display: flex;
          font-family: 'Avenir';
          flex-direction: row
          margin-left: 150px;
        }
        .thisfont {
          font-family: 'Avenir';
        }
        .specific {
          font-size: large;
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
   <body onLoad="getResults(); document.getElementById('dept').focus();">
    <!-- Pawswap nav bar to go home -->
    <nav class="navbar navbar-dark bg-dark thisfont">
      <a class="navbar-brand" href="/goToCreateListing">Sell a Textbook</a>
      <a class="navbar-brand" href="/mainpage">PawSwap</a>
      <a class="navbar-brand" href="/account">My Account</a>
    </nav>

    <div class="container thisfont">
        <br>
        <input type="text" class="input form-control no-border thisfont" placeholder="Search by Department" name="dept" oninput="getResults()" id='dept'>
        <hr>
        <input type="text" class="input form-control no-border thisfont" placeholder="Search by Course Number" name="coursenum" oninput="getResults()" id='coursenum'>
        <hr>
        <input type="text" class="input form-control no-border thisfont" placeholder="Search by Course Title" name="coursetitle" oninput="getResults()" id='coursetitle'>
        <hr>
        <input type="text" class="input form-control no-border thisfont" placeholder="Search by Textbook Name" name="bookname" oninput="getResults()" id='bookname'>
        <hr>
    </div>
      <!-- PUT RESULTS IN HERE -->
    <div class="container thisfont">
        <table class="table table-hover table-striped" id="resultsTable">
        </table>
    </div>

       <!-- Copyright -->
       <footer class="footer">
          <div class="footer-copyright text-center py-3">
            © 2018 Copyright: Reece Schachne, Ikaia Chu, David Bowman. <br>
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