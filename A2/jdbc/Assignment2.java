// CSC343, Introduction to Databases
// Department of Computer Science, University of Toronto

// This code is provided solely for the personal and private use of
// students taking the course CSC343 at the University of Toronto.
// Copying for purposes other than this use is expressly prohibited.
// All forms of distribution of this code, whether as given or with
// any changes, are expressly prohibited.

// Authors: Diane Horton and Marina Tawfik

// Copyright (c) 2020 Diane Horton and Marina Tawfik

import java.sql.*;
import java.util.ArrayList;

public class Assignment2 {

  // A connection to the database
  Connection connection;

  Assignment2() throws SQLException {
    try {
      Class.forName("org.postgresql.Driver");
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
  }

  /**
   * Connects and sets the search path.
   *
   * Establishes a connection to be used for this session, assigning it to the
   * instance variable 'connection'. In addition, sets the search path to Library,
   * public.
   *
   * @param url      the url for the database
   * @param username the username to connect to the database
   * @param password the password to connect to the database
   * @return true if connecting is successful, false otherwise
   */
  public boolean connectDB(String url, String username, String password) {
    String queryString;
    PreparedStatement pStatement;
    try {
      connection = DriverManager.getConnection(url, username, password);
      queryString = "SET SEARCH_PATH TO Library, public;";
      pStatement = connection.prepareStatement(queryString);
      int rows = pStatement.executeUpdate();
		  System.out.println("connected");
    } catch (SQLException se) {
        System.err.println("SQL Exception." +
                "<Message>: " + se.getMessage());
    }
    return false;
  }

  /**
   * Closes the database connection.
   *
   * @return true if the closing was successful, false otherwise
   */
  public boolean disconnectDB() {
    // Replace the line below and implement this method!
    return false;	  
  }
   
  /**
   * Returns the titles of all holdings at the given library branch 
   * by any contributor with the given last name. 
   * If no matches are found, returns an empty list.
   * If two different holdings happen to have the same title, returns both
   * titles.
   * 
   * @param  lastName  the last name to search for. 
   * @param  branch    the unique code of the branch to search within. 
   * @return           a list containing the titles of the matched items.  
   */
  public ArrayList<String> search(String lastName, String branch) {
    // Replace the line below and implement this method!
    return null;
  }

  /**
   * Records a patron's registration for a specific event.
   * Returns True iff
   *  (1) the card number and event ID provided are both valid 
   *  (2) This patron is not already registered for this event
   * Otherwise, returns False.
   *
   * @param  cardNumber  card number of the patron.
   * @param  eventID     id of the event.
   * @return             true if the operation was successful 
   *                     (as per the above criteria), and false otherwise.
   */
  public boolean register(String cardNumber, int eventID) {
    // Replace the line below and implement this method!
    return false;
  }

  /**
   * Records that a checked out library item was returned and returns 
   * the fines incurred on that item.
   *
   * Does so by inserting a row in the Return table and updating the
   * LibraryCatalogue table to indicate the revised number of copies 
   * available.
   * 
   * Uses the same due date rules as the SQL queries.
   * The fines incurred are calculated as follows: for every day overdue 
   * i.e. past the due date:
   *    books and audiobooks incurr a $0.50 charge
   *    other holding types incurr a $1.00 charge
   * 
   * A return operation is considered successful iff:
   *    (1) The checkout id provided is valid. 
   *    (2) A return has not already been recorded for this checkout
   *    (3) The number of available copies is less than the number of holdings
   * If the return operation is unsuccessful, the db instance should not 
   * be modified at all.
   * 
   * @param  checkout  id of the checkout
   * @return           the amount of fines incurred if the return operation
   *                   was successful, -1 otherwise.
   */
  public double item_return(int checkout) {
    // Replace the line below and implement this method!
    return 0.0;
  }

  public double test_query() {
    String queryString;
    PreparedStatement pStatement;
    ResultSet rs;
    queryString = "select * from LibraryBranch";
                pStatement = connection.prepareStatement(queryString);
                rs = pStatement.executeQuery();

                // Iterate through the result set and report on each row.
    while (rs.next()) {
        String code = rs.getString("code");
        int ward = rs.getInt("ward");
        System.out.println(code + ":" + ward);
    }
    return 0.0;
  }

  public static void main(String[] args) {

    Assignment2 a2;
    try {
      // Demo of using an ArrayList.
      ArrayList<String> baking = new ArrayList<String>();
      baking.add("croissant");
      baking.add("choux pastry");
      baking.add("jelly roll");

      // Make an instance of the Assignment2 class.  It has an instance 
      // variable that will hold on to our database connection as long
      // as the instance exists -- even between method calls.
      a2 = new Assignment2();

      // Use your connect method to connect to your database.  You need
      // to pass in the url, username, and password, rather than have them
      // hard-coded in the method.  (This is different from the JDBC code
      // we worked on in a class exercise.) Replace the XXXXs with your
      // username, of course.
      a2.connectDB("jdbc:postgresql://localhost:5432/csc343h-yangric6", "yangric6", "");
      a2.test_query();
      // You can call your methods here to test them. It will not affect our 
      // autotester.
      System.out.println("Boo!");
    }
    catch (Exception ex) {      
      System.out.println("exception was thrown");
      ex.printStackTrace();
    }
  }

}

