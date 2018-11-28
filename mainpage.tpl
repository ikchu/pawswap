<!DOCTYPE html>
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
   <style>
       td, th {
           text-align: left;
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
        color: black;
        background-color: #EE7F2D;
        text-align: center;
       }
       .center {
        background-color: #EE7F2D;
       }
   </style>
    <head>
      <title>PawSwap</title>
   </head>
   <body>
    <div class= "header">
      <h1>Welcome to PawSwap!</h1>
      <h2>Search Listings by Dept, Course Number, Title, or Textbook Name</h2>
    </div>
    <hr>
    
    <div class="newlistingbutton">
      <a href="/goToCreateListing" class="button">Create New Listing</a>
    </div>

    <div class = "accountbutton">
      <a href="/account" class="button" style="float: right;">My Account</a>
    </div>

    <form action="/mainpage" method="get">
        <table class="w3-table-all">
            <tr>
                <td>Department: </td>
                <td>   
                    <input type="text" name="dept" value={{dept}}> <br>
                </td>
            </tr>
            <tr>
                <td>Course Number: </td>
                <td>
                    <input type="text" name="coursenum" value={{coursenum}}>
                </td>
            </tr>
            <tr>
                <td>Title: </td>
                <td>
                    <input type="text" name="coursetitle" value={{title}}>
                </td>
            </tr>
            <tr>
                <td>Textbook Name: </td>
                <td>
                    <input type="text" name="bookname" value={{bookname}}>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input type="submit" value="Submit">
          
                </td>
            </tr>
        </table>
      </form>
    <hr>
      <!-- PUT RESULTS IN HERE -->
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

      <div class= "footer">
        <hr>
          Created by
          Reece Schachne, David Bowman, and Ikaia Chu
        <hr>
      </div>
   </body>
</html>