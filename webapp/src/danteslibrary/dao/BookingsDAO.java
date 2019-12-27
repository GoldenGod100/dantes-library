package danteslibrary.dao;

import java.sql.*;
import java.time.LocalDate;

import danteslibrary.util.DBConnection;
import danteslibrary.model.BookingsBean;

import java.util.ArrayList;

public class BookingsDAO {
	
	public int newBooking(String email, String start_date, String end_date, String state_name, int card_id, int book_id) {
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("INSERT INTO bookings(email, start_date, end_date, state_name, card_id, book_id) "
					+ "VALUES(?, ?, ?, ?, ?, ?)");
			ps.setString(1, email);
			ps.setString(2, start_date);
			ps.setString(3, end_date);
			ps.setString(4, state_name);
			ps.setInt(5, card_id);
			ps.setInt(6, book_id);
			
			return ps.executeUpdate(); 
		}
		catch(SQLException e) {
			System.out.println("Errore Database: " + e.getMessage());
		}
		return 0;
	}
	
	public ArrayList<BookingsBean> getBookingsByFilter(int filter, String keyword) {
		String[] filters = {"booking_id", "book_id", "bookings.card_id", "cards.codice_fiscale", "state_name", "email", "start_date", "end_date"};
		ArrayList<BookingsBean> bookings = new ArrayList<BookingsBean>();
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("SELECT bookings.booking_id, bookings.card_id, bookings.book_id, cards.codice_fiscale, bookings.state_name, bookings.start_date, bookings.end_date  FROM bookings, cards WHERE "+filters[filter]+"= ? AND cards.card_id = bookings.card_id");
			ps.setString(1, keyword);
			ResultSet result = ps.executeQuery();
			if(!result.isBeforeFirst()) /*Nessuna corrispondenza trovata nel DB, restituisco null*/
				return null;
			
			while(result.next()) {
				int booking_id = result.getInt("booking_id");
				int card_id = result.getInt("card_id");
				int book_id = result.getInt("book_id");
				String codice_fiscale = result.getString("codice_fiscale");
				String state_name = result.getString("state_name");
				LocalDate start_date = result.getDate("start_date").toLocalDate();
				LocalDate end_date = result.getDate("end_date").toLocalDate();
				
				BookingsBean booking = new BookingsBean();
				booking.setBooking_id(booking_id);
				booking.setCard_id(card_id);
				booking.setBook_id(book_id);
				booking.setCodice_fiscale(codice_fiscale);
				booking.setState_name(state_name);
				booking.setStart_date(start_date);
				booking.setEnd_date(end_date);

				bookings.add(booking);
			}
			conn.close();
			return bookings;
		}
		catch(SQLException e) {
			System.out.println("Errore Database: " + e.getMessage());
		}
		return null;
	}
	
public ArrayList<BookingsBean> getAllBookings() {
		
		ArrayList<BookingsBean> bookings = new ArrayList<BookingsBean>();
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("SELECT bookings.booking_id, bookings.card_id, bookings.book_id, cards.codice_fiscale, bookings.state_name, bookings.start_date, bookings.end_date  FROM bookings, cards WHERE  cards.card_id = bookings.card_id");
			ResultSet result = ps.executeQuery();
			if(!result.isBeforeFirst()) /*Nessuna corrispondenza trovata nel DB, restituisco null*/
				return null;
			
			while(result.next()) {
				int booking_id = result.getInt("booking_id");
				int card_id = result.getInt("card_id");
				int book_id = result.getInt("book_id");
				String codice_fiscale = result.getString("codice_fiscale");
				String state_name = result.getString("state_name");
				LocalDate start_date = result.getDate("start_date").toLocalDate();
				LocalDate end_date = result.getDate("end_date").toLocalDate();
				
				BookingsBean booking = new BookingsBean();
				booking.setBooking_id(booking_id);
				booking.setCard_id(card_id);
				booking.setBook_id(book_id);
				booking.setCodice_fiscale(codice_fiscale);
				booking.setState_name(state_name);
				booking.setStart_date(start_date);
				booking.setEnd_date(end_date);

				bookings.add(booking);
			}
			conn.close();
			return bookings;
		}
		catch(SQLException e) {
			System.out.println("Errore Database: " + e.getMessage());
		}
		return null;
	}

	public int removeBooking(String booking_id) {
		int result = 0;
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("DELETE FROM bookings WHERE booking_id = ?");
			ps.setString(1, booking_id);
			result = ps.executeUpdate();
			conn.close();
			return result;
		}
		catch(SQLException e) {
			System.out.println("Errore Database: " + e.getMessage());
		}
		return result;
	}
	
	public ArrayList<BookingsBean> getUserBookings(String email) {
		ArrayList<BookingsBean> bookings = new ArrayList<BookingsBean>();
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("SELECT bookings.* FROM bookings WHERE bookings.email = ?");
			ps.setString(1, email);
			ResultSet result = ps.executeQuery();
			if(!result.isBeforeFirst()) /*Nessuna corrispondenza trovata nel DB, restituisco null*/
				return null;
			
			while(result.next()) {
				int booking_id = result.getInt("booking_id");
				int card_id = result.getInt("card_id");
				int book_id = result.getInt("book_id");
				String state_name = result.getString("state_name");
				LocalDate start_date = result.getDate("start_date").toLocalDate();
				LocalDate end_date = result.getDate("end_date").toLocalDate();
				
				BookingsBean booking = new BookingsBean();
				booking.setBooking_id(booking_id);
				booking.setCard_id(card_id);
				booking.setBook_id(book_id);
				booking.setState_name(state_name);
				booking.setStart_date(start_date);
				booking.setEnd_date(end_date);

				bookings.add(booking);
			}
			conn.close();
			return bookings;
		}
		catch(SQLException e) {
			System.out.println("Errore Database: " + e.getMessage());
		}
		return null;
	}

}