create or replace package body odb_log_pkg
as
  
  -- variables for log() function
  --  set by init_on_load()
  g_sid         number;
  g_username    varchar2(32);
  g_module      varchar2(64);
  
  -- variables for evaluation views
  g_current_id  integer;
  g_tail_id     integer;
  g_max_id      integer;
  
  
  ---------- LOCAL DECLARATIONS
  
  procedure init_on_load;
  
  
  
  
  ---------- PUBLIC IMPLEMENTATIONS
  
  
  -- main log procedure
  procedure log(
     p_text   in varchar2   -- log text
    ,p_depth  in number     -- stack depth (for indentation)
    ,p_unit   in varchar2   -- package name
    ,p_stack  in varchar2   -- error stack when logging an error
    ,p_extra  in clob       -- sql statements or other long text
  )
  is
    pragma autonomous_transaction;
  begin
    insert into odb_log (
       time_stamp
      ,depth
      ,sid
      ,user_name
      ,unit_name
      ,module
      ,text
      ,call_stack
      --,extra
    )
    values (
       systimestamp
      ,p_depth
      ,g_sid
      ,g_username
      ,p_unit
      ,g_module
      ,p_text
      ,p_stack
      --,p_extra
    );
    commit;
  exception
    when others then
      rollback;
      raise;
  end;



  -- select max(id) from PTO_LOG table
  function get_log_max_id return integer
  is
    l_max_id integer;
  begin
    -- Note: the select only touches the last partition
    select max(id) into l_max_id from odb_log;
    return l_max_id;
  end;



  -- return package max_id and update the value for the next call
  -- subsequent calls return the value updated in the previous call
  function get_tail_id return integer
  is
    l_max_id integer;
  begin
    l_max_id := get_log_max_id();
    if l_max_id = g_max_id then null;
    else
      g_tail_id :=
        case 
        when g_max_id is null then l_max_id - 1
        else g_max_id
        end;
      g_max_id := l_max_id;
    end if;
    return g_tail_id;
  end;



  -- returns package current_id, defaulting to tail_id
  -- subsequent calls return same value
  function get_current_id return integer
  is
    l_max_id integer;
  begin
    if g_current_id is null then
      g_current_id := get_tail_id();
    end if;
    return g_current_id;
  end;



  -- manual update of the id values for evaluation views
  procedure set_tail_id(p_value in number)
  is
  begin
    g_tail_id := p_value;
  end;
  --
  procedure set_current_id(p_value in number)
  is
  begin
    g_current_id := p_value;
  end;



  ----------- LOCAL IMPLEMENTATIONS -----------

  procedure init_on_load
  is
  begin
    select
       sys_context('userenv','sid')
      ,sys_context('userenv','module')
    into
       g_sid
      ,g_module
    from dual;
    g_username  := user;
  end;    
  
begin
  init_on_load();
  
end;
/