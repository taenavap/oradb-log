-- List partitions of ODB_LOG table
--
create or replace force view odb_log_partitions
as
with
  -- long to number conversion
  function get_numeric_high_value(
     p_table_name in varchar2
    ,p_partition_name in varchar2
  ) return number
  is
    l_high_value long;
  begin
    select t.high_value into l_high_value from user_tab_partitions t
    where t.table_name = p_table_name
      and t.partition_name = p_partition_name;
    return to_number(to_clob(l_high_value));
  end;
-- main select
select
   q2.table_name
  ,q2.partition_name
  ,q2.pos
  ,q2.high_value
  ,q2.from_id
   -- timestamp of the first log entry in partition
  ,(select t.time_stamp
    from odb_log t where t.id = q2.from_id)         from_timestmp
from (
select
   q.*
   -- id of the first log entry in partition
  ,greatest(1, q.high_value - &log_partition_size)  from_id
from (
select
   p.table_name
  ,p.partition_name
  ,p.partition_position                             pos
  ,get_numeric_high_value(
      p.table_name, p.partition_name)               high_value
from user_tab_partitions p
where p.table_name = 'ODB_LOG'
) q
) q2
/