<!DOCTYPE html>
<!-- this is the details/edit page which appears after submission of listing -->
<html>
   <head>  
   </head>
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

   <style>
        .footer {
          color: black;
          background-color: #EE7F2D;
          text-align: center;
        }
        .title {
        color: black;
        background-color: #EE7F2D;
        text-align: center;
        } 
    </style>
   <body>
       <h1 class = title>Your PawSwap Listing</h1>
      <hr>
        <!-- I don't think this is necessary % courseid, days, starttime, endtime, bldg, roomnum = details[0] -->
        <a href="/goToEditListing?listingid={{details[10]}}">Click here to edit your listing</a>
        <br>
        <h2>Listing Details</h2>
            <strong> Name: </strong> {{details[1]}}<br>
            <strong> Email: </strong> {{details[2]}}<br>
            <strong> Textbook Name: </strong> {{details[3]}}<br>
            <strong> Department: </strong> {{details[4]}}<br>
            <strong> Course Number: </strong> {{details[5]}}<br>
            <strong> Course Title: </strong> {{details[9]}}<br>
            <strong> Condition: </strong> {{details[6]}}<br>
            <strong> Price: </strong> {{details[7]}}<br>
            <strong> Price Negotiable: </strong> {{details[8]}}<br>
      <hr>
      <hr>
      <!-- SET THE COOKIES IN HERE< PUSH THE COOKIE VALUES INTO THE TEMPLATE AND USE THOESE VALUES TO SEND THE URL BACK -->
      Click here to do <a href='\mainpage'>another listing search</a>.
      <div class= "footer">
        <hr>
          Created by
          Reece Schachne, David Bowman, and Ikaia Chu
        <hr>
      </div>
      <!-- PUT IN COOKIE STUFF LATER -->
   </body>
</html>