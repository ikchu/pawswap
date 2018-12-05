<!DOCTYPE html>
<html>
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
        background-color: #EE7F2D;
        text-align: center;

       }
    </style>

   <body>
    <div class="w3-container w3-padding-16">
       <div class= "title">
          <h1>My Listings</h1>
       </div>

        <table class="w3-table-all">
            <tr>
              <!-- new way to list out the mylistings -->
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Name</th>
                <th>Price</th>
            </tr>
             % if len(listings) == 0:
            <!-- do something here? -->
            <div align="center">There are no current listings.</div>
                         % else:
                         %    for row in listings:
                                <tr href="/accountlistingsdetails?listingid={{row[0]}}">
                                    <td><a href="/accountlistingsdetails?listingid={{row[0]}}">{{row[1]}}</a></td>
                                    <td>{{row[2]}}</td>
                                    <td>{{row[3]}}</td>
                                    <td>{{row[4]}}</td>
                                    <td>{{row[5]}}</td>
                                </tr>
                        
                         %    end
                         % end
            </table>
          </div>

       <div class="w3-container">
        <hr>
        
        <a href="/mainpage">Click here to go back to main page</a>.

        <div class= "footer">
          <hr>
            Created by
            Reece Schachne, David Bowman, and Ikaia Chu
          <hr>
        </div>
    </div>
   </body>
</html>