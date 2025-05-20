```
arg_write(f::Function, arg::ArgWrite) -> arg
arg_write(f::Function, arg::Nothing) -> tempname()
```

The `arg_read` function accepts an argument `arg` that can be any of these:

  * `AbstractString`: a file path to be opened for writing
  * `AbstractCmd`: a command to be run, writing to its standard input
  * `IO`: an open IO handle to be written to
  * `Nothing`: a temporary path should be written to

If the body returns normally, a path that is opened will be closed upon completion; an IO handle argument is left open but flushed before return. If the argument is `nothing` then a temporary path is opened for writing and closed open completion and the path is returned from `arg_write`. In all other cases, `arg` itself is returned. This is a useful pattern since you can consistently return whatever was written, whether an argument was passed or not.

If there is an error during the evaluation of the body, a path that is opened by `arg_write` for writing will be deleted, whether it's passed in as a string or a temporary path generated when `arg` is `nothing`.

Note: when opening a file, ArgTools will pass `lock = false` to the file `open(...)` call. Therefore, the object returned by this function should not be used from multiple threads. This restriction may be relaxed in the future, which would not break any working code.
