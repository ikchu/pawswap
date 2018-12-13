 <div class= "header">
      <h1>Welcome To PAWSWAP</h1>
      <h2>Search Below to Find a Textbook for Sale</h2>
    </div>

    <hr>
          <!-- PUT RESULTS IN HERE -->
           <table class="w3-table-all">
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
           
       </hr>
