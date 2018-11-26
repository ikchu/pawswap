<!DOCTYPE html>
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
   <style>
       td, th {
           text-align: left;
       }   
   </style>
    <head>
      <title>PawSwap</title>
   </head>
   <body>
    <div class= "w3-container w3-center w3-deep-orange">
      <h1>Welcome to PawSwap!</h1>
      <h2>Search Listings by Dept, Course Number, Title, or Textbook Name</h2>
    </div>
    <hr>
    
    <!-- DIDNT DO THIS CORRECTLY -->
    <a href="/goToCreateListing" class="button">Create New Listing</a>
    
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

      <!-- PUT IN COOKIE STUFF LATER -->
      % include('footer.tpl')
   </body>
</html>