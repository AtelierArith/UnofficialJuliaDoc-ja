```julia
shell_split(command::AbstractString)
```

Split a shell command string into its individual components.

# Examples

```jldoctest
julia> Base.shell_split("git commit -m 'Initial commit'")
4-element Vector{String}:
 "git"
 "commit"
 "-m"
 "Initial commit"
```
