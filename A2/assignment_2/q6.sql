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
SELECT holding, max(contributor) author
FROM HoldingContributor 
GROUP BY holding 
HAVING count(contributor) = 1;

-- Gets all books with only one contributor 
DROP VIEW IF EXISTS single_author_books;
CREATE VIEW single_author_books AS 
SELECT holding, contributor author
FROM author_publications JOIN Holding ON holding=id 
WHERE htype = 'books';

-- Get a count of all books written by each contributor 
DROP VIEW IF EXISTS author_works; 
CREATE VIEW author_works AS 
SELECT author, count(holding)
FROM single_author_books 
GROUP BY author
-- Gets all checkouts of books with single authors 
DROP VIEW IF EXISTS book_checkouts; 
CREATE VIEW book_checkouts AS 
SELECT patron, author, count(c.holding) books_checked_out
FROM Checkout c JOIN single_author_books s ON c.holding = s.holding
GROUP BY patron, author;

-- Get a count of author works checked out by the patrons 
-- DROP VIEW IF EXISTS patron_author_count;
-- CREATE VIEW patron_author_count AS 
-- SELECT patron, author, count(holding)
-- FROM book_checkouts

-- Your query that answers the question goes below the "insert into" line:
-- insert into q6