```julia
shell_split(command::AbstractString)
```

シェルコマンド文字列をその個々のコンポーネントに分割します。

# 例

```jldoctest
julia> Base.shell_split("git commit -m 'Initial commit'")
4-element Vector{String}:
 "git"
 "commit"
 "-m"
 "Initial commit"
```
