-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Get all checkouts from the branches in the php ward
DROP VIEW IF EXISTS downsview_checkouts CASCADE;
CREATE VIEW downsview_checkouts AS
SELECT library branch, id, patron, holding, DATE(checkout_time) checkout_time
FROM Checkout 
WHERE library = (SELECT code FROM LibraryBranch WHERE name='Downsview');

-- Get all the checkouts which have yet to be returned 
DROP VIEW IF EXISTS not_returned_checkouts CASCADE;
CREATE VIEW not_returned_checkouts AS 
SELECT branch, id, patron, holding, DATE(checkout_time) checkout_time
FROM downsview_checkouts
WHERE id != ANY (SELECT checkout FROM Return);

-- Determines the duedates for all items yet to be returned from php ward branches
DROP VIEW IF EXISTS duedate_data CASCADE;
CREATE VIEW duedate_data AS
SELECT branch, patron, n.holding, checkout_time, (checkout_time + 7) duedate
FROM not_returned_checkouts n JOIN Holding h ON n.holding = h.id
WHERE htype = 'books';

-- Determine overdue books 
DROP VIEW IF EXISTS overdue_data CASCADE;
CREATE VIEW overdue_data AS
SELECT branch, holding, patron, ((SELECT current_date)-duedate)::INTEGER overdue
FROM duedate_data JOIN Patron ON patron = card_number 
WHERE duedate < (SELECT current_date);

-- Determine patrons who have checked out no more than 5 books 
DROP VIEW IF EXISTS small_checkouts CASCADE;
CREATE VIEW small_checkouts AS 
SELECT patron
FROM Checkout 
GROUP BY patron
HAVING count(id) <= 5;

-- Qualifying patrons who have less than 5 books checked out and none are overdue by more than 7 days
DROP VIEW IF EXISTS qualifying_patrons CASCADE;
CREATE VIEW qualifying_patrons AS 
SELECT o.patron
FROM overdue_data o JOIN small_checkouts s ON o.patron = s.patron
GROUP BY o.patron
HAVING max(overdue) <= 7;

DROP VIEW IF EXISTS auto_renew_holdings CASCADE;
CREATE VIEW auto_renew_holdings AS 
SELECT holding
FROM overdue_data o JOIN qualifying_patrons p ON o.patron = p.patron;

-- Define views for your intermediate steps here, and end with a
-- INSERT, DELETE, or UPDATE statement.

UPDATE Checkout 
SET checkout_time = checkout_time + interval '336 hours'
WHERE holding = ANY (SELECT holding FROM auto_renew_holdings);