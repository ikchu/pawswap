<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

   <style>
      h1{
          color: black;
      } 
      .title {
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
   </head>
   <body>
      <div class= "title">
         <h1>PawSwap Listing</h1>
       </div>
      <div class="w3-container">
         <hr>
           <h2>Listing Details</h2>
               <strong> Name: </strong> {{details[0]}}<br>
               <strong> Email: </strong> {{details[1]}}<br>
               <strong> Textbook Name: </strong> {{details[2]}}<br>
               <strong> Department: </strong> {{details[3]}}<br>
               <strong> Course Number: </strong> {{details[4]}}<br>
               <strong> Course Title: </strong> {{details[5]}}<br>
               <strong> Price: </strong> {{details[6]}}<br>
               <strong> Condition: </strong> {{details[7]}}<br>
               <strong> Price Negotiable: </strong> {{details[8]}}<br>
               <br>
            <form method="get" action="/claimlisting">
               <input type="hidden" name="listingid" value={{listingid}} />
               <button type="submit">Claim Listing</button>
            </form>
         <hr>
         <!-- SET THE COOKIES IN HERE< PUSH THE COOKIE VALUES INTO THE TEMPLATE AND USE THOESE VALUES TO SEND THE URL BACK -->
         <a href="/mainpage">Click here to go back to the main page</a>.
          <div class= "footer">
            <hr>
            Created by
            Reece Schachne, David Bowman, and Ikaia Chu
            <hr>
        </div>
   </div>
      <!-- PUT IN COOKIE STUFF LATER -->
   </body>
</html>