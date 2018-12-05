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
      .links {
         margin-right:20px;
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
         <div>
            <a class="links" href='/goToEditListing?listingid={{listingid}}'>Edit listing</a>
            <a class="links" href='/deletelisting?listingid={{listingid}}'>Delete listing</a>
         </div>
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
         <hr>
         <!-- SET THE COOKIES IN HERE< PUSH THE COOKIE VALUES INTO THE TEMPLATE AND USE THOESE VALUES TO SEND THE URL BACK -->
         Click here to go to <a href="/mainpage">main page</a>.
         % include('footer.tpl')
   </div>
      <!-- PUT IN COOKIE STUFF LATER -->
   </body>
</html>