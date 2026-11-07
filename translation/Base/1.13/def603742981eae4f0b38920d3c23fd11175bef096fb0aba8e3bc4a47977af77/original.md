```julia
rstrip_shell(s::AbstractString)
```

Strip trailing whitespace from a shell command string, while respecting a trailing backslash followed by a space ("\ ").

```jldoctest
julia> Base.rstrip_shell("echo 'Hello World' \\ ")
"echo 'Hello World' \\ "

julia> Base.rstrip_shell("echo 'Hello World'    ")
"echo 'Hello World'"
```
