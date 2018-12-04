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
      <h1>Post New Textbook for Sale</h2>
    <hr>

    %if ({errorBool}):
        <strong>{{e}}</strong>
    %end
    
        <!-- can't add listingid and coursetitle in link below because they will be overwritten when form is submitted
            so need to add them manually as hidden fields -->  
        <form action="/editlisting" method="get">
        <input type="hidden" name="listingid" value={{listingid}} />
        <table>
            <tr>
                <td>Your Name: </td>
                <td>
                        <input type="text" name="name" value={{details[1]}}> <br>
                </td>
            </tr>
             <tr>
                <td>Email: </td>
                <td>
                        <input type="text" name="email" value={{details[2]}}> <br>
                </td>
            </tr>
            <tr>
                <td>Textbook Name: </td>
                <td>
                        <input type="text" name="bookname" value={{details[3]}}> <br>
                </td>
            </tr>
            <tr>
                <td>Department (3 Letter Abbreviation): </td>
                <td>   
                    <input type="text" name="dept" value={{details[4]}}> <br>
                </td>
            </tr>
            <tr>
                <td>Course Number: </td>
                <td>   
                    <input type="text" name="coursenum" value={{details[5]}}> <br>
                </td>
            </tr>
             <!-- Skipping over details[5] which is coursetitle -->
            <tr>
                <td>Condition (New, Good, Fair, or Poor): </td>
                <td>   
                    <input type="text" name="condition" value={{details[6]}}> <br>
                </td>
            </tr>
            <tr>
                <td>Price: </td>
                <td>
                        <input type="text" name="price" value={{details[7]}}>
                </td>
            </tr>
            <tr> <!-- ?? We want this to be not text input -->
                <td>Is the Price Negotiable? (Yes or No): </td>
                <td>
                        <input type="text" name="negotiable" value={{details[8]}}> <br>
                </td>
            </tr>
            
            <tr>
                <td></td>
                <td>
                    <input type="submit" value="Confirm Edit">
                </td>
            </tr>
        </table>
      </form>
    <hr>
<!-- do something here? -->

Click here to <a href="/mainpage">go back to main page</a>.
% include('footer.tpl')
       