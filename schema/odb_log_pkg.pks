create or replace package odb_log_pkg
as

  procedure log(
     p_text   in varchar2
    ,p_depth  in number   default 0
    ,p_unit   in varchar2 default null
    ,p_stack  in varchar2 default null
    ,p_extra  in clob default null
  );
  
  
  function get_log_max_id return integer;
  function get_tail_id return integer;
  function get_current_id return integer;
  
  procedure set_tail_id(p_value in number);
  procedure set_current_id(p_value in number);

end;
/