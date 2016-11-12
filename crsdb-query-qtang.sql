-- CSC461 Homework assignment 6c
-- QI TANG
-- NetID: qtang
--
--Court Reservation System
--


--a.List all of today's reservations (members, times, courts and confirmation status). This might be what the receptionist prints and posts every morning.
select mem_id, play_date, time_slot, court_id, update_status
from Registration
where play_date = current_date and update_status <> 'canceled'
order by time_slot;

--b.Show all of member m's reservations (minimally 3; show times, courts and confirmation status) for the next 7 days. Include p: the current number of penalty points incurred by m (must be > 1 for member m).
select mem_id, play_date, time_slot, court_id, update_status, a.count as Penalty_point
from Registration natural join (
select mem_id, count(end_date > current_date)
from Penalty
group by mem_id) as a 
where mem_id = '10001123' and play_date <= current_date + integer'7' and play_date > current_date;

--c1.Add a reservation for member m for some court at some time t for n days from today, where n + p > 7. 
insert into Registration
values('876855','2016-04-18','15:00','113','10001123','booked','2016-04-12 11:30:00');

--c2.Repeat with a different n such that n + p <= 7.
insert into Registration
values('876800','2016-04-14','15:00','113','10001123','booked','2016-04-10 11:30:00');

--d.Confirm member m's next reservation.
update Registration
set update_status = 'confirmed'
where (play_date + time_slot) in 
(select min(play_date + time_slot) from Registration where mem_id = '10001123' and (play_date + time_slot) >= localtimestamp and update_status = 'booked'); 

--e.Cancel one of member m's upcoming reservations.
update Registration
set update_status = 'canceled'
where mem_id = '10001123' and play_date = (current_date + 1);

--f.Show all of m's reservations again, as before.
select mem_id, play_date, time_slot, court_id, update_status, a.count as Penalty_point
from Registration natural join (
select mem_id, count(end_date > current_date)
from Penalty
group by mem_id) as a 
where mem_id = '10001123' and play_date <= current_date + integer'7' and play_date > current_date;

--g.Add any additional queries and commands you deem appropriate to show off the effectiveness of your constraints.

--g1.only before 20min or after 10min of the play_time can members update their status
update Registration
set update_status = 'confirmed'
where reg_id = '876867';

--g2.no two reservations can be set at the same court on the exactely same time
insert into Registration
values('876880','2016-04-19','13:00','112','10001123','booked','2016-04-14 15:23:54');

--g3.the lead time constrain
insert into Registration
values('876806','2016-04-18','15:00','111','10001234','booked','2016-04-11 16:23:54');

--g4.member whose penalty points larger than 8 can not make a reservation
insert into Penalty
values('20160415','10001123','2016-04-15', date'2016-04-15' + integer'42');

insert into Penalty
values('20160411','10001123','2016-04-11', date'2016-04-11' + integer'42');

insert into Penalty
values('20160412','10001123','2016-04-12', date'2016-04-12' + integer'42');

insert into Penalty
values('20160413','10001123','2016-04-13', date'2016-04-13' + integer'42');

insert into Penalty
values('20160414','10001123','2016-04-14', date'2016-04-14' + integer'42');

insert into Registration
values('876834','2016-04-20','15:00','113','10001123','booked','2016-04-15 11:30:00');



