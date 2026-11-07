```julia
shell_escape_posixly(args::Union{Cmd,AbstractString...})
```

The unexported `shell_escape_posixly` function takes a string or command object and escapes any special characters in such a way that it is safe to pass it as an argument to a posix shell.

See also: [`Base.shell_escape()`](@ref)

# Examples

```jldoctest
julia> Base.shell_escape_posixly("cat", "/foo/bar baz", "&&", "echo", "done")
"cat '/foo/bar baz' '&&' echo done"

julia> Base.shell_escape_posixly("echo", "this", "&&", "that")
"echo this '&&' that"
```
