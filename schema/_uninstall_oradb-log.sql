-- this uninstalls the pto_ logging objects

-- sample usage package
drop package odb_sample_pkg
/

-- views
drop view odb_log_partitions
/
drop view odb_log_tail
/
drop view odb_log_current
/

--
drop package odb_log_pkg
/

drop table odb_log purge
/
