```julia
shell_split(command::AbstractString)
```

シェルコマンド文字列を個々の要素に分割します。

# Examples

```jldoctest
julia> Base.shell_split("git commit -m 'Initial commit'")
4-element Vector{String}:
 "git"
 "commit"
 "-m"
 "Initial commit"
```
