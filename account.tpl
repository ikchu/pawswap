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
          <h1>My Listings</h1>
       </div>

        <table>
            <tr>
                <th>Book Name</th>
                <th>Dept</th>
                <th>Coursenum</th>
                <th>Coursename</th>
                <th>Price</th>
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

       <div class="w3-container">
      <hr>
      
      <a href="/mainpage">Click here to go back to main page</a>.

      % include('footer.tpl')

    </div>
   </body>
</html>