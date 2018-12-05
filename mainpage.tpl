<!DOCTYPE html>
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
   <style>
       td, th {
           text-align: left;
       }   
       .header {
        font-family: "Verdana", Geneva, sans-serif;
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
   <body  onLoad="document.getElementById('area').focus(); getResults()">
    <div class= "header">
      <h1>Welcome To PAWSWAP</h1>
      <h2>Search Below to Find a Textbook for Sale</h2>
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
    <div class="w3-container w3-padding-16">
        <table class="w3-table w3-striped w3-border">
            <tr>
                <th>Book Name</th>
                <th>Department</th>
                <th>Course Number</th>
                <th>Course Name</th>
                <th>Price $</th>
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
<<<<<<< HEAD
       <div class="w3-container">
        <p id="resultsParagraph"></p>
      <!-- PUT RESULTS IN HERE -->

    </div>
       <script>
       function createAjaxRequest()  // From Nixon book
         {
            console.log("in createAjaxRequest")
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
            console.log("in pRSC")
            const STATE_UNINITIALIZED = 0;
            const STATE_LOADING       = 1;
            const STATE_LOADED        = 2;
            const STATE_INTERACTIVE   = 3;
            const STATE_COMPLETED     = 4;
            
            if (this.readyState != STATE_COMPLETED)
               return;
            
            if (this.status != 200)  // Request succeeded?
            {  
               //alert(
               //   "AJAX error: Request failed: " + this.statusText);
               return;
            }
            
            if (this.responseText == null)  // Data received?
            {  
               alert("AJAX error: No data received");
               return;
            }
             
            console.log("after ifs")
            let resultsParagraph = 
               document.getElementById("resultsParagraph");
            resultsParagraph.innerHTML = this.responseText;
         }

         let date = new Date();
         let seed = date.getSeconds();
         let request = null;
         
         function getResults()
         {
            console.log("in getResults")
            let area = document.getElementById('area').value;
            area = encodeURIComponent(area);
            let coursenum = document.getElementById('coursenum').value;
            coursenum = encodeURIComponent(coursenum);
            let dept = document.getElementById('dept').value;
            dept = encodeURIComponent(dept);
            let title = document.getElementById('title').value;
            title = encodeURIComponent(title);
            let messageId = Math.floor(Math.random(seed) * 1000000) + 1;
            let url = "/searchhtml?area=" + area + "&coursenum=" + coursenum + "&dept=" + dept + "&title=" + title + "&messageId=" + messageId;
               
            if (request != null)
               request.abort();
            
            request = createAjaxRequest();
            if (request == null) return;
            request.onreadystatechange = processReadyStateChange;
            request.open("GET", url);
            request.send(null);
         }
       </script>

=======
    </div>
>>>>>>> 4ee589bcb6c9cb64f6fdc8b10b7e89093b0dab87
      <div class= "footer">
        <hr>
          Created by
          Reece Schachne, David Bowman, and Ikaia Chu
        <hr>
      </div>
   </body>
</html>