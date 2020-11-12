-- Branch Activity

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q1 cascade;

CREATE TABLE q1 (
    branch CHAR(5),
    year INT,
    events INT NOT NULL,
    sessions FLOAT NOT NULL,
    oh shregistration INT NOT NULL,
    holdings INT NOT NULL,
    checkouts INT NOT NULL,
    duration FLOAT
);


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here:

-- Sets up the view to store results into later with each branch having the required years
DROP VIEW IF EXISTS branch_years CASCADE;
CREATE VIEW branch_years AS 
SELECT code branchId, years.y branchYear
FROM LibraryBranch CROSS JOIN (VALUES (2015), (2016), (2017), (2018), (2019)) years(y);

-- Associates all events with their respective branch 
DROP VIEW IF EXISTS branch_events CASCADE;
CREATE VIEW branch_events AS 
SELECT library branchId, l1.id eventId, require_sign_up
FROM LibraryEvent l1 JOIN LibraryRoom l2 ON l1.room = l2.id;

-- Stores the events at branches at some year 
DROP VIEW IF EXISTS branch_events_data CASCADE;
CREATE VIEW branch_events_data AS 
SELECT DISTINCT branchId, EXTRACT(YEAR FROM edate) branchYear, e.event eventId
FROM branch_events b JOIN EventSchedule e ON b.eventId = e.event 
WHERE EXTRACT(YEAR FROM edate) >= 2015 AND EXTRACT(YEAR FROM edate) <= 2019;

-- Stores the average number of sessions for all events at a branch during some year 
DROP VIEW IF EXISTS branch_events_sessions CASCADE;
CREATE VIEW branch_events_sessions AS 
SELECT branchId, branchYear, avg(e.event) avgSessions
FROM branch_events_data b JOIN EventSchedule e ON b.eventId = e.event 
GROUP BY branchId, eventYear;

-- Stores the number of registrations at a branch during some year 
DROP VIEW IF EXISTS branch_events_reg CASCADE;
CREATE VIEW branch_events_reg AS 
SELECT branchId, branchYear, count(patron) 
FROM branch_events_data b JOIN EventSignUp e ON b.eventId = e.event 
GROUP BY branchId, eventYear;

-- get num of holdings at all branches 
DROP VIEW IF EXISTS branch_holdings CASCADE;
CREATE VIEW branch_holdings AS 
SELECT library branchID, sum(num_holdings)
FROM LibraryCatalogue 
GROUP BY library;

-- get num of checkouts at all branches 
DROP VIEW IF EXISTS branch_num_checkouts CASCADE;
CREATE VIEW branch_num_checkouts AS 
SELECT library branchID, EXTRACT(YEAR from DATE(checkout_time)) branchYear, count(*)
FROM Checkout
GROUP BY branchId, eventYear
HAVING EXTRACT(YEAR from DATE(checkout_time)) >= 2015 AND EXTRACT(YEAR from DATE(checkout_time)) <= 2019;

-- get the checkout information formated
DROP VIEW IF EXISTS branch_checkout CASCADE;
CREATE VIEW branch_checkout AS 
SELECT library branchID, EXTRACT(YEAR from DATE(checkout_time)) branchYear, id checkoutId, DATE(checkout_time) checkout_time
FROM Checkout
WHERE EXTRACT(YEAR from DATE(checkout_time)) >= 2015 AND EXTRACT(YEAR from DATE(checkout_time)) <= 2019;

-- get average number of days between checkout and return for all items 
DROP VIEW IF EXISTS branch_return_time CASCADE;
CREATE VIEW branch_return_time AS 
SELECT branchID, eventYear, avg(return_time) avg_return_time
FROM (SELECT branchID, branchYear, (DATE(return_time) - checkout_time)::INTEGER return_time
    FROM branch_checkout b JOIN Return r ON b.checkoutId = r.checkout) rs
GROUP BY branchID, eventYear;

SELECT * 
FROM branch_years NATURAL LEFT JOIN branch_events_sessions;


-- Your query that answers the question goes below the "insert into" line:
-- insert into q1