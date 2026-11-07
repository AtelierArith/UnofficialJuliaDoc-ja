```julia
isdirpath(path::AbstractString)::Bool
```

パスがディレクトリを指しているかどうかを判定します（たとえば、パス区切り文字で終わっている場合）。

# Examples

```jldoctest
julia> isdirpath("/home")
false

julia> isdirpath("/home/")
true
```
