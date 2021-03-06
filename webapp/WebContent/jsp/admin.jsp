<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
import="java.util.ArrayList, danteslibrary.model.*,
java.time.LocalDate, java.time.format.*, java.util.Locale"%>
<!doctype html>
<html>
<head>
<%@include file="./jsp/layout/header.jsp" %>
	<title>Dante's Library | Area Gestori</title>
</head>
<body>
    
<%@include file="./jsp/layout/navbar.jsp" %>
	
<% if(session.getAttribute("admin") == null) { %>
<!-- Sezione LOGIN Gestori -->
<div id="form-container" style="margin-top: 75px">
	<h2>Accedi come Gestore</h2>
	<form id="sign-form" class="box" action="admin" method="post">
		<label for="email">Email</label>
		<input id="email" type="text" name="email"/>
		<label for="password">Password</label>
		<input id="password" type="password" name="password"/><br/><br/>
		<button type="submit">Accedi</button>
	</form>
	<% if(request.getAttribute("login_error") != null) { %>
		<div class="error"><%=request.getAttribute("login_error") %></div>
	<% } %>
	<% if(request.getAttribute("no_roles_error") != null) { %>
		<div class="error">
			<p><b>ATTENZIONE!</b>
			Non ti sono ancora stati assegnati dei ruoli. Contatta il tuo responsabile per maggiori informazioni.
			</p>
		</div>
	<% } %>
</div>

<% } 
	else {
	ManagersBean admin = (ManagersBean) session.getAttribute("admin");
	ArrayList<String> roles = admin.getRoles();
	if(roles == null || roles.isEmpty()) {
		session.invalidate();
		request.setAttribute("no_roles_error", "");
		request.getRequestDispatcher("admin.jsp").forward(request, response);%>
	<%}%>
	<!-- Pannello di controllo Gestori -->
	<div class="container">
		<!-- Menu laterale -->
		<div class="sidebar">
			<%if(roles.contains("Gestore Clienti") || roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-customers" class="active"><i class="fas fa-user-circle fa-lg"></i>&nbsp;&nbsp;&nbsp;Clienti</section>
			<%}
			if(roles.contains("Gestore Libri") || roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-books"><i class="fas fa-book fa-lg"></i>&nbsp;&nbsp;&nbsp;&nbsp;Libri</section>
			<%}
			if(roles.contains("Gestore Tessere") || roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-cards"><i class="fas fa-id-card fa-lg"></i>&nbsp;&nbsp;Tessere</section>
			<%}
			if(roles.contains("Gestore Prenotazioni") || roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-bookings"><i class="fas fa-address-book fa-lg"></i>&nbsp;&nbsp;&nbsp;Prenotazioni</section>
			<%}
			if(roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-managers"><i class="fas fa-users-cog fa-lg"></i>&nbsp;&nbsp;Gestori</section>
				<section id="sidebar-library"><i class="fas fa-university fa-lg"></i>&nbsp;&nbsp;Biblioteca</section>
			<%} %>
		</div>
		
		<div class="sidebar-responsive">
			<%if(roles.contains("Gestore Clienti") || roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-customers" class="active"><i class="fas fa-user-circle fa-lg"></i><br><p>Clienti<p></section>
			<%} if(roles.contains("Gestore Libri") || roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-books"><i class="fas fa-book fa-lg"></i><br><p>Libri</p></section>
			<%}
			if(roles.contains("Gestore Tessere") || roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-cards"><i class="fas fa-id-card fa-lg"></i><br><p>Tessere</p></section>
			<%}
			if(roles.contains("Gestore Prenotazioni") || roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-bookings"><i class="fas fa-address-book fa-lg"></i><br><p>Prenotazioni</p></section>
			<%}
			if(roles.contains("Gestore Biblioteca")) {%>
				<section id="sidebar-managers"><i class="fas fa-users-cog fa-lg"></i><br><p>Gestori</p></section>
				<section id="sidebar-library"><i class="fas fa-university fa-lg"></i><br>Biblioteca</section>
			<%} %>
		</div>
		
		<%if(roles.contains("Gestore Clienti") || roles.contains("Gestore Biblioteca")) {%>
		<!-- Sezione Clienti -->
		<div id="customers-section" class="section-container">
			<h2>Sezione Account Clienti</h2>
			<form method="post">	
				<p>Ricerca per: 
				<select class="dropdownFilters" name="filter">
  					<option value="0">Nome</option>
  					<option value="1">Cognome</option>
  					<option value="2">Email</option>
  					<option value="3">Codice Fiscale</option>
				</select>
				</p>
				<div id="search-bar">
					<input class="search-field" type="text" name="keyword_customers" placeholder="Seleziona il filtro ed effettua la ricerca" required/>
					<button class="search-button" type="submit" formaction="admin?customers"><i class="fas fa-search"></i></button>
				</div>
				<script>
				$(document).ready(function() {
				    $('.dropdownFilters').selectmenu();
				});
				</script>
			</form>
			<button id="show-all-btn" onClick="window.location = 'admin?all_customers'">Mostra tutti</button>
			
			<% if(request.getAttribute("info_customer") != null) { %>
				<div class="info"><%=request.getAttribute("info_customer") %></div>
			<% } %>
			
			<%if(request.getAttribute("customers") != null) { %>
			<script>
			$(document).ready(function() {
				$("#all-customers-div").slideDown();
			});
			</script>
			<div id="all-customers-div" class="overflow-container">
			<table>
					<tr>
						<th>Email</th>
						<th>Nome</th>
						<th>Cognome</th>
						<th>Codice fiscale</th>
						<th>Indirizzo</th>
					</tr>
			<%
				@SuppressWarnings("unchecked")
					ArrayList<CustomersBean> customers = (ArrayList<CustomersBean>) request.getAttribute("customers");
					for(CustomersBean customer : customers)	{
			%>
					<tr>
						<td><%=customer.getEmail() %></td>
						<td><%=customer.getName() %></td>
						<td><%=customer.getSurname() %></td>
						<td><%=customer.getCodice_fiscale() %></td>
						<td><%=customer.getAddress() %></td>
						<td>
							<form action="admin?account" method="post">
								<input type="hidden" name="remove_customer" value="<%=customer.getEmail()%>">
								<button id="btn-remove" type="submit"><i style="color: #e64c4c;" class="fas fa-times fa-lg"></i></button>
							</form>
						</td>
					</tr>
			<%  } %>
			</table>
			</div> 
		 <%} %>
		 <script>
		 	$("#all-customers-div").hide();
		 </script>
		</div> <!-- fine section-container sezione Clienti -->
		<%} %>
		
		<%if(roles.contains("Gestore Libri") || roles.contains("Gestore Biblioteca")) {%>
		<!--  Sezione Libri -->
		<div id="books-section" class="section-container">
			<h2>Sezione Libri</h2>
			<form method="post">
				<p>Ricerca per: 
				<select class="dropdownFilters" name="filter">
  					<option value="0">Titolo</option>
  					<option value="1">Autore</option>
  					<option value="2">Casa Editrice</option>
  					<option value="3">Genere</option>
				</select>
				</p>
				<div id="search-bar">
					<input class="search-field" type="text" name="keyword_book" placeholder="Seleziona il filtro ed effettua la ricerca" required/>
					<button class="search-button" type="submit" formaction="admin?books"><i class="fas fa-search"></i></button>
				</div>
			</form>
			<button id="btn-all-books" onClick="window.location = 'admin?books&all_books'">Mostra tutti</button>

			<button id="btn-book">Aggiungi Libro</button>     
			<button id="btn-genre">Aggiungi Genere</button>
			<button id="btn-delgenre" onClick="window.location = 'admin?books&all_genres'">Cancella Genere</button>

			<%if(request.getAttribute("info_book") != null) { %>
				<div class="info"><%=request.getAttribute("info_book") %></div>
			<%}
			  else if(request.getAttribute("error") != null) { %>
			  	<div class="error"><%=request.getAttribute("error") %></div>
			<%} %>

			
			<%if(request.getAttribute("books") != null) { %>
			<script>
			$(document).ready(function() {
				$("#all-books-div").slideDown();
			});
			</script>
			<div id="all-books-div" class="overflow-container">
			<table>
					<tr>
						<th>Id</th>
						<th>Titolo</th>
						<th>Autore</th>
						<th>Genere</th>
						<th>Casa Editrice</th>
						<th>Quantità</th>
						<th></th>
						<th></th>
					</tr>
			<%	@SuppressWarnings("unchecked")
				ArrayList<BooksBean> books = (ArrayList<BooksBean>) request.getAttribute("books");
				for(BooksBean book : books)	{ %>
					<tr>
						<td><%=book.getBook_id() %></td>
						<td><%=book.getTitle() %></td>
						<td>
						<%ArrayList<String> authors = book.getAuthors();
						if(authors != null && !authors.isEmpty())
							for(int i = 0; i < authors.size(); i++) {
								if((i+1) < authors.size()) { %>
									<%=authors.get(i) + ", " %>	
								<%} 
								else { %>
									<%=authors.get(i) %>
								<%} %>
							<%} %>
						</td>
						<td>
						<%ArrayList<String> genres = book.getGenres();
						if(genres != null && !genres.isEmpty())
							for(int i = 0; i < genres.size(); i++) {
								if((i+1) < genres.size()) { %>
									<%=genres.get(i) + ", " %>	
								<%}
								else { %>
								<%=genres.get(i) %>
								<%} %>
							<%} %>
						</td>
						<td><%=book.getPublisher() %></td>
						<td><%=book.getQuantity() %></td>
						<td>
							<form action="admin?books" method="post">
								<input type="hidden" name="edit_book" value="<%=book.getBook_id()%>">
								<button id="btn-edit" type="submit"><i style="color: #404040;" class="fas fa-pencil-alt fa-lg"></i></button>
							</form>
						</td>
						<td>
							<form action="admin?books" method="post">
								<input type="hidden" name="remove_book" value="<%=book.getBook_id()%>">
								<button id="btn-remove" type="submit"><i style="color: #e64c4c;" class="fas fa-times fa-lg"></i></button>
							</form>	
						</td>
					</tr>
			<%  } %>
			</table>
			</div>
			<%}
			else if(request.getAttribute("edit_book") != null) {
				//edit_book contiene l'id del libro da editare
				BooksBean book = (BooksBean) request.getAttribute("edit_book"); %>
			<script>
			$(document).ready(function() {
				$("#update-book-form").slideDown();
			});
			</script>
			<form id="update-book-form" method="post" class="overflow-container" onsubmit="return validateBook()" enctype="multipart/form-data">
				<h3>Modifica Libro</h3>
				<div style="float:left" id="update-book-image-preview" class="image-preview">
					<img src="<%=book.getCover() %>" alt="Nessun immagine" onerror="this.onerror=null; this.src='./images/no_image.png'">
				</div>
				
				<label id="btn-upload" for="update-book-image"><i class="far fa-images"></i></label>
				<input id="update-book-image" class="image" type="file" name="file" accept=".jpg, .jpeg, .png">
				<label for="title">Titolo</label>
				<input id="title" name="title" type="text" value="<%=book.getTitle() %>">
				<label for="description">Descrizione</label>
				<textarea id="description" name="description" rows="6" cols="60"><%=book.getDescription() %></textarea>
				
				<label for="authors">Autori</label>
				<input id="authors" type="hidden" value="" name="authors" />
				<select id="update-authors-select" multiple="multiple" style="width: 50%;">
			  <%if(book.getAuthors() != null && !book.getAuthors().isEmpty())
				for(String author : book.getAuthors()) {%>
					<option value="<%=author %>" selected><%=author %></option>
				<%} %>
				</select>
				<br/><br/>
				<script>
					$(document).ready(function() {
						$('#authors').val($('#update-authors-select').val());
					    $('#update-authors-select').select2({
					    	tags: true,
					    	maximumSelectionLength: 1,
					    	maximumInputLength: 100,
					    	language: "it"
					    });
					    $('#update-authors-select').change(function() {
					    	$('#authors').val($('#update-authors-select').val());
					    });
					});
				</script>
				
				<label for="publisher">Casa editrice</label>
				<input id="publisher" name="publisher" type="text" value="<%=book.getPublisher() %>">
				
				<label for="genres">Genere</label>
				<input id="genres" type="hidden" value="" name="genres" />				
				<select id="update-genres-select" multiple="multiple" style="width: 50%;">
			  <%if(book.getGenres() != null && !book.getGenres().isEmpty())
				for(String genres : book.getGenres()) {%>
					<option value="<%=genres %>" selected><%=genres %></option>
				<%} %>
				</select>
				<script>
					$.post("admin?json_genres", function(all_genres) {
						for(var i in all_genres) {
							if($("#update-genres-select option[value=\"" + all_genres[i] + "\"]").length <= 0)
								$("#update-genres-select").append("<option value='" + all_genres[i] + "'>"+ all_genres[i]+"</option>");
						}
					});
				</script>
				<br/><br/>
				<script>
					$(document).ready(function() {
						$('#genres').val($('#update-genres-select').val());
					    $('#update-genres-select').select2({
					    	maximumSelectionLength: 5,
					    	language: "it"
					    });
					    $('#update-genres-select').change(function() {
					    	$('#genres').val($('#update-genres-select').val());
					    });
					});
				</script>
				
				<label for="quantity">Quantità</label>
				<input id="quantity" name="quantity" type="text" value="<%=book.getQuantity() %>">
				<input type="hidden" name="book_id" value="<%=book.getBook_id() %>"/>
				<button type="submit" class="save" formaction="admin?books&save_book"><i class="fas fa-save fa-lg"></i> Salva modifiche</button>
				
				<script>
				/*Script per il caricamento delle immagini e preview*/
				var updated_image = document.getElementById("update-book-image");
				updated_image.style.opacity = 0; /*Nascondo il pulsante di default (pulsante Sfoglia...)*/
				$("#update-book-image").change(function() {
					$("#error-list").hide();
					if(updated_image.files[0].type !== 'image/jpeg' && updated_image.files[0].type !== 'image/jpg' && updated_image.files[0].type !== 'image/png') {
						errors.push("L'immagine deve avere il formato: .png, .jpg, oppure .jpeg.");
						validateBook();
						updated_image.value = "";
						return false;
					}
					else if(updated_image.files[0].size <= 0 || updated_image.files[0].size > 2097152 /*2MB*/) {
						errors.push("Dimensione massima immagine consentita: 2MB.");
						validateBook();
						updated_image.value = "";
						return false;
					}
					var img = new Image();
					var canvas = document.createElement("canvas");
					canvas.width = 1000;
					canvas.height = 1000;
					img.onload = function() {
						var ctx = canvas.getContext("2d");
						ctx.drawImage(img, 0, 0, 1000, 1000);
					};
					img.src = URL.createObjectURL(updated_image.files[0]);
					$("#update-book-image-preview").html(canvas);
					return true;
				});
				</script>
			</form>
			<%}
			else if(request.getParameter("all_genres") != null) {%>
			<script>
			$(document).ready(function() {
				$("#all-genres-div").slideDown();
			});
			</script>
			<div id="all-genres-div" class="overflow-container">
			<table>
				<tr>
					<th>Nome Genere</th>
					<th></th>
				</tr>
				<%
				@SuppressWarnings("unchecked")
				ArrayList<String> genres = (ArrayList<String>) request.getAttribute("all_genres");
				for(String genre : genres) { %>
					<tr>
						<td><%=genre %></td>
						<td>
							<form action="admin?books" method="post">
								<input type="hidden" name="remove_genre" value="<%=genre%>">
								<button id="btn-remove" type="submit"><i style="color: #e64c4c;" class="fas fa-times fa-lg"></i></button>
							</form>
						</td>
					</tr>
				<%} %>
			</table>
			</div>
			<%} %>

			<form id="new-book-form" method="post" class="overflow-container" onsubmit="return validateBook()" enctype="multipart/form-data">
				<h3>Inserimento Libro</h3>
				<div style="float:left" id="new-book-image-preview" class="image-preview">
					<img src="images/no_image.png" alt="Nessun immagine" onerror="this.onerror=null; this.src='./images/no_image.png'">
				</div>
				<label id="btn-upload" for="new-book-image"><i class="far fa-images"></i></label>
				<input id="new-book-image" class="image" type="file" name="file" accept=".jpg, .jpeg, .png">
				<label for="title">Titolo</label>
				<input id="title" name="title" type="text">
				<label for="description">Descrizione</label>
				<textarea id="description" name="description" rows="6" cols="60"></textarea>
				
				<label for="authors">Autori</label>
				<input id="authors" type="hidden" value="" name="authors" />
				<select id="authors-select" multiple="multiple" style="width: 50%;">
				</select>
				<script>
					$(document).ready(function() {
					    $('#authors-select').select2({
					    	tags: true,
					    	maximumSelectionLength: 1,
					    	maximumInputLength: 100,
					    	language: "it"
					    });
					    $('#authors-select').change(function() {
					    	$('#authors').val($('#authors-select').val());
					    });
					});
				</script>
				<br/><br/>
				
				<label for="publisher">Casa editrice</label>
				<input id="publisher" name="publisher" type="text">
				
				<label for="genres">Genere</label>
				<input id="genres" type="hidden" value="" name="genres" />
				<select id="genres-select" multiple="multiple" style="width: 50%;">
				</select>
				<script>
					$.post("admin?json_genres", function(genres) {
						for(i in genres) {
							$("#genres-select").append("<option value='" + genres[i] + "'>"+genres[i]+"</option>");
						}
					});
					$(document).ready(function() {
					    $('#genres-select').select2({
					    	maximumSelectionLength: 5,
					    	language: "it"
					    });
					    $('#genres-select').change(function() {
					    	$('#genres').val($('#genres-select').val());
					    });
					});
				</script>				
				<br/><br/>
				
				<label for="quantity">Quantità</label>
				<input id="quantity" name="quantity" type="text">
				<button type="submit" class="save" formaction="admin?books&new_book"><i class="fas fa-plus fa-lg"></i> Aggiungi libro</button>
				<script>
				/*Script per il caricamento delle immagini e preview*/
				var book_image = document.getElementById("new-book-image");
				
				book_image.style.opacity = 0; /*Nascondo il pulsante di default (pulsante Sfoglia...)*/
				$("#new-book-image").change(function() {
					$("#error-list").hide();
					if(book_image.files[0].type !== 'image/jpeg' && book_image.files[0].type !== 'image/jpg' && book_image.files[0].type !== 'image/png') {
						errors.push("L'immagine deve avere il formato: .png, .jpg, oppure .jpeg.");
						validateBook();
						return false;
					}
					else if(book_image.files[0].size <= 0 || book_image.files[0].size > 2097152 /*2MB*/) {
						errors.push("Dimensione massima immagine consentita: 2MB.");
						validateBook();
						return false;
					}
					var img = new Image();
					var canvas = document.createElement("canvas");
					canvas.width = 1000;
					canvas.height = 1000;
					img.onload = function() {
						var ctx = canvas.getContext("2d");
						ctx.drawImage(img, 0, 0, 1000, 1000);
					};
					img.src = URL.createObjectURL(book_image.files[0]);
					$("#new-book-image-preview").html(canvas);
					return true;
				});
				</script>
			</form>
		<script>
		$("#error-list").hide();
		var errors = [];
		function validateBook() {
			var title_regex = /^.{1,100}$/;
			var description_regex = /^[\s\S]{1,1000}$/;
			var publisher_regex = /^.{1,100}$/;
			var quantity_regex = /^[0-9]{1,3}$/;
			
			var title = document.getElementById("title").value;
			var description = document.getElementById("description").value;
			var authors = document.getElementById("authors").value;
			var publisher = document.getElementById("publisher").value;
			var quantity = document.getElementById("quantity").value;
			var genres = document.getElementById("genres").value;
			
			if(!title || !description || !authors || !publisher || !quantity || !genres) {
				errors.push("Non tutti i campi sono stati compilati.");
			}
			
			if(!title.match(title_regex) && title) {
				errors.push("Il titolo può contenere massimo 100 caratteri.");
			}
			
			if(!description.match(description_regex) && description) {
				errors.push("La descrizione non può superare i 1000 caratteri.");
			}
			
			if(!publisher.match(publisher_regex) && publisher) {
				errors.push("La casa editrice può contenere massimo 100 caratteri.");
			}
			
			if((!quantity.match(quantity_regex) || (quantity < 0 || quantity > 999)) && quantity) {
				errors.push("La quantità deve essere espressa con un numero positivo (massimo 3 cifre).");
			}
			
			if(errors.length != 0) {
				if(!document.getElementById("error-list")) {
					var errors_div = document.createElement("div");
					errors_div.setAttribute("id", "error-list");
					errors_div.setAttribute("tabindex", "-1"); //per ottenerne il focus
				}
				else {
					var errors_div = document.getElementById("error-list");
				}
				var txt = "<ul>";
				$("#books-section h2").after(errors_div);
				errors_div.className = "error";
				errors.forEach(showErrors);
				errors_div.innerHTML = txt;
				
				function showErrors(value, index, array) {
					txt = txt + "<li>" + value + "</li>";
				}
				
				errors_div.innerHTML = txt + "</ul>";
				$(errors_div).fadeIn(300);
				errors = [];
				errors_div.focus();
				return false;
			}
			
			$("#error-list").hide();
			return true;
		}
		</script>
		
		<!-- Aggiungi Genere -->
		<form id="new-genre-form" method="post" class="overflow-container" onsubmit="return validateGenre()">
			<h3>Aggiunta Genere</h3>
			<label for="genre">Nome del nuovo genere</label>
			<input id="genre" name="genre_name" type="text">
			<button type="submit" class="save" formaction="admin?books&new_genre"><i class="fas fa-plus fa-lg"></i> Aggiungi genere</button>
		</form>
		<script>
		$("#error-list").hide();
		var errors = [];
		function validateGenre() {
			var genre_name_regex = /^[A-zÀ-ú ]{1,30}$/;
			var genre_name = document.getElementById("genre").value;
				
			if(!genre_name) {
				errors.push("Non tutti i campi sono stati compilati.");
			}
			
			if(!genre_name.match(genre_name_regex) && genre_name) {
				errors.push("Il nome del genere può contenere solo lettere e spazi. Lunghezza massima: 30 caratteri.");
			}
		
			if(errors.length != 0) {
				if(!document.getElementById("error-list")) {
					var errors_div = document.createElement("div");
					errors_div.setAttribute("id", "error-list");
					errors_div.setAttribute("tabindex", "-1"); //per ottenerne il focus
				}
				else {
					var errors_div = document.getElementById("error-list");
				}
				var txt = "<ul>";
				$("#new-genre-form h3").before(errors_div);
				errors_div.className = "error";
				errors.forEach(showErrors);
				errors_div.innerHTML = txt;
				
				function showErrors(value, index, array) {
					txt = txt + "<li>" + value + "</li>";
				}
				
				errors_div.innerHTML = txt + "</ul>";
				$(errors_div).fadeIn(300);
				errors = [];
				errors_div.focus();
				return false;
			}
			
			$("#error-list").hide();
			return true;
		}
		</script>
		
			<script>
			$(document).ready(function() {
			    $('.dropdownFilters').selectmenu();
			});
			$("#new-book-form").hide();
			$("#new-genre-form").hide();
			$("#update-book-form").hide();
			$("#new-genre-form").hide();
			$("#all-books-div").hide();
			$("#all-genres-div").hide();
			$(document).ready(function() {
				$("#btn-book").click(function() {
					$("#update-book-form").remove(); /*remove, altrimenti la funzione validateBook ottiene i dati di update-book-form
					nel caso in cui si cerca prima di modificare un libro e subito dopo aggiungerlo (senza ricaricare la pagina). */
					$("#new-genre-form").hide();
					$("#all-books-div").hide();
					$("#all-genres-div").hide();
					$("#new-book-form").slideDown();
				});
				$("#btn-genre").click(function() {
					$("#update-book-form").hide();
					$("#new-book-form").hide();
					$("#all-books-div").hide();
					$("#all-genres-div").hide();
					$("#new-genre-form").slideDown();
				});
			});	
			</script>
		</div> <!-- fine section-container sezione Libri -->
		<%} %>
		
		<%if(roles.contains("Gestore Tessere") || roles.contains("Gestore Biblioteca")) {%>
		<!-- Tessera -->
		<div id="cards-section" class="section-container">
			<h2>Sezione Tessere</h2>
			<form method="post">
				<p>Ricerca per: 
				<select class="dropdownFilters" name="filter">
  					<option value="0">Nome</option>
  					<option value="1">Cognome</option>
  					<option value="2">Email</option>
  					<option value="3">Codice fiscale</option>
  					<option value="4">Codice tessera</option>
  					
				</select>
				</p>
				<div id="search-bar">
					<input class="search-field" type="text" name="keyword_card" placeholder="Seleziona il filtro ed effettua la ricerca" required/>
					<button class="search-button" type="submit" formaction="admin?cards"><i class="fas fa-search"></i></button>
				</div>
			</form>
			<button id="show-all-btn" onClick="window.location = 'admin?cards&all_cards'">Mostra tutti</button>
      		<button id="btn-card">Aggiungi Tessera</button> 
			
			<%if(request.getAttribute("info_card") != null) { %>
				<div class="info"><%=request.getAttribute("info_card") %></div>
			<%}
			  else if(request.getAttribute("error") != null) { %>
			  	<div class="error"><%=request.getAttribute("error") %></div>
			<%} %>
			
			<%if(request.getAttribute("cards") != null) { %>
			<script>
			$(document).ready(function() {
				$("#all-cards-div").slideDown();
			});
			</script>
			<div id="all-cards-div" class="overflow-container">
			<table>		
					<tr>
						<th>Nome</th>
						<th>Cognome</th>
						<th>Email</th>
						<th>Codice fiscale</th>
						<th>Codice tessera</th>
						<th>Associata</th>
						<th></th>
					</tr>
			<%	@SuppressWarnings("unchecked")
				ArrayList<CardsBean> cards = (ArrayList<CardsBean>) request.getAttribute("cards");
				for(CardsBean card : cards)	{ %>
					<tr>
					 <% if (card.getName() != null && card.getSurname()!= null && card.getEmail()!= null ) {%>
						<td><%=card.getName() %></td>
						<td><%=card.getSurname() %></td>
						<td><%=card.getEmail() %></td>
					<% } else { %>
					 	<td><td>
					 	<td><td>
					 	<td><td>
					 <%} %>
						<td><%=card.getCodice_fiscale() %></td>
						<td><%=card.getCard_id() %></td>
						<td>
						<%if(card.isAssociated()) { %>
							<i class="fas fa-check-circle fa-lg" style="color: #50ebaf"></i>
						<%}
						else {%>
							<i class="fas fa-times-circle fa-lg" style="color: #eb5050"></i>
						<%} %>
						</td>
						<td>
							<form action="admin?cards" method="post">
								<input type="hidden" name="remove_card" value="<%=card.getCard_id()%>">
								<button id="btn-remove" type="submit"><i style="color: #e64c4c;" class="fas fa-times fa-lg"></i></button>
							</form>
						</td>
					</tr>
			<%  } %>
			</table>
			</div>
		   <%} %>			
			
			<form id="new-card-form" method="post" class="overflow-container" onsubmit="return validateCard()">
			<h3>Inserimento Tessera</h3>
					<label for="codice_fiscale">Codice fiscale</label>
					<input id="codice_fiscale" name="codice_fiscale" type="text">
					<label for="card_id">Codice tessera (facoltativo)</label>
					<input id="card_id" name="card_id" type="text">
					<label for="associated" style="display: inline;">Associata:</label>
					<input id="associated" type="checkbox" name="associated"><br/><br/>
					<button type="submit" class="save" formaction="admin?cards&new_card"><i class="fas fa-plus fa-lg"></i> Aggiungi Tessera</button>
					<button type="reset" class="cancel"><i class="fas fa-times fa-lg"></i> Pulisci campi</button>
			</form>
		
		<script>
			$("#error-list").hide();
			var errors = [];
			function validateCard() {
				var codice_fiscale_regex = /[a-zA-Z]{6}\d\d[a-zA-Z]\d\d[a-zA-Z]\d\d\d[a-zA-Z]/;
				var card_id_regex = /^[0-9]{5}$/;
				
				var codice_fiscale = document.getElementById("codice_fiscale").value;
				var card_id = document.getElementById("card_id").value;
				
				if(!codice_fiscale)
					errors.push("Non tutti i campi sono stati compilati.");
				
				if(!codice_fiscale.match(codice_fiscale_regex) && codice_fiscale)
					errors.push("Inserire un codice fiscale valido.");
				
				if(!card_id.match(card_id_regex) && card_id)
					errors.push("Inserire un codice tessera valido.");
			
				if(errors.length != 0) {
					if(!document.getElementById("error-list")) {
						var errors_div = document.createElement("div");
						errors_div.setAttribute("id", "error-list");
						errors_div.setAttribute("tabindex", "-1"); //per ottenerne il focus
					}
					else {
						var errors_div = document.getElementById("error-list");
					}
					var txt = "<ul>";
					$("#cards-section h3").before(errors_div);
					errors_div.className = "error";
					errors.forEach(showErrors);
					errors_div.innerHTML = txt;
					
					function showErrors(value, index, array) {
						txt = txt + "<li>" + value + "</li>";
					}
					
					errors_div.innerHTML = txt + "</ul>";
					$(errors_div).fadeIn(300);
					errors = [];
					errors_div.focus();
					return false;
				}
				
				$("#error-list").hide();
				return true;
			}
		</script>
		<script>
		$(document).ready(function() {
		    $('.dropdownFilters').selectmenu();
		});
		$("#new-card-form").hide();
		$("#all-cards-div").hide();
		$(document).ready(function() {
			$("#btn-card").click(function() {
				$("#all-cards-div").hide();
				$("#new-card-form").slideDown();
			});
		});	
		</script> 
		</div> <!-- fine section-container sezione Tessere -->
		<%} %>
		
		<%if(roles.contains("Gestore Prenotazioni") || roles.contains("Gestore Biblioteca")) {%>
		<!-- Sezione Prenotazioni -->
		<div id="bookings-section" class="section-container">
			<h2>Sezione Prenotazioni</h2>
			<form method="post">
				<p>Ricerca per: 
				<select class="dropdownFilters" name="filter">
  					<option value="0">Codice prenotazione</option>
  					<option value="1">Codice Libro</option>
  					<option value="2">Codice Tessera</option>
  					<option value="3">Codice fiscale</option>
  					<option value="4">Stato</option>
  					<option value="5">Email</option>
  					<option value="6">Data inizio</option>
  					<option value="7">Data fine</option>
				</select>
				</p>
				<div id="search-bar">
					<input class="search-field" type="text" name="keyword_booking" placeholder="Seleziona il filtro ed effettua la ricerca" required/>
					<button class="search-button" type="submit" formaction="admin?bookings"><i class="fas fa-search"></i></button>
				</div>
			</form>
			<button id="show-all-btn" onClick="window.location = 'admin?bookings&all_bookings'">Mostra tutti</button>
			<button id="btn-booking">Aggiungi Prenotazione</button>
			<script>
			$(document).ready(function() {
				$("#btn-booking").click(function() {
					$("#update-booking-form").remove();
				});
			});
			</script>
			
      		<%if(request.getAttribute("info_booking") != null) { %>
				<div class="info"><%=request.getAttribute("info_booking") %></div>
			<%}
      		else if(request.getAttribute("error") != null) { %>
		  	<div class="error"><%=request.getAttribute("error") %></div>
			<%} %>
			
			<%if(request.getAttribute("bookings") != null) { %>
			<script>
			$(document).ready(function() {
				$("#all-bookings-div").slideDown();
			});
			</script>
			<div id="all-bookings-div" class="overflow-container">
			<table>		
					<tr>
						<th>Codice prenotazione</th>
						<th>Codice Libro</th>
						<th>Titolo</th>
						<th>Codice Tessera</th>
						<th>Codice fiscale</th>
						<th>Data inizio</th>
						<th>Data fine</th>
						<th>Stato</th>						
						<th></th>
						<th></th>
					</tr>
			<%	@SuppressWarnings("unchecked")
				ArrayList<BookingsBean> bookings = (ArrayList<BookingsBean>) request.getAttribute("bookings");
				for(BookingsBean booking : bookings)	{ %>
					<tr>
						<td><%=booking.getBooking_id() %></td>
						<td><%=booking.getBook_id() %></td>
						<td><%=booking.getTitle() %></td>
						<td><%=booking.getCard_id() %></td>
						<td><%=booking.getCodice_fiscale() %></td>
						<td><%=booking.getStart_date().format(DateTimeFormatter.ofPattern("d MMM yyyy", Locale.ITALIAN)) %></td>
						<td><%=booking.getEnd_date().format(DateTimeFormatter.ofPattern("d MMM yyyy", Locale.ITALIAN)) %></td>
						<td><%=booking.getState_name() %></td>
						<td>
						<%if(!booking.getState_name().equals("Annullata") && !booking.getState_name().equals("Riconsegnato")) {%>
							<form action="admin?bookings" method="post">
								<input type="hidden" name="edit_booking" value="<%=booking.getBooking_id()%>">
								<button id="btn-edit" type="submit"><i style="color: #404040;" class="fas fa-pencil-alt fa-lg"></i></button>
							</form>
						<%} %>
						</td>
						<td>	
							<form action="admin?bookings" method="post">
								<input type="hidden" name="remove_booking" value="<%=booking.getBooking_id()%>">
								<button id="btn-remove" type="submit"><i style="color: #e64c4c;" class="fas fa-times fa-lg"></i></button>
							</form>
						</td>
							
					</tr>
			<%  } %>
			 </table>
			</div>
			<%} 
			else if(request.getAttribute("edit_booking") != null) {
			BookingsBean booking = (BookingsBean) request.getAttribute("edit_booking");%> 
			<script>
			$(document).ready(function() {
				$("#update-booking-form").slideDown();
			});
			</script>
			<form id="update-booking-form" method="post" class="overflow-container" onsubmit="return validateBooking()">
				<h3>Modifica Stato Prenotazione</h3>
				<input type="hidden" id="booking_id" name="booking_id" value="<%=booking.getBooking_id() %>">
				<%if (booking.getEmail()!=null) { %>
				<label for="booking_email">Email(facoltativo)</label>
				<input id="booking_email" type="text" value="<%=booking.getEmail() %>" readonly>
				<%} %>
				<label for="booking_codice_fiscale">Codice fiscale</label>
				<input id="booking_codice_fiscale" type="text" value="<%=booking.getCodice_fiscale()%>" readonly>
				<label for="booking_card_id">Codice Tessera</label>
				<input id="booking_card_id" type="text" value="<%=booking.getCard_id() %>" readonly> 
				<label for="booking_book_id">Codice Libro</label>
				<input id="booking_book_id"   type="text" value="<%=booking.getBook_id() %>" readonly> 
				<label for="booking_start_date">Data inizio</label>
				<input id="booking_start_date"   type="text" value="<%=booking.getStart_date().format(DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.ITALIAN)) %>" readonly> 
				<label for="booking_end_date">Data fine</label>
				<input id="booking_end_date" type="text" value="<%=booking.getEnd_date().format(DateTimeFormatter.ofPattern("d MMMM yyyy", Locale.ITALIAN)) %>" readonly> 
					<label for="booking_state">Stato</label>
					<select id="booking_state" class="booking_state" name="state">
						<%if(booking.getState_name().equals("Annullata")) {%>
							<option value="Annullata" selected>Annullata</option>
						<%} 
						if(booking.getState_name().equals("Non ancora ritirato")) {%>
							<option value="Annullata">Annullata</option>
							<option value="Non ancora ritirato" selected>Non ancora ritirato</option>
							<option value="Ritirato">Ritirato</option>
							<option value="Riconsegnato" disabled>Riconsegnato</option>
						<%} 
						if(booking.getState_name().equals("Ritirato")) {%>
							<option value="Annullata" disabled>Annullata</option>
							<option value="Non ancora ritirato" disabled>Non ancora ritirato</option>
							<option value="Ritirato" selected>Ritirato</option>
							<option value="Riconsegnato">Riconsegnato</option>
						<%}
						if(booking.getState_name().equals("Riconsegnato")) {%>
							<option value="Riconsegnato" selected>Riconsegnato</option>
						<%} %>
					</select>
				<button type="submit" class="save" formaction="admin?bookings&save_booking"><i class="fas fa-save fa-lg"></i> Salva modifiche</button>
			</form>
			<%} %>
			
			<form id="new-booking-form" method="post" class="overflow-container" onsubmit="return validateBooking()">
			<h3>Inserimento Prenotazione</h3>
				<label for="booking_email">Email(facoltativo)</label>
				<input id="booking_email" name="email" type="text">
				<label for="booking_codice_fiscale">Codice fiscale</label>
				<input id="booking_codice_fiscale" name="codice_fiscale" type="text">
				<label for="booking_card_id">Codice Tessera</label>
				<input id="booking_card_id" name="card_id"  type="text"> 
				<label for="booking_book_id">Codice Libro</label>
				<input id="booking_book_id" name="book_id"  type="text"> 
				<label for="start-date">Data inizio prestito</label> 
				<input type="text" id="start-date" name="start_date" value="" required>
				<label for="end-date">Data fine prestito</label>
				<input type="text" id="end-date" name="end_date" value="" required>
				<script>
				$(document).ready(function() {
					$("#start-date, #end-date").datepicker({
						maxDate: "+4m",
						autoSize: true,
						dateFormat: "d MM yy",
						monthNames: [ "Gennaio","Febbraio","Marzo","Aprile","Maggio","Giugno",
							"Luglio","Agosto","Settembre","Ottobre","Novembre","Dicembre" ],
					});
					$('#start-date').datepicker("setDate", "0");
					
					var start_date = $('#start-date').datepicker("getDate");
					var end_date = $('#end-date').datepicker("getDate");
					
					/*Se la data di fine e' stata settata, allora aggiorno l'attributo value,
					altrimenti value=""*/
					if(end_date)
						$('#end-date').attr("value", end_date.getFullYear() + "-" + (end_date.getMonth()+1) + "-" + end_date.getDate());
					
					$('#start-date').attr("value", start_date.getFullYear() + "-" + (start_date.getMonth()+1) + "-" + start_date.getDate());
					
					/*Ogni volta che cambia la data di inizio, ottengo l'oggetto Date con getDate
					e aggiorno l'attribute value di start-date.
					Inoltre, reimposto la data minima selezionabile di end-date in base a quella
					selezionata in start-date.*/
					$('#start-date').change(function() {
						start_date = $('#start-date').datepicker("getDate");
						end_date = $('#end-date').datepicker("getDate");
						$('#start-date').attr("value", start_date.getFullYear() + "-" + (start_date.getMonth()+1) + "-" + start_date.getDate());
						$('#end-date').datepicker("option", "minDate" , $("#start-date").datepicker("getDate"));
					});
					/*Ogni volta che cambia la data di fine, ottengo l'oggetto Date con getDate
					e aggiorno l'attribute value di end-date.*/
					$('#end-date').change(function() {
						end_date = $('#end-date').datepicker("getDate");
						$('#end-date').attr("value", end_date.getFullYear() + "-" + (end_date.getMonth()+1) + "-" + end_date.getDate());
					});
				});
				</script>
				<label for="booking_state">Stato prenotazione</label>
				<select id="booking_state" class="booking_state" name="state">
					<option value="Non ancora ritirato">Non ancora ritirato</option>
					<option value="Ritirato">Ritirato</option>
					<option value="Riconsegnato">Riconsegnato</option>
					<option value="Annullata">Annullata</option>
				</select>
				<script>
				$(document).ready(function() {
				    $('.booking_state').selectmenu();
				});
				</script>
				<button type="submit" class="save" formaction="admin?bookings&new_booking"><i class="fas fa-plus fa-lg"></i> Aggiungi Prenotazione</button>
				<button type="reset" class="cancel"><i class="fas fa-times fa-lg"></i> Pulisci campi</button>
			</form>
		
		<script>
		$("#error-list").hide();
		var errors = [];
	  	function validateBooking() {
	  		var email_regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
			var codice_fiscale_regex = /[a-zA-Z]{6}\d\d[a-zA-Z]\d\d[a-zA-Z]\d\d\d[a-zA-Z]/;
			var book_id_regex = /^[0-9]*$/;
			var card_id_regex = /^[0-9]{5}$/;
			
			var email = document.getElementById("booking_email").value;
			var codice_fiscale = document.getElementById("booking_codice_fiscale").value;
			var card_id = document.getElementById("booking_card_id").value;
			var book_id = document.getElementById("booking_book_id").value;
			var start_date = $('#start-date').datepicker("getDate");
			var end_date = $('#end-date').datepicker("getDate");

			if(!codice_fiscale || !card_id || !book_id)
				errors.push("Non tutti i campi sono stati compilati.");
			
			if(!codice_fiscale.match(codice_fiscale_regex) && codice_fiscale)
				errors.push("Inserire un codice fiscale valido.");
			
			if((!email.match(email_regex) || (email.length < 5 || email.length > 100)) && email)
				errors.push("Indirizzo email non valido. Lunghezza massima 100 caratteri.");
			
			if(!book_id.match(book_id_regex) && book_id)
				errors.push("Il codice libro può contenere solo numeri!");
			
			if(!card_id.match(card_id_regex) && card_id)
				errors.push("Inserire un codice tessera valido.");
			
			if(errors.length != 0) {
				if(!document.getElementById("error-list")) {
					var errors_div = document.createElement("div");
					errors_div.setAttribute("id", "error-list");
					errors_div.setAttribute("tabindex", "-1"); //per ottenerne il focus
				}
				else {
					var errors_div = document.getElementById("error-list");
				}
				var txt = "<ul>";
				$("#bookings-section h2").after(errors_div);
				errors_div.className = "error";
				errors.forEach(showErrors);
				errors_div.innerHTML = txt;
				
				function showErrors(value, index, array) {
					txt = txt + "<li>" + value + "</li>";
				}
				
				errors_div.innerHTML = txt + "</ul>";
				$(errors_div).fadeIn(300);
				errors = [];
				errors_div.focus();
				return false;
			}
			
			$("#error-list").hide();
			return true;
		}
		</script>
		<script>
		$(document).ready(function() {
		    $('.dropdownFilters').selectmenu();
		});
		$("#new-booking-form").hide();
		$("#all-bookings-div").hide();
		$("#update-booking-form").hide();
		$(document).ready(function() {
			$("#btn-booking").click(function() {
				$("#all-bookings-div").hide();
				$("#update-booking-form").hide();
				$("#new-booking-form").slideDown();
			});
		});	
		</script>
		</div> <!-- fine section-container sezione Prenotazioni -->
		<%} %>
		
		<%if(roles.contains("Gestore Biblioteca")) {%>
		<!-- Sezione Gestori -->
		<div id="managers-section" class="section-container">
			<h2>Sezione Gestori</h2>
			<form method="post">
				<p>Ricerca per: 
				<select class="dropdownFilters" name="filter">
  					<option value="0">Email</option>
  					<option value="1">Nome</option>
  					<option value="2">Cognome</option>
  					<option value="3">Ruolo</option>
				</select>
				</p>
				<div id="search-bar">
					<input class="search-field" type="text" name="keyword_manager" placeholder="Seleziona il filtro ed effettua la ricerca" required/>
					<button class="search-button" type="submit" formaction="admin?managers"><i class="fas fa-search"></i></button>
				</div>
			</form>
			<button id="show-all-btn" onClick="window.location = 'admin?managers&all_managers'">Mostra tutti</button>
			<button id="btn-manager">Aggiungi Gestore</button> 
			
      		<%if(request.getAttribute("info_manager") != null) { %>
				<div class="info"><%=request.getAttribute("info_manager") %></div>
			<%}
      		else if(request.getAttribute("error") != null) { %>
		  	<div class="error"><%=request.getAttribute("error") %></div>
			<%} %>
			
			<%if(request.getAttribute("managers") != null) { %>
			<script>
			$(document).ready(function() {
				$("#all-managers-div").slideDown();
			});
			</script>
			<div id="all-managers-div" class="overflow-container">
			<table>	
					<tr>
						<th>Email</th>
						<th>Nome</th>
						<th>Cognome</th>
						<th>Indirizzo</th>
						<th>Telefono</th>
						<th>Ruolo</th>
						<th></th>
						<th></th>
					</tr>
			<%	@SuppressWarnings("unchecked")
				ArrayList<ManagersBean> managers = (ArrayList<ManagersBean>) request.getAttribute("managers");
				for(ManagersBean manager : managers)	{ %>
					<tr>
						<td><%=manager.getEmail() %></td>
						<td><%=manager.getName() %></td>
						<td><%=manager.getSurname() %></td>
						<td><%=manager.getAddress() %></td>
						<td><%=manager.getPhone() %></td>
						<td>
						<%ArrayList<String> manager_roles = manager.getRoles();
						if(manager_roles != null && !manager_roles.isEmpty())
							for(int i = 0; i < manager_roles.size(); i++) {
								if((i+1) < manager_roles.size()) { %>
									<%=manager_roles.get(i) + ", " %>	
								<%} 
								else { %>
									<%=manager_roles.get(i) %>
								<%} %>
							<%} %>
						</td>
						<td>
						<form action="admin?managers" method="post">
								<input type="hidden" name="edit_manager" value="<%=manager.getEmail()%>">
								<button id="btn-edit" type="submit"><i style="color: #404040;" class="fas fa-pencil-alt fa-lg"></i></button>
						</form>
						</td>
						<td>
						<form action="admin?managers" method="post">
								<input type="hidden" name="remove_manager" value="<%=manager.getEmail()%>">
								<button id="btn-remove" type="submit"><i style="color: #e64c4c;" class="fas fa-times fa-lg"></i></button>
						</form>
						</td>
					</tr>
			<%  } %>
			</table>
			</div>
			<%} 			
			else if(request.getAttribute("edit_manager") != null) {
			ManagersBean manager = (ManagersBean) request.getAttribute("edit_manager"); %>
			<script>
			$(document).ready(function() {
				$("#update-manager-form").slideDown();
			});
			</script>
			<form id="update-manager-form" method="post" class="overflow-container" onsubmit="return validateUpdateManager()">
				<h3>Modifica Gestore</h3>
				<input type="hidden" id="original_email" name="original_email" value="<%=manager.getEmail() %>">
				<label for="email">Email</label>
				<input id="email" name="email" type="text" value="<%=manager.getEmail() %>">
				<label for="password">Password</label>
				<input id="password" name="password" type="password" placeholder="Lasciare vuoto per non cambiare">
				<label for="repeat_password">Ripeti Password</label>
				<input id="repeat_password" name="repeat_password" type="password" placeholder="Lasciare vuoto per non cambiare">
				<label for="name">Nome</label>
				<input id="name" name="name"  type="text" value="<%=manager.getName() %>"> 
				<label for="surname">Cognome</label>
				<input id="surname" name="surname"  type="text" value="<%=manager.getSurname() %>"> 
				<label for="address">Indirizzo</label>
				<input id="address" name="address"  type="text" value="<%=manager.getAddress() %>"> 
				<label for="phone">Telefono</label>
				<input id="phone" name="phone"  type="text" value="<%=manager.getPhone() %>"> 
				<label>Ruolo</label>
				<br/>
				<input type="checkbox" id="customers_manager" name="customers_manager" value="Gestore Clienti">  Gestore Clienti<br>
				<input type="checkbox" id="books_manager" name="books_manager" value="Gestore Libri">  Gestore Libri<br>
				<input type="checkbox" id="cards_manager" name="cards_manager" value="Gestore Tessere">  Gestore Tessere<br>
				<input type="checkbox" id="bookings_manager" name="bookings_manager" value="Gestore Prenotazioni">  Gestore Prenotazioni<br>
				<input type="checkbox" id="library_manager" name="library_manager" value="Gestore Biblioteca">  Gestore Biblioteca<br>
				<br/><br/>
						<% ArrayList <String> manager_roles = manager.getRoles();
						if(manager_roles != null && !manager_roles.isEmpty()) {
							if(manager_roles.contains("Gestore Clienti")) {%>
							<script>
							$("#customers_manager").attr("checked", true);
							</script>
							<%}%>
							<%if(manager_roles.contains("Gestore Libri")) {%>
							<script>
							$("#books_manager").attr("checked", true);
							</script>
							<%}%>
							<%if(manager_roles.contains("Gestore Tessere")) {%>
							<script>
							$("#cards_manager").attr("checked", true);
							</script>
							<%}%>
							<%if(manager_roles.contains("Gestore Prenotazioni")) {%>
							<script>
							$("#bookings_manager").attr("checked", true);
							</script>
							<%}%>
							<%if(manager_roles.contains("Gestore Biblioteca")) {%>
							<script>
							$("#library_manager").attr({
								checked : "true",
								disabled : "true"
							});
							$("#customers_manager").removeAttr("checked").attr("disabled", true);
							$("#books_manager").removeAttr("checked").attr("disabled", true);
							$("#cards_manager").removeAttr("checked").attr("disabled", true);
							$("#bookings_manager").removeAttr("checked").attr("disabled", true);
							</script>
							<%}
						}%>
				<script>
				$(document).ready(function() {
					$("#library_manager").change(function() {
						if(document.getElementById("library_manager").checked) {
							$("#customers_manager").removeAttr("checked").attr("disabled", true);
							$("#books_manager").removeAttr("checked").attr("disabled", true);
							$("#cards_manager").removeAttr("checked").attr("disabled", true);
							$("#bookings_manager").removeAttr("checked").attr("disabled", true);
						}
						else {
							$("#customers_manager").removeAttr("disabled");
							$("#books_manager").removeAttr("disabled");
							$("#cards_manager").removeAttr("disabled");
							$("#bookings_manager").removeAttr("disabled");
						}
					});
				});
				</script>
				<button type="submit" class="save" formaction="admin?managers&save_manager"><i class="fas fa-save fa-lg"></i> Salva modifiche</button>
				<button type="reset" class="cancel"><i class="fas fa-times fa-lg"></i> Pulisci campi</button>
			</form>
			<script>
		    $("#error-list").hide();
		    var errors = [];
		    function validateUpdateManager() {
		    	var email_regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
		    	var name_regex = /^[A-zÀ-ú ]{1,30}$/;
		    	var surname_regex = /^[A-zÀ-ú ]{1,30}$/;
		    	var password_regex = /^.{6,20}$/;
		    	var address_regex = /^[A-zÀ-ú0-9 ,]{5,100}$/;
		    	var phone_regex = /^[0-9]{7,10}$/;
		    	
				var email = document.getElementById("email").value;
				var name = document.getElementById("name").value;
				var surname = document.getElementById("surname").value;
				var password = document.getElementById("password").value;
				var repeat_password = document.getElementById("repeat_password").value;
				var address = document.getElementById("address").value;
				var phone = document.getElementById("phone").value;
				
				var customers_checkbox = document.getElementById("customers_manager");
				var books_checkbox = document.getElementById("books_manager");
				var cards_checkbox = document.getElementById("cards_manager");
				var bookings_checkbox = document.getElementById("bookings_manager");
				var library_checkbox = document.getElementById("library_manager");
				
				if(!email || !name || !surname || !address || !phone || 
						(!customers_checkbox.checked && !books_checkbox.checked && !cards_checkbox.checked && !bookings_checkbox.checked && !library_checkbox.checked)) {
				  errors.push("Non tutti i campi sono stati compilati.");
				}

				if((!email.match(email_regex) || (email.length < 5 || email.length > 100)) && email)
					errors.push("Indirizzo email non valido. Lunghezza massima 100 caratteri.");
				
				if(!name.match(name_regex) && name)
					errors.push("Il nome può contenere solo lettere. Lunghezza massima: 30 caratteri.");
				
				if(!surname.match(surname_regex) && surname)
					errors.push("Il cognome può contenere solo lettere. Lunghezza massima: 30 caratteri.");
				
				if(!address.match(address_regex) && address)
					errors.push("L'indirizzo non è compilato correttamente.");
				
				if(!phone.match(phone_regex) && phone)
					errors.push("Inserire un numero di telefono valido.");
				
				if(!password.match(password_regex) && password)
					errors.push("La password deve avere tra i 6 e i 20 caratteri.");
				
				if(password != repeat_password && password && repeat_password)
				  errors.push("Le password non corrispondono.");
				
				if(errors.length != 0) {
				  if(!document.getElementById("error-list")) {
				    var errors_div = document.createElement("div");
				    errors_div.setAttribute("id", "error-list");
				    errors_div.setAttribute("tabindex", "-1"); //per ottenerne il focus
				  }
				  else {
				    var errors_div = document.getElementById("error-list");
				  }
				  var txt = "<ul>";
				  $("#update-manager-form h3").before(errors_div);
				  errors_div.className = "error";
				  errors.forEach(showErrors);
				  errors_div.innerHTML = txt;
				
				  function showErrors(value, index, array) {
				    txt = txt + "<li>" + value + "</li>";
				  }
				
				  errors_div.innerHTML = txt + "</ul>";
				  $(errors_div).fadeIn(300);
				  errors = [];
				  errors_div.focus();
				  return false;
				}
				
				$("#error-list").hide();
				return true;
		    }
		    </script>
			<%} %>
				
			
			<form id="new-manager-form" method="post" class="overflow-container" onsubmit="return validateNewManager()">
			<h3>Inserimento Gestore</h3>

				<label for="email">Email</label>
				<input id="email" name="email" type="text">
				<label for="password">Password</label>
				<input id="password" name="password" type="password">
				<label for="repeat_password">Ripeti Password</label>
				<input id="repeat_password" name="repeat_password" type="password">
				<label for="name">Nome</label>
				<input id="name" name="name"  type="text"> 
				<label for="surname">Cognome</label>
				<input id="surname" name="surname"  type="text"> 
				<label for="address">Indirizzo</label>
				<input id="address" name="address"  type="text"> 
				<label for="phone">Telefono</label>
				<input id="phone" name="phone"  type="text"> 
				
				<label>Ruolo</label>
				<br/>
				<input type="checkbox" id="customers_manager" name="customers_manager" value="Gestore Clienti">  Gestore Clienti<br>
				<input type="checkbox" id="books_manager" name="books_manager" value="Gestore Libri">  Gestore Libri<br>
				<input type="checkbox" id="cards_manager" name="cards_manager" value="Gestore Tessere">  Gestore Tessere<br>
				<input type="checkbox" id="bookings_manager" name="bookings_manager" value="Gestore Prenotazioni">  Gestore Prenotazioni<br>
				<input type="checkbox" id="library_manager" name="library_manager" value="Gestore Biblioteca">  Gestore Biblioteca<br>
				
				<button type="submit" class="save" formaction="admin?managers&new_manager"><i class="fas fa-plus fa-lg"></i>  Aggiungi Gestore</button>
				<button type="reset" class="cancel"><i class="fas fa-times fa-lg"></i> Pulisci campi</button>
		</form>
		<script>
		$(document).ready(function() {
			$("#library_manager").change(function() {
				if(document.getElementById("library_manager").checked) {
					$("#customers_manager").removeAttr("checked").attr("disabled", true);
					$("#books_manager").removeAttr("checked").attr("disabled", true);
					$("#cards_manager").removeAttr("checked").attr("disabled", true);
					$("#bookings_manager").removeAttr("checked").attr("disabled", true);
				}
				else {
					$("#customers_manager").removeAttr("disabled");
					$("#books_manager").removeAttr("disabled");
					$("#cards_manager").removeAttr("disabled");
					$("#bookings_manager").removeAttr("disabled");
				}
			});
		});
		</script>
	<script>
    $("#error-list").hide();
    var errors = [];
    function validateNewManager() {
    	var email_regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    	var name_regex = /^[A-zÀ-ú ]{1,30}$/;
    	var surname_regex = /^[A-zÀ-ú ]{1,30}$/;
    	var password_regex = /^.{6,20}$/;
    	var address_regex = /^[A-zÀ-ú0-9 ,]{5,100}$/;
    	var phone_regex = /^[0-9]{7,10}$/;
    	
		var email = document.getElementById("email").value;
		var name = document.getElementById("name").value;
		var surname = document.getElementById("surname").value;
		var password = document.getElementById("password").value;
		var repeat_password = document.getElementById("repeat_password").value;
		var address = document.getElementById("address").value;
		var phone = document.getElementById("phone").value;
		
		var customers_checkbox = document.getElementById("customers_manager");
		var books_checkbox = document.getElementById("books_manager");
		var cards_checkbox = document.getElementById("cards_manager");
		var bookings_checkbox = document.getElementById("bookings_manager");
		var library_checkbox = document.getElementById("library_manager");
		
		if(!email || !name || !surname || !address || !phone || 
				(!customers_checkbox.checked && !books_checkbox.checked && !cards_checkbox.checked && !bookings_checkbox.checked && !library_checkbox.checked)) {
		  errors.push("Non tutti i campi sono stati compilati.");
		}

		if((!email.match(email_regex) || (email.length < 5 || email.length > 100)) && email)
			errors.push("Indirizzo email non valido. Lunghezza massima 100 caratteri.");
		
		if(!name.match(name_regex) && name)
			errors.push("Il nome può contenere solo lettere. Lunghezza massima: 30 caratteri.");
		
		if(!surname.match(surname_regex) && surname)
			errors.push("Il cognome può contenere solo lettere. Lunghezza massima: 30 caratteri.");
		
		if(!address.match(address_regex) && address)
			errors.push("L'indirizzo non è compilato correttamente.");
		
		if(!phone.match(phone_regex) && phone)
			errors.push("Inserire un numero di telefono valido.");
		
		if(!password.match(password_regex) && password)
			errors.push("La password deve avere tra i 6 e i 20 caratteri.");
		
		if(password != repeat_password && password && repeat_password)
		  errors.push("Le password non corrispondono.");
		
		if(errors.length != 0) {
		  if(!document.getElementById("error-list")) {
		    var errors_div = document.createElement("div");
		    errors_div.setAttribute("id", "error-list");
		    errors_div.setAttribute("tabindex", "-1"); //per ottenerne il focus
		  }
		  else {
		    var errors_div = document.getElementById("error-list");
		  }
		  var txt = "<ul>";
		  $("#new-manager-form h3").before(errors_div);
		  errors_div.className = "error";
		  errors.forEach(showErrors);
		  errors_div.innerHTML = txt;
		
		  function showErrors(value, index, array) {
		    txt = txt + "<li>" + value + "</li>";
		  }
		
		  errors_div.innerHTML = txt + "</ul>";
		  $(errors_div).fadeIn(300);
		  errors = [];
		  errors_div.focus();
		  return false;
		}
		
		$("#error-list").hide();
		return true;
    }
    </script>
    <script>
	$(document).ready(function() {
	    $('.dropdownFilters').selectmenu();
	});
	
	$("#new-manager-form").hide();
	$("#update-manager-form").hide();
	$("#all-managers-div").hide();

	$(document).ready(function() {
		$("#btn-manager").click(function() {
			$("#update-manager-form").remove();
			$("#all-managers-div").hide();
			$("#new-manager-form").slideDown();
		});
	});	
	</script>   
    </div> <!-- fine section-container sezione Gestori -->
		
		<!-- Sezione Biblioteca -->
		<div id="library-section" class="section-container">
			<h2>Sezione Biblioteca</h2>
			
			<%if(request.getAttribute("info_library") != null) { %>
				<div class="info"><%=request.getAttribute("info_library") %></div>
			<%}
      		else if(request.getAttribute("error") != null) { %>
		  	<div class="error"><%=request.getAttribute("error") %></div>
			<%} %>
			
			<form method="post" enctype="multipart/form-data" onsubmit="return validateLibrary()">
				<label for="image-preview">Logo Biblioteca</label>
				<div style="float:left; width: 200px; height: 200px;" id="image-preview" class="image-preview" >
						<img src="${applicationScope.library.logo}" alt="Nessun immagine" onerror="this.onerror=null; this.src='./images/default_logo.png'">
				</div>
				<label id="btn-upload" for="image"><i class="far fa-images"></i></label>
				<input id="image" class="image" type="file" name="file" accept=".jpg, .jpeg, .png">
				<label for="library_name">Nome biblioteca</label>
				<input id="library_name" name="name" type="text" value="${applicationScope.library.name}">
				<label for="contacts">Contatti</label>
				<textarea id="contacts" name="contacts" rows="6" cols="60">${applicationScope.library.contacts}</textarea>
				<button type="submit" class="save" formaction="admin?library&save_library"><i class="fas fa-save fa-lg"></i> Salva modifiche</button>
				<button type="reset" class="cancel"><i class="fas fa-times fa-lg"></i> Annulla modifiche</button>
				<script>
                    $(".cancel").click(function() {
                        $("#image-preview").html('<img src="${applicationScope.library.logo}" alt="Nessun immagine">');
                    });
                </script>
				<script>
				/*Script per il caricamento delle immagini e preview*/
				var file = document.getElementById("image");
				
				file.style.opacity = 0; /*Nascondo il pulsante di default (pulsante Sfoglia...)*/
				$("#image").change(function() {
					$("#error-list").hide();
					if(file.files[0].type !== 'image/jpeg' && file.files[0].type !== 'image/jpg' && file.files[0].type !== 'image/png') {
						validateLibrary();
						return false;
					}
					var img = new Image();
					var canvas = document.createElement("canvas");
					canvas.width = 1000;
					canvas.height = 1000;
					img.onload = function() {
						var ctx = canvas.getContext("2d");
						ctx.drawImage(img, 0, 0, 1000, 1000);
					};
					img.src = URL.createObjectURL(file.files[0]);
					$("#image-preview").html(canvas);
					return true;
				});
				</script>
			</form>
			<script>
		    $("#error-list").hide();
		    var errors = [];
		    function validateLibrary() {
		    	var library_regex = /^[A-zÀ-ú ]{1,100}$/;
		    	var contacts_regex = /^[\s\S]{1,300}$/;
		    	
		    	var file = document.getElementById("image");
				var library_name = document.getElementById("library_name").value;
				var contacts = document.getElementById("contacts").value;
				
				if(!library_name || !contacts) {
				  errors.push("Non tutti i campi sono stati compilati.");
				}
				
				if(file.files[0].type !== 'image/jpeg' && file.files[0].type !== 'image/jpg' && file.files[0].type !== 'image/png') {
					errors.push("L'immagine deve avere il formato: .png, .jpg, oppure .jpeg.");
					$("#image-preview").html('<img src="${applicationScope.library.logo}" alt="Nessun immagine">');
					file.value = ""; //reset immagine
				}
				else if(file.files[0].size <= 0 || file.files[0].size > 2097152 /*2MB*/)
					errors.push("Dimensione massima immagine consentita: 2MB.");

				if(!library_name.match(library_regex) && library_name)
					errors.push("Il nome della biblioteca può contenere solo spazi e lettere. Lunghezza massima: 100 caratteri.");
				
				if(!contacts.match(contacts_regex) && contacts)
					errors.push("Le informazioni sui contatti non possono superare i 300 caratteri.");
				
				if(errors.length != 0) {
				  if(!document.getElementById("error-list")) {
				    var errors_div = document.createElement("div");
				    errors_div.setAttribute("id", "error-list");
				    errors_div.setAttribute("tabindex", "-1"); //per ottenerne il focus
				  }
				  else {
				    var errors_div = document.getElementById("error-list");
				  }
				  var txt = "<ul>";
				  $("#library-section h2").after(errors_div);
				  errors_div.className = "error";
				  errors.forEach(showErrors);
				  errors_div.innerHTML = txt;
				
				  function showErrors(value, index, array) {
				    txt = txt + "<li>" + value + "</li>";
				  }
				
				  errors_div.innerHTML = txt + "</ul>";
				  $(errors_div).fadeIn(300);
				  errors = [];
				  errors_div.focus();
				  return false;
				}
				
				$("#error-list").hide();
				return true;
		    }
		    </script>
		</div> <!-- fine section-container sezione Biblioteca -->
	<%} %>
		
    
	<!-- Script per il cambio di sezioni (cambio highlight della sezione "attiva" e relativo container di destra) -->
	<script>
		$(".section-container").hide();
		$(".sidebar section, .sidebar-responsive section").removeClass("active");
		<%if(request.getParameter("account") != null) {%>
			$("#customers-section").show();
			$("#sidebar-customers").addClass("active");
			$(".sidebar-responsive #sidebar-customers").addClass("active");
		<% } else if(request.getParameter("books") != null) {%>
			$("#books-section").show();
			$(".sidebar #sidebar-books").addClass("active");
			$(".sidebar-responsive #sidebar-books").addClass("active");
		<%} else if(request.getParameter("cards") != null) { %>
			$("#cards-section").show();
			$(".sidebar #sidebar-cards").addClass("active");
			$(".sidebar-responsive #sidebar-cards").addClass("active");
		<%} else if(request.getParameter("bookings") != null) { %>
			$("#bookings-section").show();
			$(".sidebar #sidebar-bookings").addClass("active");
			$(".sidebar-responsive #sidebar-bookings").addClass("active");
			<%} else if(request.getParameter("managers") != null) { %>
			$("#managers-section").show();
			$(".sidebar #sidebar-managers").addClass("active");
			$(".sidebar-responsive #managers-section").addClass("active");
			<%} else if(request.getParameter("library") != null) { %>
			$("#library-section").show();
			$(".sidebar #sidebar-library").addClass("active");
			$(".sidebar-responsive #sidebar-library").addClass("active"); 
		<%} else {%>
			$(".section-container").eq(0).show();
			$(".sidebar section").eq(0).addClass("active");
			$(".sidebar-responsive section").eq(0).addClass("active");
		<%}%>
		
			$("section").click(function() {
				if($("section").hasClass("active")) {
					$("section").removeClass("active");
					$(".section-container").hide();
					$(this).addClass("active");
					$(".section-container").eq($(this).index()).show();
				}
			});
	</script>
		
	</div> <!-- Chiusura del div "container" in cima -->
<% } /*Chiusura dell'else in cima (quello che fa iniziare il pannello di controllo)*/%>
	
<%@include file="./jsp/layout/footer.jsp" %>

</body>
</html>