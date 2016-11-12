-- CSC461 Homework assignment 6c
-- QI TANG
-- NetID: qtang
--
--Court Reservation System
--

--league member
insert into League_Member
values('10001234','JANE');
insert into League_Member
values('10001111','MAY');
insert into League_Member
values('10001123','JUNO');
insert into League_Member
values('10001456','RILEY');

--penalty
insert into Penalty
values('20160101','10001234','2016-04-01', date'2016-04-01' + integer'42');

insert into Penalty
values('20160102','10001234','2016-04-02', date'2016-04-02' + integer'42');

insert into Penalty
values('20160401','10001123','2016-04-01', date'2016-04-01' + integer'42');

insert into Penalty
values('20160404','10001123','2016-04-04', date'2016-04-04' + integer'42');

insert into Penalty
values('20160410','10001123','2016-04-10', date'2016-04-10' + integer'42');

--Court
insert into Court
values('111','river_road');

insert into Court
values('112','crittenden_road');

insert into Court
values('113','campus_road');

insert into Court
values('114','driver_road');

--registration
insert into Registration
values('876856','2016-04-14','10:00','112','10001456','confirmed','2016-04-10 13:00:00');

insert into Registration
values('876876','2016-04-16','9:00','111','10001123','booked','2016-04-12 10:23:54');

insert into Registration
values('876898','2016-04-15','20:00','113','10001123','booked','2016-04-11 17:00:00');

insert into Registration
values('876834','2016-04-17','15:00','113','10001123','booked','2016-04-13 11:30:00');

insert into Registration
values('876867','2016-04-15','9:00','112','10001111','confirmed','2016-04-12 10:23:54');

insert into Registration
values('876809','2016-04-18','16:00','111','10001234','canceled','2016-04-14 11:23:54');

insert into Registration
values('876888','2016-04-19','13:00','112','10001456','booked','2016-04-13 15:23:54');



