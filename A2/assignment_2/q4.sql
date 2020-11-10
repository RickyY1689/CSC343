-- Explorers Contest

-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;
DROP TABLE IF EXISTS q4 cascade;

CREATE TABLE q4 (
    patronID CHAR(20)
);


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;


-- Define views for your intermediate steps here:
DROP VIEW IF EXISTS library_events CASCADE;
CREATE VIEW room_events AS 
SELECT l2.id eventId, l1.library branch
FROM LibraryRoom l1 JOIN LibraryEvent l2 ON l1.id=l2.room;

DROP VIEW IF EXISTS ward_events CASCADE;
CREATE VIEW ward_events AS
SELECT l1.eventId, l1.branch, l2.ward 
FROM library_events l1 JOIN LibraryBranch l2 ON l1.branch = l2.code

-- Your query that answers the question goes below the "insert into" line:
--insert into q4