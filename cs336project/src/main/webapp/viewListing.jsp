<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>View Listing</title>

</head>
<body>
<h1 style="text-align: center">BuyMe Sneakers</h1> 
	<nav style="text-align: center">
		<a href="homePage.jsp">Home</a> |
    	<a href="nike.jsp">Nike Shoes</a> |
    	<a href="adidas.jsp">Adidas Shoes</a> |
    	<a href="homePage.jsp">Jordan Shoes</a> |
    	<a href="account.jsp">Account</a> 
    	
    </nav>
    
    <hr width="100%" size = "2">
	<%
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		int listID = Integer.parseInt(request.getParameter("listID"));
		String brand = request.getParameter("brand");
		
		String selectQuery = "SELECT cl.*, up.username " + 
				   "FROM createListing cl " +
				   "INNER JOIN userPosts up ON cl.listID = up.listID " +
				   "WHERE cl.listID = ?";
		
		PreparedStatement ps = con.prepareStatement(selectQuery);
		ps.setInt(1, listID);
		
		ResultSet result = ps.executeQuery();
		
		
		selectQuery = "SELECT * FROM createListing WHERE brand = ? AND listID != ?";
        PreparedStatement ps3 = con.prepareStatement(selectQuery);
        ps3.setString(1, brand);
        ps3.setInt(2, listID);
        ResultSet simItems = ps3.executeQuery();
		
		
		Statement ps2 = con.createStatement();
        ResultSet bidhist = ps2.executeQuery("SELECT b.bidID, b.price, p.username, b.dateTime, ol.listID " +
        			"FROM bids b " +
        			"LEFT JOIN onListing ol ON ol.bidID = b.bidID " +
        			"LEFT JOIN places p ON p.bidID = b.bidID " +
        			"WHERE ol.listID = " + listID);
        
        
        
        
        
		
	%>
	<h2>Details</h2>
	<table style="border-collapse: collapse; width: 100%">
	 	<tr> 
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Posted By</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Name</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Brand</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Gender</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Size</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Starting Price</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Closing Date and Time</td>
	 		
	 		
	 	</tr>
	
	<%
		double price = 0.0;
		while(result.next()){
			price = result.getDouble("startingPrice");
	%>
	
	<tr>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("username")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("name")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("brand")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("gender")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("size")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= String.format("%.2f", result.getDouble("startingPrice"))%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= result.getString("closingDateTime")%></td>
	 		
	 	</tr>
	 </table>
	
	<h2 style="text-align: center">Place a bid</h2>
   <div style="text-align: center">
   <form method="post" action="checkBid.jsp" align="center">
   		<table align="center">
   			<input type="hidden" name="listID" value="<%= listID %>">
   			<input type="hidden" name="price" value="<%= price %>">
   			<tr>
   				<td>Bid Amount</td><td><input type="number" name="bidAmount" min="0.01" value="0" step="0.01"></td>
   			</tr>
   			
   			<tr>
				<td colspan="2" style="text-align: center"><input type="submit" value="Set Bid" style="width: 100%"></td>
			</tr>
   		</table>
   </div>
   </form>
   <%
   		String error = request.getParameter("error");
   		if(error != null && error.equals("emptyBid")){
   %>
   			<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a value for bid.</div>
   <% 
   		}else if(error != null && error.equals("smallerBid")){
   %>
   			<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a bid greater than the current price.</div>
   <%
   		}
   %>
   
   <h2 style="text-align: center">Place an automatic bid</h2>
   <div style="text-align: center">
   <form method="post" action="checkAutoBid.jsp" style="text-align:center">
   		<table align="center">
   			<input type="hidden" name="listID" value="<%= listID %>">
   			<input type="hidden" name="price" value="<%= price %>">
   		
   			<tr>
   				<td>Bid Limit</td><td><input type="number" name="bidLimit"></td>
   			</tr>
   			
   			<tr>
   				<td>Increment</td><td><input type="number" name="increment"></td>
   			</tr>
   			
   			<tr>
				<td colspan="2" style="text-align: center"><input type="submit" value="Set Automatic Bid" style="width: 100%"></td>
			</tr>
   		</table>
   </div>
   </form>
   
   <%
   		if(error != null && error.equals("emptyBidLimit")){
   %>
   		<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a value for bid limit.</div>
   <%
   		}else if(error != null && error.equals("emptyIncrement")){
   %>
   		<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a value for increment.</div>
   <% 
   		}else if(error != null && error.equals("smallerIncrement")){
   %>
   		<div style="text-align: center; color: red; margin-bottom: 10px;">Please input a limit greater than the current price.</div>
   <% 
   		}
   %>
   
   <h2 style="text-align: center">Bid History</h2>
   <div style="text-align: center">
   		<table style="border-collapse: collapse; width: 50%" align="center">
   		<tr>
   			<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Bidder</td>
   			<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Bid Price</td>
   			<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Placed On</td>
   		</tr>
   		<% while(bidhist.next()){ %>
   		<tr><td style="border: 3px solid #dddddd; text-align: left; padding: 8px;"><%= bidhist.getString("username") %></td>
   			<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;"><%= String.format("%.2f", bidhist.getDouble("price")) %></td>
   			<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;"><%= bidhist.getString("dateTime") %></td>
   		</tr>
   		<%} %>
   		</table>
   		
 
   		
   </div>
   
   
   <h2 style="text-align: center"> Similar Items</h2>
   <div style="text-align: center">
   		<table style="border-collapse: collapse; width: 100%">
	 	<tr> 
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;"></td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Name</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Brand</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Gender</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Size</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Starting Price</td>
	 		<td style="border: 3px solid #dddddd; text-align: left; padding: 8px;">Closing Date and Time</td>
	 	</tr>
	 	<%while(simItems.next()){ %>
	 	<tr>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><a href="viewListing.jsp?listID=<%= simItems.getInt("listID") %>">View</a></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("name")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("brand")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("gender")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("size")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("startingPrice")%></td>
	 		<td style="border: 1px solid #dddddd; text-align: left; padding: 8px;"><%= simItems.getString("closingDateTime")%></td>
	 	</tr>
	 	<%} %>
	 	</table>
	 	
	 	
	 	
	 	
	 	
   </div>
   
   
   <%
		}
	db.closeConnection(con);
	}catch (Exception e){
		out.print(e);
	}
   %>
	
	
	
</body>
</html>