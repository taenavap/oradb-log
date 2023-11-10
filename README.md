## oradb-log

#### Minimalistic logging for Oracle database development. 


Business logic development in Oracle with SQL and PL/SQL is the right choice for data intensive power user applications. The freedom and directness of Oracle development means that there is little pre-existing application framework code, in contrast to Java for example.

oradb-log is a blueprint for a minimalistic PL/SQL logging framework, free of (Java) bloat. The oradb-log philosophy is:

- **Oracle can effortlessly log into the database -- use it.** If you feel you need file logging then your business logic probably should be implemented outside database.

- **Zero configuration.** All code, including scripts and anonymous code blocks can use logging without having to declare their interest beforehand.

- **Implicit "implements logging" interface.** Client code uses logging by way of a common usage agreement. In the first place, this defines the log levels and their correct usage, so that levels have the same meaning and behaviour throughout application.

- **Log message is a line of text.** The task of building up the message from various input pieces is the job of the client, not the logging framework. Formatting is a matter of best practice.



### Features

- **Log output indentation.** The log output views indent the messages according to the stack depth of the call. The indentation is automatic and does not require any input in instrumentation.

- **Log output tail.** A "tail" view of log shows the output from the last call (since the view was last queried).

- **Automatic timing.** Timing is provided by the simple inclusion of a timestamp column in the log. This can be evaluated as needed. In a tail view it directly gives the run time of a call.

- **Oracle automation in log management.** Oracle partitioning and auto sequence are used for log table management.

- **Compile time log level setting.** A conditional compilation parameter sets the default log level in compile time (depending on deployment environment). The level can thereafter be controlled dynamically in code.




### Install and try

The `_install_oradb-log.sql` script installs the framework objects and a sample usage package.

Select and run individual commands from the script `log_sample_usage.sql` to produce log output. Run the tail query in `log_evaluation.sql` to see the output.

The `_uninstall_oradb-log.sql` script removes all objects created in install.



### Summary

The code here is an example of a minimalistic approach to instrumentation, designed for purposeful intensive logging in data driven development. At the same time it is production ready, nothing needs to be modified for production. The sample usage instrumentation is geared for development. In production, the logs can equally capture data anomalies, or provide timings for code performance analysis.

The given example suits ideally in an environment where developers have their own personal development schemas. When development schema is shared the evaluation views may need extra filtering.

This project is not in development. Code is intended as a blueprint example for custom implementations.



