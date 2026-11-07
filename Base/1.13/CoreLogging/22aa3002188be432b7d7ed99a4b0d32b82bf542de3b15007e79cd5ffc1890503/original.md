```julia
handle_message(logger, level, message, _module, group, id, file, line; key1=val1, ...)
```

Log a message to `logger` at `level`.  The logical location at which the message was generated is given by module `_module` and `group`; the source location by `file` and `line`. `id` is an arbitrary unique value (typically a [`Symbol`](@ref)) to be used as a key to identify the log statement when filtering.
