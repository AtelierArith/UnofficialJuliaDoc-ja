```julia
arg_read(f::Function, arg::ArgRead) -> f(arg_io)
```

The `arg_read` function accepts an argument `arg` that can be any of these:

  * `AbstractString`: a file path to be opened for reading
  * `AbstractCmd`: a command to be run, reading from its standard output
  * `IO`: an open IO handle to be read from

Whether the body returns normally or throws an error, a path which is opened will be closed before returning from `arg_read` and an `IO` handle will be flushed but not closed before returning from `arg_read`.

Note: when opening a file, ArgTools will pass `lock = false` to the file `open(...)` call. Therefore, the object returned by this function should not be used from multiple threads. This restriction may be relaxed in the future, which would not break any working code.
