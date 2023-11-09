-- execute commands by selecting them individually


-- usage of log_tail, the main development log view
col unit_name for a30
col text for a100
col call_stack for a40
col user_name for a20
col levl for 9999
set pages 100
--
select id, timing, unit_name, levl, text, user_name from odb_log_tail
/


--  usage of current_id (not tailing)
select odb_log_pkg.get_current_id() from dual
/
-- fix current_id to desired value
exec odb_log_pkg.set_current_id(63000-1)
/
select id, time_stamp, timing, unit_name, levl, text, call_stack, user_name from odb_log_current
/


-- select from one partition (for content analysis)
select * from odb_log partition (SYS_P334)
/





-- partition management
------------------------------------------

-- inspect partitions
select t.* from odb_log_partitions t
/
-- drop a partion
alter table odb_log drop partition P1
/
