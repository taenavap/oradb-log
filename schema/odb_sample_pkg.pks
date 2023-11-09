create or replace package odb_sample_pkg
as


  ---------- Package Code ------------

  procedure main_routine(p_size in integer);



  function get_loglevel return pls_integer;
  procedure set_loglevel(p_level in pls_integer);


end;
/