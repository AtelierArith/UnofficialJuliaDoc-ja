```julia
isabspath(path::AbstractString) -> Bool
```

パスが絶対パスであるかどうかを判断します（ルートディレクトリから始まる）。

# 例

```jldoctest
julia> isabspath("/home")
true

julia> isabspath("home")
false
```
