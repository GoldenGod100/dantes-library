package danteslibrary.control;

import javax.servlet.http.*;
import javax.servlet.annotation.*;
import javax.servlet.ServletException;

import java.io.*;
import java.util.ArrayList;


import danteslibrary.dao.*;
import danteslibrary.model.*;



@WebServlet("/admin")
@MultipartConfig /*Necessario perch� nella pagina admin.jsp abbiamo una form
 				con enctype="multipart/form-data"*/
public class ManagerServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		HttpSession session = request.getSession();
		
		/*[ FUNZIONALIT� AMMINISTRATORE ]
		 * disponibili solo se � autenticato (admin != null)*/
		if(session.getAttribute("admin") != null) {
			/* - Ricerca account utente tramite email */
			
			if(request.getParameter("keyword") != null && request.getParameter("keyword") != "") {
				String keyword = request.getParameter("keyword");
				/*filter puo' assumere 4 valori:
				 * - 0: nome
				 * - 1: cognome
				 * - 2: email
				 * - 3: codice fiscale */
				int filter = Integer.parseInt(request.getParameter("filter"));
				if(filter < 0 || filter > 3) {
					request.setAttribute("info", "Filtro non valido.");
					request.getRequestDispatcher("admin.jsp").forward(request, response);
					return;
				} 
				else {
					UsersDAO dao = new UsersDAO();
					ArrayList<UsersBean> users = dao.getUsersByFilter(filter, keyword);
					request.setAttribute("users", users);
				}
			}
			/* - Mostra tutti gli utenti presenti nel database*/
			else if(request.getParameter("all_users") != null) {
				UsersDAO dao = new UsersDAO();
				ArrayList<UsersBean> users = dao.getAllUsers();
				request.setAttribute("users", users);
			}
			/* - Rimozione utente dal database (data la mail in input)*/
			else if(request.getParameter("remove_user") != null) {
				UsersDAO dao = new UsersDAO();
				dao.removeUser(request.getParameter("remove_user"));
				request.setAttribute("info", request.getParameter("remove_user"));
			}
			request.getRequestDispatcher("admin.jsp").forward(request, response);
			return;
		}
		
		
		
		if(email == null || password == null) {
			response.sendRedirect("admin.jsp");
			return;
		}
		
		/*Autenticazione*/
		else {
			ManagersDAO dao = new ManagersDAO();
			ManagersBean admin = dao.login(email, password);
			
			if(admin != null) {
				session.setAttribute("admin", admin);
				session.removeAttribute("user"); /*Distruggo la sessione per l'utente(nel caso in cui sia collegato)*/
			}
			else {
				request.setAttribute("login_error", true);
				request.getRequestDispatcher("admin.jsp").forward(request, response);
				return;
			}
		}
		/*Se l'autenticazione va a buon fine, l'utente viene reindirizzato all'
		 * homepage*/
		response.sendRedirect("admin.jsp");
		return;
		
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}