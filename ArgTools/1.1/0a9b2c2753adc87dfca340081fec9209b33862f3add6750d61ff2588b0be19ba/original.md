```julia
arg_mkdir(f::Function, arg::AbstractString) -> arg
arg_mkdir(f::Function, arg::Nothing) -> mktempdir()
```

The `arg_mkdir` function takes `arg` which must either be one of:

  * a path to an already existing empty directory,
  * a non-existent path which can be created as a directory, or
  * `nothing` in which case a temporary directory is created.

In all cases the path to the directory is returned. If an error occurs during `f(arg)`, the directory is returned to its original state: if it already existed but was empty, it will be emptied; if it did not exist it will be deleted.
