// A simple JDBC example.

// Remember that you need to put the jdbc postgresql driver in your class path
// when you run this code.
// See /local/packages/jdbc-postgresql on the CS teaching labs for the driver, another example
// program, and a how-to file.

// To compile and run this program on the CS teaching labs:
// (1) Compile the code in Example.java.
//     javac Example
// This creates the file Example.class.
// (2) Run the code in Example.class.
// Normally, you would run a Java program whose main method is in a class 
// called Example as follows:
//     java Example
// But we need to also give the class path to where JDBC is, so we type:
//     java -cp /local/packages/jdbc-postgresql/postgresql-42.2.4.jar.jar: Example
// Alternatively, we can set our CLASSPATH variable in linux.  (See
// /local/packages/jdbc-postgresql/HelloPostgresql.txt on the CS teaching labs
// for how.)

import java.sql.*;
import java.io.*;

class Example {
    
    public static void main(String args[]) throws IOException
        {
            // This example code connects to my database csc343h-dianeh,
            // where I have already loaded a table called Guess, with 
            // this schema:
            //     Guesses(number, name, guess, age)
            // and put some data into it.

            String url;
            Connection conn;
            PreparedStatement pStatement;
            ResultSet rs;
            String queryString;

            try {
                Class.forName("org.postgresql.Driver");
            }
            catch (ClassNotFoundException e) {
                System.out.println("Failed to find the JDBC driver");
            }
            try
            {                
                // Establish a connection to the database.
                // This is the right url, username and password for jdbc
                // with postgres on the CS teaching labs -- but you would 
                // replace "dianeh" with your CS teaching labs account name.
                // Password really does need to be the emtpy string.
                url = "jdbc:postgresql://localhost:5432/csc343h-yangric6";
                conn = DriverManager.getConnection(url, "yangric6", "");

                // Show all the guesses stored in the database.
                // Executing this particular query without having first
                // prepared it would be safe because the entire query is  
                // hard-coded.  No one can inject any SQL code into our query.
                // But let's get in the habit of using a prepared statement.
                // Notice that there is no semi-colon at the end of the query.
		queryString = "SET SEARCH_PATH TO Library, public;";
		pStatement = conn.prepareStatement(queryString);
		System.out.println("not connected");
                int rows = pStatement.executeUpdate();
		System.out.println("connected");
                queryString = "select * from LibraryBranch";
                pStatement = conn.prepareStatement(queryString);
                rs = pStatement.executeQuery();

                // Iterate through the result set and report on each row.
                while (rs.next()) {
                    String code = rs.getString("code");
                    int ward = rs.getInt("ward");
                    System.out.println(code + ":" + ward);
                }
            }
            catch (SQLException se)
            {
            	System.err.println("SQL Exception." +
                        "<Message>: " + se.getMessage());
            }
        }
}