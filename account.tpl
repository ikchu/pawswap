<!DOCTYPE html>
<html>
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
   <head>
      <title>MyAccount</title>
   </head>
   <style>
      h1{
          font-family: "Arial Black", Gadget, sans-serif;
          color: black;
      } 
    </style>

   <body>
       <div class= "w3-container w3-center w3-deep-orange">
          <h1>Welcome {{username}}!</h1>
          <h2>Below are your listings.  </h2>
           </h1>
       </div>
       <div class="w3-container">
      <hr>
      
      % include('footer.tpl')

    </div>
   </body>
</html>