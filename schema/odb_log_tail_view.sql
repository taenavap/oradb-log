-- Log evaluation view for ODB_LOG table
-- this selects ODB_LOG entries starting from g_tail_id in odb_log_pkg package
-- every access to g_tail_id updates it to the current last value
create or replace force view odb_log_tail as
select
   q2.id
  ,to_char(q2.time_stamp, 'hh24:mi:ss') time_stamp
  ,round(extract(day from q2.timing0)*60*60*24
   + extract(hour from q2.timing0)*60*60
   + extract(minute from q2.timing0)*60
   + extract(second from q2.timing0), 6)
   timing
  ,q2.unit_name
  ,greatest(q2.depth-2, 0) levl
  ,lpad(q2.text, length(q2.text)+greatest(nvl(q2.depth-2, 0), 0)*2, ' ') text
  ,q2.call_stack
  ,q2.module
  ,q2.sid
  ,q2.user_name
from (
select
   q.*
  ,q.time_stamp - q.min_time_stamp timing0
from (
select
   t.*
  ,first_value(t.time_stamp) over (order by t.id) min_time_stamp
from
  odb_log t
where t.id > (select odb_log_pkg.get_tail_id() from dual)
  -- and t.sid = sys_context('userenv','sid')
) q
) q2
order by id
/
