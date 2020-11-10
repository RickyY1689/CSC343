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
CREATE VIEW library_events AS 
SELECT l2.id eventId, l1.library branch
FROM LibraryRoom l1 JOIN LibraryEvent l2 ON l1.id=l2.room;

DROP VIEW IF EXISTS ward_events CASCADE;
CREATE VIEW ward_events AS
SELECT l1.eventId, l1.branch, l2.ward 
FROM library_events l1 JOIN LibraryBranch l2 ON l1.branch = l2.code;

-- Get patrons and the events they've signed up for and the associated year
DROP VIEW IF EXISTS attended_events CASCADE;
CREATE VIEW attended_events AS 
SELECT patron, e1.event eventId, EXTRACT(YEAR from edate) eventYear
FROM EventSignUp e1 JOIN EventSchedule e2 ON e1.event = e2.event;

-- Determine the wards associated with each event 
DROP VIEW IF EXISTS attended_events_wards CASCADE;
CREATE VIEW attended_events_wards AS 
SELECT patron, a.eventId, eventYear, ward
FROM attended_events a JOIN ward_events w ON a.eventId = w.eventId;

-- Determine the number of wards a patron has visited in each calander year
DROP VIEW IF EXISTS patron_event_coverage CASCADE;
CREATE VIEW patron_event_coverage AS 
SELECT patron, eventYear, count(DISTINCT ward)
FROM attended_events_wards
GROUP BY patron, eventYear;
-- Your query that answers the question goes below the "insert into" line:
--insert into q4