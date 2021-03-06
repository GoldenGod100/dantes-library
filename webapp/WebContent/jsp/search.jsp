<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.ArrayList, danteslibrary.model.*"%>
<!doctype html>
<html>
<head>
<%@include file="./jsp/layout/header.jsp" %>
	<title>Dante's Library | Risultati ricerca</title>
</head>
<body>

<%@ include file="./jsp/layout/navbar.jsp"%>

<div class="container" style="padding: 10px">
	<% if(request.getAttribute("search") != null) {
		@SuppressWarnings("unchecked")
		ArrayList<BooksBean> rows = (ArrayList<BooksBean>) request.getAttribute("search"); %> 
		<h2>Risultati trovati per: "<%=request.getParameter("query") %>"</h2>
	 <hr>
	 <% for(int i = 0; i < rows.size(); i++) { 
	 %>
		<div class="row">
			<a href="book?id=<%=rows.get(i).getBook_id()%>">
				<img src="<%=rows.get(i).getCover()%>" />
				<strong id="book-title"><%=rows.get(i).getTitle()%></strong><br/>
				<span><b>Genere: </b>
				<%ArrayList<String> genres = rows.get(i).getGenres();
				if(genres != null && !genres.isEmpty())
				for(int j = 0; j < genres.size(); j++) {
					if((j+1) < genres.size()) { %>
						<%=genres.get(j) + ", " %>	
					<%} else { %>
						<%=genres.get(j) %>
					<%} %>
				<%} %>
				</span>
				<span><b>Autori: </b>
				<%ArrayList<String> authors = rows.get(i).getAuthors();
				if(authors != null && !authors.isEmpty())
				for(int j = 0; j < authors.size(); j++) {
					if((j+1) < authors.size()) { %>
						<%=authors.get(j) + ", " %>	
					<%} else { %>
						<%=authors.get(j) %>
					<%} %>
				<%} %>
				</span>
				<span><b>Casa Editrice: </b><%=rows.get(i).getPublisher() %></span>
			</a>
		</div>
		<hr>
		<%} %>
		
	<%}
	else if(request.getAttribute("error") != null) { %>
	<div class="error" style="width: 90%; margin: 0 auto;"><%=request.getAttribute("error") %></div>
 <% }
	else { %>
	<h2 id="search-title">Nessun risultato trovato per: "<%=request.getParameter("query") %>".</h2>
	<%} %>
	
</div>

<%@ include file="./jsp/layout/footer.jsp"%>

</body>
</html>