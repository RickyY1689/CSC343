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
DROP VIEW IF EXISTS author_publications CASCADE;
CREATE VIEW author_publications AS 
SELECT holding, max(contributor) author
FROM HoldingContributor 
GROUP BY holding 
HAVING count(contributor) = 1;

-- Gets all books with only one contributor 
DROP VIEW IF EXISTS single_author_books CASCADE;
CREATE VIEW single_author_books AS 
SELECT holding, author
FROM author_publications JOIN Holding ON holding=id 
WHERE htype = 'books';

-- Get a count of all books written by each contributor 
DROP VIEW IF EXISTS author_works CASCADE;
CREATE VIEW author_works AS 
SELECT author, count(holding) books_written
FROM single_author_books 
GROUP BY author;

-- Gets all checkouts of books with single authors 
DROP VIEW IF EXISTS book_checkouts CASCADE; 
CREATE VIEW book_checkouts AS 
SELECT patron, author, count(c.holding) books_checked_out
FROM Checkout c JOIN single_author_books s ON c.holding = s.holding
GROUP BY patron, author;

-- Gets reviews written by patrons who have checked out the books written by authors 
DROP VIEW IF EXISTS book_reviews CASCADE; 
CREATE VIEW book_reviews AS 
SELECT patron, author, count(review) books_reviewed, avg(stars) avg_rating
FROM Review r JOIN single_author_books s ON r.holding = s.holding
GROUP BY patron, author;

-- Only keeps patrons who have reviewed all of an authors books they have checked out and averaged a 4 star rating
DROP VIEW IF EXISTS commited_fans CASCADE;
CREATE VIEW commited_fans AS 
SELECT b1.patron, b1.author, b1.books_checked_out
FROM book_checkouts b1 JOIN book_reviews b2 ON (b1.patron=b2.patron AND b1.author=b2.author)
WHERE b1.books_checked_out = b2.books_reviewed AND avg_rating >= 4;

-- Gets all fans who have read all or all but one of an authors works
DROP VIEW IF EXISTS devoted_fans CASCADE;
CREATE VIEW devoted_fans AS 
SELECT c.patron, c.author
FROM commited_fans c JOIN author_works a ON c.author=a.author
WHERE c.books_checked_out >= a.books_written - 1;

DROP VIEW IF EXISTS patron_devotedness CASCADE;
CREATE VIEW patron_devotedness AS 
SELECT p.card_number, count(author)
FROM devoted_fans d FULL JOIN Patron p ON d.patron = p.card_number
GROUP BY p.card_number;

-- Get a count of author works checked out by the patrons 
-- DROP VIEW IF EXISTS patron_author_count;
-- CREATE VIEW patron_author_count AS 
-- SELECT patron, author, count(holding)
-- FROM book_checkouts

-- Your query that answers the question goes below the "insert into" line:
insert into q6
SELECT * FROM patron_devotedness;