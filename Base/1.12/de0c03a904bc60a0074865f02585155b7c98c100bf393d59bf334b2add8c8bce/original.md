```julia
shell_escape(args::Union{Cmd,AbstractString...}; special::AbstractString="")
```

The unexported `shell_escape` function is the inverse of the unexported [`Base.shell_split()`](@ref) function: it takes a string or command object and escapes any special characters in such a way that calling [`Base.shell_split()`](@ref) on it would give back the array of words in the original command. The `special` keyword argument controls what characters in addition to whitespace, backslashes, quotes and dollar signs are considered to be special (default: none).

# Examples

```jldoctest
julia> Base.shell_escape("cat", "/foo/bar baz", "&&", "echo", "done")
"cat '/foo/bar baz' && echo done"

julia> Base.shell_escape("echo", "this", "&&", "that")
"echo this && that"
```
