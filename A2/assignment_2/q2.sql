-- Overdue Items

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q2 cascade;

create table q2 (
    branch CHAR(5),
    email TEXT,
    title TEXT,
    overdue INT
);


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here:

-- Save current date 
DROP VIEW IF EXISTS curr_date CASCADE; 
CREATE VIEW curr_date AS SELECT current_date;

-- Gets all branches from the php ward
DROP VIEW IF EXISTS php_branches CASCADE;
CREATE VIEW php_branches AS 
SELECT code 
FROM LibraryBranch JOIN Ward ON ward=id
WHERE Ward.name = 'Parkdale-High Park';

-- Get all checkouts from the branches in the php ward
DROP VIEW IF EXISTS php_branches_checkouts;
CREATE VIEW php_branches_checkouts AS
SELECT library branch, id, patron, holding, DATE(checkout_time) checkout_time
FROM Checkout 
WHERE library = ANY ( SELECT * FROM php_branches);

-- Get all the checkouts which have yet to be returned 
DROP VIEW IF EXISTS not_returned_checkouts;
CREATE VIEW not_returned_checkouts AS 
SELECT branch, id, patron, DATE(checkout_time) checkout_time
FROM php_branches_checkouts
WHERE id != ANY (SELECT checkout FROM Return);

-- Determines the duedates for all items yet to be returned from php ward branches
DROP VIEW IF EXISTS duedate_data;
CREATE VIEW duedate_data AS
SELECT branch, patron, title, checkout_time, 
CASE 
    WHEN htype = 'movies' OR htype = 'music' OR htype = 'magazines and newspapers'
        THEN checkout_time + 7
    WHEN htype = 'books' OR htype = 'audiobooks'
        THEN checkout_time + 21
END duedate
FROM not_returned_checkouts p JOIN Holding h ON p.holding = h.id;

-- Determine overdue books 
DROP VIEW IF EXISTS overdue_data
CREATE VIEW overdue_data AS
SELECT branch, patron, title, email 
FROM duedate_data JOIN Patron ON patron = card_number 
WHERE duedate < (SELECT current_date);


-- Your query that answers the question goes below the "insert into" line:
--insert into q2
