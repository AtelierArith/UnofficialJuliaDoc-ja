```julia
global_logger()
```

Return the global logger, used to receive messages when no specific logger exists for the current task.

```julia
global_logger(logger)
```

Set the global logger to `logger`, and return the previous global logger.
