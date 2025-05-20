```
arg_isdir(f::Function, arg::AbstractString) -> f(arg)
```

The `arg_isdir` function takes `arg` which must be the path to an existing directory (an error is raised otherwise) and passes that path to `f` finally returning the result of `f(arg)`. This is definitely the least useful tool offered by `ArgTools` and mostly exists for symmetry with `arg_mkdir` and to give consistent error messages.
