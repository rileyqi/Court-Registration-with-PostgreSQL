-- CSC461 Homework assignment 6c
-- QI TANG
-- NetID: qtang
--
--Court Reservation System
--

--league member

DROP TABLE IF EXISTS League_Member CASCADE;

create table League_Member (
 mem_id		INTEGER PRIMARY KEY --member's ID
,name		CHAR(40)		--the name of league member		
 );


--penalty

DROP TABLE IF EXISTS penalty CASCADE;

create table Penalty (
 penalty_id		INTEGER PRIMARY KEY
,mem_id			INTEGER
,start_date		DATE 		--the date member gets the penalty
,end_date		DATE 		--the date for the penalty becomes invalid
,FOREIGN KEY (mem_id) REFERENCES League_Member (mem_id) ON UPDATE CASCADE ON DELETE CASCADE
);


--court

DROP TABLE IF EXISTS court CASCADE;

create table Court (
 court_id		INTEGER  PRIMARY KEY
,location		CHAR(20)			
);


--registration

DROP TABLE IF EXISTS registration CASCADE;
	
create table Registration (
 reg_id		INTEGER PRIMARY KEY		--registration ID
,play_date	DATE 					--the date members apply to play on
,time_slot 	TIME  			--the time slot members want to use the court
CHECK (time_slot = '9:00' or 
	time_slot = '10:00' or
	time_slot = '11:00' or
	time_slot = '12:00' or
	time_slot = '13:00' or
	time_slot = '14:00' or
	time_slot = '15:00' or
	time_slot = '16:00' or
	time_slot = '17:00' or
	time_slot = '18:00' or
	time_slot = '19:00' or
	time_slot = '20:00' or
	time_slot = '21:00')
,court_id	INTEGER  
,mem_id		INTEGER
,update_status		CHAR(10)		--the registration could be booked, confirmed, canceled or dropped
,apply_date	TIMESTAMP 					--date the registration was made

,FOREIGN KEY (mem_id) REFERENCES League_Member (mem_id) ON UPDATE CASCADE ON DELETE CASCADE
,FOREIGN KEY (court_id) REFERENCES Court (court_id) ON UPDATE CASCADE ON DELETE SET NULL
);




--view
CREATE VIEW penalty_points AS
SELECT mem_id, COUNT(end_date > current_date) AS penalty_point, (7 - COUNT(end_date > current_date)) AS lead_time
FROM Penalty
GROUP BY mem_id;





--trigger
CREATE OR REPLACE FUNCTION insert_reservation() RETURNS TRIGGER as $insert_reservation$
    BEGIN
    	--no two reservations can be set at the same court on the exactely same time
            IF (select count(*) from Registration where (update_status = 'booked' or update_status = 'confirmed') 
            	and NEW.play_date = play_date and NEW.court_id = court_id and New.time_slot = time_slot) <> 0 THEN
            RAISE EXCEPTION 'The court is not available at this time';
        END IF;
        --member whose penalty points larger than 8 can not make a reservation
        	IF new.mem_id IN (select mem_id from Penalty group by mem_id having count(end_date > current_date) >=8) THEN
        	RAISE EXCEPTION 'You can not book court now';
        END IF;
        --the lead time constrain
        	IF new.play_date > new.apply_date::date + (select lead_time from penalty_points where new.mem_id = mem_id)::INTEGER THEN
        	RAISE EXCEPTION 'You can not make reservations exceed your lead_time';
        END IF;
        RETURN NEW;
    END;
$insert_reservation$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS insert_reservation ON Registration;
CREATE TRIGGER insert_reservation BEFORE INSERT ON Registration
    FOR EACH ROW EXECUTE PROCEDURE insert_reservation();


CREATE OR REPLACE FUNCTION update_reservation() RETURNS TRIGGER as $update_reservation$
    BEGIN
    --only before 20min or after 10min of the play_time can members update their status
    	IF ((old.play_date + old.time_slot > localtimestamp + interval '20 minutes') or (old.play_date + old.time_slot < localtimestamp - interval'10 minutes'))
    	and new.update_status = 'confirmed' THEN
    	RAISE EXCEPTION 'You can not confirm right now';
    	END IF;
    --only after 10 min of the play_time can the update_status become dropped
    	IF old.play_date + old.time_slot > localtimestamp - interval'10 minutes'
    	and new.update_status = 'dropped' THEN
    	RAISE EXCEPTION 'You can not drop right now';
    	END IF;
    --only before the play_date can members cancel their reservations
    	IF old.play_date + old.time_slot < localtimestamp
    	and new.update_status = 'canceled' THEN
    	RAISE EXCEPTION 'You can not cancel right now';
    	END IF;
    	RETURN NEW;
    END;
$update_reservation$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS update_reservation ON Registration;
CREATE TRIGGER update_reservation BEFORE UPDATE OF update_status ON Registration
    FOR EACH ROW EXECUTE PROCEDURE update_reservation();











