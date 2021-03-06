<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.time.*, java.time.format.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Reservations</title>
	</head>
	
	<body>

		<p id="headerName">Current Reservations</p> <!-- the usual HTML way -->
		<br>
		
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
			
			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			StringBuilder queryString = new StringBuilder();
			
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");  
			LocalDateTime now = LocalDateTime.now(); 
			String[] dateTimeSplit = dtf.format(now).split(" ");
			
			String query = "SELECT * FROM customers WHERE username = '" + request.getParameter("customerName") + "'";
			ResultSet result = stmt.executeQuery(query);
			if(!result.first()) throw new Exception("Cannot find customer!");
			queryString.append("SELECT * FROM BoughtBy WHERE cid = "+result.getInt("cid"));			
			result = stmt.executeQuery(queryString.toString());
			
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>    
			<td>Ticket Number</td>
			<td>Total Price</td>
			<td>Bought At</td>
			<td>Flight Number</td>
			<td>From Airport</td>
			<td>To Airport</td>
			<td>Departure Date</td>
			<td>Departure Time</td>
			<td>Destination Date</td>
			<td>Destination Time</td>
			
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
			<%
				ApplicationDB db2 = new ApplicationDB();	
				Connection con2 = db2.getConnection();		
				Statement stmt2 = con2.createStatement();
				query = "SELECT * FROM FlightTicket WHERE ticketNumber = "+result.getInt("ticketNumber");
				System.out.println(query);
				ResultSet ticketResultSet = stmt2.executeQuery(query);
				ticketResultSet.first();
			%>
				<tr>    
					<td><%= result.getInt("ticketNumber") %></td>
					<td><%= result.getInt("totalFare") %></td>
					<td><%= result.getDate("date") + " " + result.getTime("time") %></td>
					<td><%= result.getInt("flightNumber") %></td>
					<td><%= ticketResultSet.getString("fromAirport") %></td>
					<td><%= ticketResultSet.getString("toAirport") %></td>
					<td><%= ticketResultSet.getString("departureDate") %></td>
					<td><%= ticketResultSet.getString("departureTime") %></td>
					<td><%= ticketResultSet.getString("destinationDate") %></td>
					<td><%= ticketResultSet.getString("destinationTime") %></td>
				</tr>

			<% }
			//close the connection.
			db.closeConnection(con);
			%>
		</table>
		
		<br />
		
		<form action="CurrentReservations" method = "POST">
			 Remove a reservation!<br />
			 Flight Ticket Number: <input type="text" name="flightTicketNumber"><br/>
			 <input type="text" name="customerName" placeholder="Enter Customer username" value=<% request.getParameter("customerName");%> ><br/>
			<input type="submit" name="submit" value="Remove Reservation (Customer Rep)!" /><br />
		</form>
		
		<br/>
		
		
	    
		<input type="button" value="Back to customer rep page!" onclick="window.location='CustomerRepPage.jsp'" >
		<form action="LoginS" method="post">
			<input type="button" value="test" onclick="javascript:MyFunction()" />
			<script>
		      MyFunction = function(){
		    	  document.getElementById("headerName").innerHTML = "Test"; // this works!
		      }
		    </script>
		</form>
		
		
		
			
		<%} catch (Exception e) {
			out.print(e.toString().split(":")[1]);
			out.print(" There was an error with the query. Try revamping your inputs and try again.");
		}%>
		
		<p>${message}</p>

	</body>
</html>