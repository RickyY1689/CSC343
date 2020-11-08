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
WHERE name = 'Parkdale-High Park';


-- Your query that answers the question goes below the "insert into" line:
--insert into q2
