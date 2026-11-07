```julia
SimpleLogger([stream,] min_level=Info)
```

Simplistic logger for logging all messages with level greater than or equal to `min_level` to `stream`. If stream is closed then messages with log level greater or equal to `Warn` will be logged to `stderr` and below to `stdout`.

This Logger is thread-safe, with a lock taken around orchestration of message limits i.e. `maxlog`, and writes to the stream.
