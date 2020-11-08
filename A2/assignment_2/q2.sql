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

DROP VIEW IF EXISTS php_branches CASCADE;
CREATE VIEW php_branches AS 
SELECT code 
FROM LibraryBranch JOIN Ward ON ward=id
WHERE Ward.name = 'Parkdale-High Park';

DROP VIEW IF EXISTS php_branches_checkouts;
CREATE VIEW php_branches_checkouts AS
SELECT id, patron, holding, checkout_time, 
FROM Checkout 
WHERE library = ANY ( SELECT * FROM php_branches);

DROP VIEW IF EXISTS duedate_data;
CREATE VIEW duedate_data AS
SELECT patron, checkout_time, 
CASE 
    WHEN htype = 'movies' OR htype = 'music' OR htype = 'magazines and newspapers'
        THEN checkout_time + 7
    WHEN htype = 'books' OR htype = 'audiobooks'
        THEN checkout_time + 21
END duedate
FROM p php_branches_checkouts JOIN h Holding ON p.holding = h.id 
-- Your query that answers the question goes below the "insert into" line:
--insert into q2
