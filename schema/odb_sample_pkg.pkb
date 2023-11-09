create or replace package body odb_sample_pkg
as

  ---------- Instrumentation API ------------

  -- the non-written interface "implements Logging" contract
  -- consisting of
  --    log-level declarations
  --    log calls
  --    optional helper functions
  -- the API implementation is at the bottom of the package
  -- the package structure is thus:
  --    instrumentation API declaration
  --    package logic
  --    instrumentation API implementation

  -- package log level variable
  g_log_level pls_integer := 0;

  -- commonly agreed log levels with specific usage meanings
  TRACE2      boolean;      -- level >= 6   development:  second level detailed (loop) debug
  TRACE       boolean;      -- level >= 5   development:  loop debug, detailed debug
  DBG         boolean;      -- level >= 4   develoment:   non-loop debug
  INFO        boolean;      -- level >= 3   production:   main call entry
  WARN        boolean;      -- level >= 2   production:   notices about anomalies
  ERR         boolean;      -- level >= 1   production:   plsql exception logging

  -- A: non-loop log function
  -- log level is the first parameter of the call:
  -- log(DBG, 'log message');
  procedure log(
     p_log in boolean
    ,p_text in varchar2
    ,p_stack in varchar2 default null
  );

  -- B: loop log function
  -- log level is tested outside log call in an if ... then wrapper:
  -- if TRACE then log('log message');
  -- end if;
  -- can be used also to build a complex log message with extra logic
  procedure log(
     p_text in varchar2
    ,p_stack in varchar2 default null
  );

  -- boolean to string conversion helper
  function bool_to_char(p_value in boolean) return varchar2;



  ---------- Package Code ------------

  MAX_RECURSION pls_integer := 3;


  -- recursive function to seek two consecutive equal dice values
  -- all calls in this function are in-loop due to recursion
  -- the A variant of log call will be used throughout
  function recursive_seek(
     p_levl in pls_integer
    ,p_size  in pls_integer
  ) return pls_integer
  is
    l_seek      pls_integer;        -- random value to match
    l_dice      pls_integer;        -- random dice value (compared to l_seek)
    l_run_limit pls_integer;        -- random limiting value of runs (attempts)
    l_run       pls_integer := 1;   -- run index in the run loop

  begin
    -- function entry, recursive, TRACE
    if TRACE then log('recursive_seek('
      || p_levl||', '|| p_size||
      ')');
    end if;

    -- exception handler logs all errors, including the custom ones when raised
    if  p_levl > MAX_RECURSION  then
      raise_application_error(-20000, 'Maximum recursion exceeded ['||MAX_RECURSION||']');
    end if;

    l_run_limit := round(dbms_random.value(1, p_size));
    l_seek := round(dbms_random.value(1, p_size));
    if TRACE then log('  l_seek:'||l_seek||', l_run_limit:'||l_run_limit);
    end if;

    loop
      l_dice := dbms_random.value(1, p_size);

      -- TRACE2 for second loop within recursion
      if TRACE2 then log('  run['||l_run||']:'||l_dice);
      end if;

      exit when (l_seek = l_dice) or (l_run >= l_run_limit);
      l_run := l_run + 1;

    end loop;

    -- found match
    if l_seek = l_dice then
      if TRACE then log('  found value [seek:'||l_seek||', run:'||l_run||']');
      end if;
      return l_seek;
    end if;

    -- try again
    return recursive_seek(
       p_levl  =>  p_levl + 1
      ,p_size   => p_size
    );

  exception
    when others then
      -- log the function entry parameters (), plus possible internal state values []
      -- note about the sample code:
      --    whether or not a subroutine logs an error and then raises it depends on the surrounding requirements
      --    the reason for error logging is always to capture the function state
      --    with real deep recursion error logging may not be appropriate
      if ERR then
        log('EXCEPTION recursive_seek('
          || p_levl||', '|| p_size||') ['
          ||', '||l_seek||', l_run:'||l_run||', l_dice:'||l_dice||', l_run_limit:'||l_run_limit
          ||']: '||sqlerrm, dbms_utility.format_error_stack());
      end if;
      raise;
  end;



  -- main logic entry initiated by external client
  procedure main_routine(p_size in integer)
  is
    l_input pls_integer;
    l_seek  pls_integer;

  begin
    -- capture external entry call with INFO
    log(INFO, 'main_routine('||p_size||')');

    l_seek := recursive_seek(
       p_levl   => 1
      ,p_size   => p_size
    );

    -- log entry at the end automatically gives timing of the call
    log(DBG, '  found [seek:'||l_seek||']');

  exception
    when others then
      if ERR then
        log('EXCEPTION main_routine('|| p_size||') []'
          ||sqlerrm, dbms_utility.format_error_stack());
      end if;
      raise;

  end;



  ---------- Instrumentation API -----------
  
  procedure log(p_text in varchar2, p_stack in varchar2)
  is
  begin
    odb_log_pkg.log(p_text, utl_call_stack.dynamic_depth(), $$PLSQL_UNIT, p_stack);
  end;
  
  procedure log(p_log in boolean, p_text in varchar2, p_stack in varchar2)
  is
  begin
    if p_log then
      odb_log_pkg.log(p_text, utl_call_stack.dynamic_depth(), $$PLSQL_UNIT, p_stack);
    end if;
  end;
  
  function bool_to_char(p_value in boolean) return varchar2
  is
  begin
    return case when p_value then 'true' when not p_value then 'false' end;
  end;
  
  function get_loglevel return pls_integer
  is
  begin
    return g_log_level;
  end;
  
  procedure set_loglevel(p_level in pls_integer)
  is
  begin
    g_log_level := nvl(p_level, 0);
    TRACE2      := g_log_level >= 6;
    TRACE       := g_log_level >= 5;
    DBG         := g_log_level >= 4;
    INFO        := g_log_level >= 3;
    WARN        := g_log_level >= 2;
    ERR         := g_log_level >= 1;
  end;
  
begin
  -- alter session set plsql_ccflags = 'LOGLEVEL:4';
  set_loglevel($$LOGLEVEL);

end;
/