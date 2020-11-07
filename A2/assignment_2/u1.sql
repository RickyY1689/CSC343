-- You must not change the next 2 lines or the table definition.
SET SEARCH_PATH TO Library, public;


-- Do this for each of the views that define your intermediate steps.  
-- (But give them better names!) The IF EXISTS avoids generating an error 
-- the first time this file is imported.
DROP VIEW IF EXISTS intermediate_step CASCADE;


-- You might find this helpful for solving update 1:
-- A mapping between the day of the week and its index
DROP VIEW IF EXISTS day_of_week CASCADE;
CREATE VIEW day_of_week (day, idx) AS
SELECT * FROM (
	VALUES ('sun', 0), ('mon', 1), ('tue', 2), ('wed', 3),
	       ('thu', 4), ('fri', 5), ('sat', 6)
) AS d(day, idx);


-- Define views for your intermediate steps here, and end with a
-- INSERT, DELETE, or UPDATE statement.