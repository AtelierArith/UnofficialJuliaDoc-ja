```julia
ConsoleLogger([stream,] min_level=Info; meta_formatter=default_metafmt,
              show_limited=true, right_justify=0)
```

Logger with formatting optimized for readability in a text console, for example interactive work with the Julia REPL.

Log levels less than `min_level` are filtered out.

This Logger is thread-safe, with locks for both orchestration of message limits i.e. `maxlog`, and writes to the stream.

Message formatting can be controlled by setting keyword arguments:

  * `meta_formatter` is a function which takes the log event metadata `(level, _module, group, id, file, line)` and returns a color (as would be passed to printstyled), prefix and suffix for the log message.  The default is to prefix with the log level and a suffix containing the module, file and line location.
  * `show_limited` limits the printing of large data structures to something which can fit on the screen by setting the `:limit` `IOContext` key during formatting.
  * `right_justify` is the integer column which log metadata is right justified at. The default is zero (metadata goes on its own line).
