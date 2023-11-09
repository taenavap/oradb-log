

exec odb_log_pkg.log('text message');
/

-- 1 ERR, 2 WARN, 3 INFO, 4 DBG, 5 TRACE, 6 TRACE2
exec odb_sample_pkg.set_loglevel(6)
/

-- sample instrumented procedure call
declare
  procedure log(p_text in varchar2, p_stack in varchar2 default null)
  is
  begin
    odb_log_pkg.log(p_text, utl_call_stack.dynamic_depth(), 'log_sample_usage.sql', p_stack);
  end;
begin
  log('Start: test routine');
  odb_sample_pkg.main_routine(
     p_size => 12
  );
  log('Done: test routine');
exception
  when others then
    log('EXCEPTION: '||sqlerrm, dbms_utility.format_error_stack());
    raise;
end;
/
