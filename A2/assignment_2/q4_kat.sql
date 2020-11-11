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
--DROP VIEW IF EXISTS intermediate_step CASCADE;

-- Define views for your intermediate steps here:

--1. Find events that occurred at each library
DROP VIEW IF EXISTS EventLocation CASCADE;
CREATE VIEW EventLocation AS
SELECT le.room, library, le.id AS eventID
FROM LibraryRoom lr JOIN LibraryEvent le 
ON le.room = lr.id;

--2. Find events that occurred at each ward and sort by ward
DROP VIEW IF EXISTS EventWards CASCADE;
CREATE VIEW EventWards AS
SELECT lb.code, eventid, ward
FROM EventLocation el CROSS JOIN LibraryBranch lb 
WHERE el.library = lb.code
ORDER BY ward;

--3. Find events that each person went to and get the wards
DROP VIEW IF EXISTS EventPatron CASCADE;
CREATE VIEW EventPatron AS 
SELECT event, ward, patron
FROM eventward ew CROSS JOIN eventsignup su
WHERE ew.eventid = su.event
ORDER BY patron;

--4.
DROP VIEW IF EXISTS PatronWards CASCADE;
CREATE VIEW PatronWards AS
SELECT patron, (extract(year from edate)), ward
FROM eventschedule natural join eventpatron
GROUP BY patron, (EXTRACT(year from edate))
ORDER BY patron;


-- Your query that answers the question goes below the "insert into" line:
insert into q4


--5. find # of distinct wards per calendar year

SELECT distinct patron
FROM PatronWards
GROUP BY patron, date_part
HAVING count(distinct ward) =
    (SELECT count(distinct ward) 
    FROM librarybranch);