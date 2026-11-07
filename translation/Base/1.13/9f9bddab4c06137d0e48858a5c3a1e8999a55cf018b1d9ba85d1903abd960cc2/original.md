```julia
open(command, mode::AbstractString, stdio=devnull)
```

Run `command` asynchronously. Like `open(command, stdio; read, write)` except specifying the read and write flags via a mode string instead of keyword arguments. Possible mode strings are:

| Mode | Description | Keywords                    |
|:---- |:----------- |:--------------------------- |
| `r`  | read        | none                        |
| `w`  | write       | `write = true`              |
| `r+` | read, write | `read = true, write = true` |
| `w+` | read, write | `read = true, write = true` |
