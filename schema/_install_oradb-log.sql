
-- compile for log-level DBG
alter session set plsql_ccflags = 'LOGLEVEL:4';

define log_partition_size = 100000
define log_tablespace = 'USERS'

-- tables
@@odb_log_table.sql

-- packages
@@odb_log_pkg.pks
@@odb_log_pkg.pkb

-- views
@@odb_log_partitions_view.sql
@@odb_log_tail_view.sql
@@odb_log_current_view.sql

-- sample package
@@odb_sample_pkg.pks
@@odb_sample_pkg.pkb

undefine log_partition_size
undefine log_tablespace
