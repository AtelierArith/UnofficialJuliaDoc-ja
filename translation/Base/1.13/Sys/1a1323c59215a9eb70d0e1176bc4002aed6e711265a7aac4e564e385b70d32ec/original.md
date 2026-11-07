```julia
Sys.which(program_name::String)
```

Given a program name, search the current `PATH` to find the first binary with the proper executable permissions that can be run and return an absolute path to it, or return `nothing` if no such program is available. If a path with a directory in it is passed in for `program_name`, tests that exact path for executable permissions only (with `.exe` and `.com` extensions added on Windows platforms); no searching of `PATH` is performed.
