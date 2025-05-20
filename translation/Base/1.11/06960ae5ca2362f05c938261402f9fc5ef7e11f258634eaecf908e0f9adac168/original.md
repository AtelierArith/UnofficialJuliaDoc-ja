```
setenv(command::Cmd, env; dir)
```

Set environment variables to use when running the given `command`. `env` is either a dictionary mapping strings to strings, an array of strings of the form `"var=val"`, or zero or more `"var"=>val` pair arguments. In order to modify (rather than replace) the existing environment, create `env` through `copy(ENV)` and then setting `env["var"]=val` as desired, or use [`addenv`](@ref).

The `dir` keyword argument can be used to specify a working directory for the command. `dir` defaults to the currently set `dir` for `command` (which is the current working directory if not specified already).

See also [`Cmd`](@ref), [`addenv`](@ref), [`ENV`](@ref), [`pwd`](@ref).
