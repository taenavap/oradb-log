-- main log table partitoned by id
-- id index and sequence is left to oracle automation (since Oracle 12c)
create table odb_log
(
   id integer generated always as identity not null
  ,time_stamp timestamp
  ,depth number(4)            -- call stack depth
  ,sid number
  ,user_name varchar2(255)
  ,unit_name varchar2(255)
  ,text varchar2(4000)
  ,call_stack varchar2(4000)
  ,module varchar2(100)
  --,action varchar2(100)
  --,client_identifier varchar2(255)
  --,client_info varchar2(64)
  --,extra clob                 -- text of undifined length (dynamic sql statements)
)
tablespace &log_tablespace
partition by range (id) interval (&log_partition_size) (
partition p1 values less than (&log_partition_size)
)
/
