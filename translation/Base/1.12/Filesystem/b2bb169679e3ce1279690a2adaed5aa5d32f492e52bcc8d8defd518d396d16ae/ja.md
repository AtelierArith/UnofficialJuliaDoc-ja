```julia
isdirpath(path::AbstractString) -> Bool
```

パスがディレクトリを指しているかどうかを判断します（例えば、パスセパレータで終わる場合）。

# 例

```jldoctest
julia> isdirpath("/home")
false

julia> isdirpath("/home/")
true
```
