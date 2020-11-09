-- Devoted Fans

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q6 cascade;

CREATE TABLE q6 (
    patronID Char(20),
    devotedness INT
);


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;


-- Define views for your intermediate steps here:

-- Gets all holdings with only one contributor 
DROP VIEW IF EXISTS author_publications;
CREATE VIEW author_publications AS 
SELECT holding, max(contributor) contributor
FROM HoldingContributor 
GROUP BY holding 
HAVING count(contributor) = 1;

-- Gets all books with only one contributor 
DROP VIEW IF EXISTS single_author_books;
CREATE VIEW single_author_books AS 
SELECT holding, contributor 
FROM author_publications JOIN Holding ON holding=id 
WHERE htype = 'book';
-- Your query that answers the question goes below the "insert into" line:
-- insert into q6