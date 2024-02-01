## oradb-log

#### Minimalistic logging for Oracle database development. 


Developing business logic in Oracle using SQL and PL/SQL is the right choice for data intensive power user applications. The freedom and directness of Oracle development means that there is little pre-existing application framework code, unlike Java for example.

oradb-log is a blueprint for a minimalistic PL/SQL logging framework, free of (Java) bloat. The oradb-log philosophy is:

- **Oracle can effortlessly log into the database -- use it.** If you feel you need file logging, then your business logic should probably be implemented outside the database.

- **Zero configuration.** All code, including scripts and anonymous code blocks, can use logging without first having to declare their interest.

- **Implicit "implements logging" interface.** Client code uses logging by way of a common usage agreement. This primarily defines the log levels and their correct usage, so that the levels have the same meaning and behaviour throughout the application.

- **Log message is a line of text.** The task of assembling the message from the various inputs is the job of the client, not the logging framework. Formatting is a matter of best practice.



### Features

- **Log output indentation.** The log output views indent the messages according to the stack depth of the call. The indentation is automatic and does not require any input in the instrumentation.

- **Log output tail.** A "tail" view of the log shows the output from the last call (since the view was last queried).

- **Automatic timing.** Timing is provided by the simple inclusion of a timestamp column in the log. This can be evaluated as needed. In a tail view, it directly shows the run time of a call.

- **Oracle automation in log management.** Oracle partitioning and auto sequence are used for log table management.

- **Compile time log level setting.** A conditional compilation parameter sets the default log level at compile time (depending on the deployment environment). The level can then be dynamically controlled in code.




### Install and try

The `_install_oradb-log.sql` script installs the framework objects and a sample usage package.

Select and run individual commands from the `log_sample_usage.sql` script to produce log output. Run the tail query in `log_evaluation.sql` to view the output.

The `_uninstall_oradb-log.sql` script removes all objects created in the install.



### Summary

The code here is an example of a minimalist approach to instrumentation, designed for focused, intensive logging in data-driven development. At the same time it is production ready, nothing needs to be changed for production. The instrumentation used in the example is development oriented. Production code can include logs to capture data anomalies or provide timings for code performance analysis.

The sample code is ideal in an environment where developers have their own personal development schema. If the development schema is shared, the evaluation views may need additional filtering.

This project is not in development. The code is intended as a blueprint example for custom implementations.



