<%@ page language="java" contentType="text/html; charset=UTF-8" 
pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" /> 
	<title>Dante's Library | Accedi</title>
	<link rel="stylesheet" href="./css/style.css"/>
</head>
<body>
    

	

<div id="form-container">
<h2>Accedi</h2>
	<form id="sign-form" class="box" action="login" method="post">
		<label for="email">Email</label>
		<input id="email" type="text" name="email"/>
		<label for="password">Password</label>
		<input id="password" type="password" name="password"/><br/><br/>
		
		<button type="submit">Accedi</button>
	</form>	

			
	<form id="sign-in-box" class="box" action="registration.jsp">
		<small>Sei un nuovo utente?&nbsp;&nbsp;&nbsp;</small>
		<button type="submit">Registrati</button>
	</form>
</div>
	
<%@ include file="../layout/footer.jsp" %>

</body>
</html>