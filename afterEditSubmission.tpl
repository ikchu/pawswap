<!DOCTYPE html>
<!-- this is the details/edit page which appears after submission of listing -->
<html>
   <head>  
   </head>
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

   <style>
      h1{
          font-family: "Arial Black", Gadget, sans-serif;
          color: black;
      } 
    </style>
   <body>
       <h1>Your PawSwap Listing</h1>
      <hr>
        <!-- I don't think this is necessary % courseid, days, starttime, endtime, bldg, roomnum = details[0] -->
        <a href="/goToEditListing?listingid={{listingid}}">Click here to edit your listing</a>
        <br>
        <h2>Listing Details</h2>
            <strong> Name: </strong> {{details[1]}}<br>
            <strong> Email: </strong> {{details[2]}}<br>
            <strong> Textbook Name: </strong> {{details[3]}}<br>
            <strong> Department: </strong> {{details[4]}}<br>
            <strong> Course Number: </strong> {{details[5]}}<br>
            <strong> Course Title: </strong> {{coursetitle}}<br>
            <strong> Price: </strong> {{details[6]}}<br>
            <strong> Condition: </strong> {{details[7]}}<br>
            <strong> Price Negotiable: </strong> {{details[8]}}<br>
      <hr>
      <hr>
      <!-- SET THE COOKIES IN HERE< PUSH THE COOKIE VALUES INTO THE TEMPLATE AND USE THOESE VALUES TO SEND THE URL BACK -->
      Click here to do <a href='\mainpage'>another listing search</a>.
      % include('footer.tpl')
      <!-- PUT IN COOKIE STUFF LATER -->
   </body>
</html>